import 'package:flutter/material.dart';
import '../../../models/recipe.dart';
import 'info_icon.dart';

class RecipeInfo extends StatelessWidget {
  final Recipe recipe;

  const RecipeInfo({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
    );
  }
}
