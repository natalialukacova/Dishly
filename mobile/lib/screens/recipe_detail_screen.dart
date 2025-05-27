import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/recipe.dart';
import '../services/favorites_service.dart';
import '../utils/recipe_utils.dart';
import '../widgets/recipe_detail/ingredients_card.dart';
import '../widgets/recipe_detail/instructions_card.dart';
import '../widgets/recipe_detail/nutrition_summary.dart';
import '../widgets/recipe_detail/recipe_info.dart';
import 'chat_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isFavorite = false;
  String? favoriteId;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    try {
      final id = await FavoriteRecipeService.getFavoriteIdForRecipe(widget.recipe);
      setState(() {
        isFavorite = id != null;
        favoriteId = id;
      });
    } catch (e) {
      debugPrint("Error checking favorite status: $e");
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      if (isFavorite && favoriteId != null) {
        await FavoriteRecipeService.removeFavorite(favoriteId!);
        setState(() {
          isFavorite = false;
          favoriteId = null;
        });
      } else {
        await FavoriteRecipeService.addToFavorites(widget.recipe);
        final id = await FavoriteRecipeService.getFavoriteIdForRecipe(widget.recipe);
        setState(() {
          isFavorite = true;
          favoriteId = id;
        });
      }
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.network(recipe.image, height: 200)),
            const SizedBox(height: 16),
            Text(
              recipe.title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            RecipeInfo(recipe: recipe),
            const SizedBox(height: 24),
            if (recipe.nutrients.isNotEmpty)
              NutritionSummary(nutrients: recipe.nutrients),
            const SizedBox(height: 8),
            IngredientsCard(ingredients: recipe.ingredients),
            const SizedBox(height: 16),
            InstructionsCard(steps: splitInstructions(recipe.instructions)),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.chat, color: Colors.white),
          label: const Text("Ask AI about this recipe"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E5C9A),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(recipe: recipe),
              ),
            );
          },
        ),
      ),
    );
  }
}