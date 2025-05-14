import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

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
      final recipes = await RecipeService.searchRecipes(ingredientsList);
      setState(() {
        _recipes = recipes;
      });
    } catch (e, stacktrace) {
      print('Error during recipe search: $e');
      print(stacktrace);
      setState(() {
        _error = 'Failed to load recipes.';
      });
    }
    finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search by Ingredients"),
        backgroundColor: Color(0xFF2E5C9A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter ingredients (comma separated)",
                prefixIcon: Icon(Icons.shopping_basket, color: Color(0xFF2E5C9A)),
                filled: true,
                fillColor: Color(0xFFF0F5FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children: dietaryOptions.map((option) {
                final isSelected = selectedFilters.contains(option);
                return FilterChip(
                  label: Text(option),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Color(0xFF2E5C9A),
                  ),
                  backgroundColor: Color(0xFFE5EEF8),
                  selectedColor: Color(0xFF2E5C9A),
                  selected: isSelected,
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
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E5C9A),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _searchRecipes,
              icon: Icon(Icons.search),
              label: Text("Search"),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red))
            else if (_recipes.isEmpty)
                Text("No recipes found.", style: TextStyle(color: Colors.grey))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _recipes[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        color: Color(0xFFF6FAFF),
                        elevation: 2,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(recipe.image, width: 60, height: 60, fit: BoxFit.cover),
                          ),
                          title: Text(
                            recipe.title,
                            style: TextStyle(
                              color: Color(0xFF1C3552),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text("ID: ${recipe.id}"),
                          trailing: Icon(Icons.remove_red_eye, color: Color(0xFF2E5C9A)),
                          onTap: () {
                            // View recipe action
                          },
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
