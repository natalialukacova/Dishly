import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../core/theme.dart';
import '../widgets/ingredient_input.dart';
import '../widgets/recipe_card.dart';

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({super.key});

  @override
  _RecipeSearchScreenState createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final TextEditingController _controller = TextEditingController();

  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String? _error;
  bool _hasSearched = false;

  void _searchRecipes() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _error = null;
      _recipes = [];
    });

    try {
      final ingredientsList = input.split(',').map((s) => s.trim()).toList();
      final recipes = await compute(RecipeService.searchRecipes, ingredientsList);

      if (!mounted) return;

      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Failed to load recipes.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Search by Ingredients"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IngredientInput(controller: _controller),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _searchRecipes,
              icon: const Icon(Icons.search, color: Colors.white),
              label: Text("Search", style: TextStyle(fontFamily: fontFamily)),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red, fontFamily: fontFamily))
            else if (!_hasSearched)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu, size: 100, color: primaryColor),
                        const SizedBox(height: 16),
                        Text(
                          "Find recipes by ingredients",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: fontFamily,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) => RecipeCard(recipe: _recipes[index]),
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
