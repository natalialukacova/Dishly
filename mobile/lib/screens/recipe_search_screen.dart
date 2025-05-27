import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../core/theme.dart';
import '../widgets/ingredient_input.dart';
import '../widgets/dietary_filter_chip.dart';
import '../widgets/recipe_card.dart';

class RecipeSearchScreen extends StatefulWidget {
  @override
  _RecipeSearchScreenState createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> dietaryOptions = ['Vegan', 'Gluten-Free', 'Keto', 'Vegetarian'];
  final Set<String> selectedFilters = {};

  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String? _error;

  void _searchRecipes() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _recipes = [];
    });

    try {
      final ingredientsList = input.split(',').map((s) => s.trim()).toList();
      print("Searching recipes with: $ingredientsList");

      // Run search in background isolate
      final recipes = await compute(RecipeService.searchRecipes, ingredientsList);
      print("Found ${recipes.length} recipes");

      if (!mounted) return;

      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching recipes: $e");
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
            Wrap(
              spacing: 10,
              children: dietaryOptions.map((option) {
                return DietaryFilterChip(
                  label: option,
                  selected: selectedFilters.contains(option),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedFilters.add(option);
                      } else {
                        selectedFilters.remove(option);
                      }
                    });
                  },
                );
              }).toList(),
            ),
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
              onPressed: _searchRecipes,
              icon: const Icon(Icons.search, color: Colors.white),
              label: Text("Search", style: TextStyle(fontFamily: fontFamily)),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red, fontFamily: fontFamily))
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
