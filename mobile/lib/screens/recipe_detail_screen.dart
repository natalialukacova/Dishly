import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../core/theme.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(recipe.image, height: 200, fit: BoxFit.cover),
              ),
            const SizedBox(height: 20),
            Text("Ingredients:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: fontFamily)),
            const SizedBox(height: 10),
            ...recipe.ingredients.map((ing) => Text("• $ing", style: TextStyle(fontSize: 16, fontFamily: fontFamily))),
            const SizedBox(height: 20),
            Text("Instructions:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: fontFamily)),
            const SizedBox(height: 10),
            Text(recipe.instructions, style: TextStyle(fontSize: 16, fontFamily: fontFamily)),
          ],
        ),
      ),
    );
  }
}
