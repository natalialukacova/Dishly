import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/theme.dart';

class AIRecipeGeneratorScreen extends StatefulWidget {
  const AIRecipeGeneratorScreen({super.key});

  @override
  State<AIRecipeGeneratorScreen> createState() => _AIRecipeGeneratorScreenState();
}

class _AIRecipeGeneratorScreenState extends State<AIRecipeGeneratorScreen> {
  final TextEditingController _ideaController = TextEditingController();
  final List<String> _dietaryOptions = ["Vegan", "Vegetarian", "Gluten-Free"];
  final Set<String> _selectedFilters = {};
  String? _generatedRecipe;
  bool _isLoading = false;

  Future<void> _generateRecipe() async {
    final idea = _ideaController.text.trim();
    if (idea.isEmpty) return;

    setState(() {
      _isLoading = true;
      _generatedRecipe = null;
    });

    final response = await http.post(
      Uri.parse('http://192.168.0.145:8000/generate_recipe'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "idea": idea,
        "dietary": _selectedFilters.toList()
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() => _generatedRecipe = data["recipe"]);
    } else {
      setState(() => _generatedRecipe = "⚠️ Failed to generate recipe.");
    }

    setState(() => _isLoading = false);
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
            TextField(
              controller: _ideaController,
              decoration: const InputDecoration(
                labelText: "🧺 Enter ingredients or idea",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: _dietaryOptions.map((diet) {
                  final selected = _selectedFilters.contains(diet);
                  return FilterChip(
                    label: Text(diet),
                    selected: selected,
                    selectedColor: primaryColor.withOpacity(0.2),
                    onSelected: (bool value) {
                      setState(() {
                        value ? _selectedFilters.add(diet) : _selectedFilters.remove(diet);
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.auto_awesome),
              label: const Text("Generate"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _generateRecipe,
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (_generatedRecipe != null) Expanded(
              child: Card(
                color: Colors.white,
                elevation: 2,
                margin: const EdgeInsets.only(top: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _generatedRecipe!,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.save),
                              label: const Text("Save"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                // TODO: Save logic
                              },
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.refresh),
                              label: const Text("Regenerate"),
                              onPressed: _generateRecipe,
                            ),
                          ],
                        )
                      ],
                    ),
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
