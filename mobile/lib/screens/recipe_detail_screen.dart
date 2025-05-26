import 'package:flutter/material.dart';
import 'package:mobile/widgets/recipe_detail/ingredients_card.dart';
import 'package:mobile/widgets/recipe_detail/instructions_card.dart';
import '../models/recipe.dart';
import '../widgets/recipe_detail/info_icon.dart';
import '../widgets/recipe_detail/nutrition_summary.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  List<String> _splitInstructions(String raw) {
    return raw
        .split(RegExp(r'(?<=\.)\s+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
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
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                InfoIcon(icon: Icons.schedule, label: "${recipe.readyInMinutes} min"),
                InfoIcon(icon: Icons.people, label: "${recipe.servings}"),
                if (recipe.vegan) InfoIcon(icon: Icons.eco, label: "Vegan"),
                if (recipe.vegetarian && !recipe.vegan)
                  InfoIcon(icon: Icons.local_florist, label: "Vegetarian"),
                if (recipe.glutenFree) InfoIcon(icon: Icons.no_food, label: "Gluten-Free"),
              ],
            ),
            const SizedBox(height: 24),
            if (recipe.nutrients.isNotEmpty)
              NutritionSummary(nutrients: recipe.nutrients),
            const SizedBox(height: 8),
            IngredientsCard(ingredients: recipe.ingredients),
            const SizedBox(height: 16),
            InstructionsCard(steps: _splitInstructions(recipe.instructions)),
          ],
        ),
      ),
    );
  }
}
