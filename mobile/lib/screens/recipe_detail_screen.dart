import 'package:flutter/material.dart';
import 'package:mobile/widgets/recipe_detail/ingredients_card.dart';
import 'package:mobile/widgets/recipe_detail/instructions_card.dart';
import '../core/theme.dart';
import '../models/recipe.dart';
import '../widgets/recipe_detail/nutrition_summary.dart';
import '../widgets/recipe_detail/recipe_info.dart';
import 'chat_screen.dart';
import '../utils/recipe_utils.dart';


class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
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