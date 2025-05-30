import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/recipe.dart';
import '../core/theme.dart';
import '../screens/recipe_detail_screen.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        color: scaffoldBackgroundColor,
        elevation: 2,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: recipe.image.isNotEmpty
                  ? recipe.image
                  : 'https://via.placeholder.com/150',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.broken_image),
            ),
          ),
          title: Text(
            recipe.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF1C3552),
              fontWeight: FontWeight.w600,
              fontFamily: fontFamily,
              fontSize: 16,
            ),
          ),
          trailing: Icon(Icons.remove_red_eye, color: primaryColor),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(recipe: recipe),
              ),
            );
          },
        ),
      ),
    );
  }
}
