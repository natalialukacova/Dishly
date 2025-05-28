import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/theme.dart';
import '../widgets/ingredient_input.dart';

class AIRecipeGeneratorScreen extends StatefulWidget {
  const AIRecipeGeneratorScreen({super.key});

  @override
  State<AIRecipeGeneratorScreen> createState() => _AIRecipeGeneratorScreenState();
}

class _AIRecipeGeneratorScreenState extends State<AIRecipeGeneratorScreen> {
  final TextEditingController _ideaController = TextEditingController();
  String? _generatedRecipe;
  bool _isLoading = false;
  bool _hasGenerated = false;

  Future<void> _generateRecipe() async {
    final idea = _ideaController.text.trim();
    if (idea.isEmpty) return;

    setState(() {
      _isLoading = true;
      _generatedRecipe = null;
      _hasGenerated = true;
    });

    final response = await http.post(
      Uri.parse('http://192.168.0.145:8000/generate_recipe'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"idea": idea}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() => _generatedRecipe = data["recipe"]);
    } else {
      setState(() => _generatedRecipe = "⚠️ Failed to generate recipe.");
    }

    setState(() => _isLoading = false);
  }

  Widget _buildRecipeView(String raw) {
    final lines = raw.split('\n');
    String title = "";
    List<String> ingredients = [];
    List<String> instructions = [];

    String currentSection = "";

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (line.startsWith("### ")) {
        final section = line.substring(4).toLowerCase();
        if (section.contains("ingredients")) {
          currentSection = "ingredients";
        } else if (section.contains("instructions")) {
          currentSection = "instructions";
        } else {
          // If not "ingredients" or "instructions", assume this is the title
          currentSection = "";
          if (title.isEmpty) title = line.substring(4).trim();
        }
        continue;
      }

      if (currentSection == "ingredients" && line.startsWith("- ")) {
        ingredients.add(line.substring(2));
      } else if (currentSection == "instructions" && RegExp(r'^\d+\.\s').hasMatch(line)) {
        instructions.add(line);
      }

      // Catch description right after title
      if (title.isNotEmpty && currentSection == "" && line.isNotEmpty && !line.startsWith("- ") && !RegExp(r'^\d+\.\s').hasMatch(line)) {
        title += "\n" + line;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 16),
        if (ingredients.isNotEmpty) ...[
          const Text("🧂 Ingredients", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ...ingredients.map((i) => Text("• $i")).toList(),
          const SizedBox(height: 16),
        ],
        if (instructions.isNotEmpty) ...[
          const Text("🔪 Instructions", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ...instructions.map((step) => Text(step)).toList(),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("AI Recipe Generator"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            IngredientInput(controller: _ideaController),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _generateRecipe,
              icon: const Icon(Icons.auto_awesome, color: Colors.white),
              label: const Text("Generate"),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (!_hasGenerated)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lightbulb_outline, size: 80, color: primaryColor),
                      const SizedBox(height: 16),
                      Text(
                        "Give me an idea and I’ll cook up a recipe!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              )
            else if (_generatedRecipe != null)
                Expanded(
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    margin: const EdgeInsets.only(top: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: _buildRecipeView(_generatedRecipe!),
                      ),
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }
}