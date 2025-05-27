import 'nutrient.dart';

class Recipe {
  final int id;
  final String title;
  final String image;
  final String instructions;
  final int readyInMinutes;
  final int servings;
  final List<String> ingredients;
  final List<Nutrient> nutrients;
  final bool vegetarian;
  final bool vegan;
  final bool glutenFree;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.instructions,
    required this.readyInMinutes,
    required this.servings,
    required this.ingredients,
    required this.nutrients,
    required this.vegetarian,
    required this.vegan,
    required this.glutenFree,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    // Parse instructions (fallback to analyzedInstructions if needed)
    String instructions = json['instructions'] ?? '';
    if (instructions.trim().isEmpty &&
        json['analyzedInstructions'] is List &&
        json['analyzedInstructions'].isNotEmpty) {
      final analyzed = json['analyzedInstructions'][0];
      if (analyzed != null && analyzed['steps'] is List) {
        instructions = (analyzed['steps'] as List)
            .map((step) => "${step['number']}. ${step['step']}")
            .join('\n');
      }
    }

    // Handle ingredients from either `ingredients` or `extendedIngredients`
    List<String> ingredients = [];
    if (json['ingredients'] != null) {
      ingredients = List<String>.from(json['ingredients']);
    } else if (json['extendedIngredients'] is List) {
      ingredients = (json['extendedIngredients'] as List)
          .map((e) => e['original']?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    // Handle nutrients from either `nutrients` or `nutrition.nutrients`
    List<Nutrient> nutrients = [];
    if (json['nutrients'] != null) {
      nutrients = (json['nutrients'] as List)
          .map((e) => Nutrient.fromJson(e))
          .toList();
    } else if (json['nutrition']?['nutrients'] is List) {
      nutrients = (json['nutrition']['nutrients'] as List)
          .map((e) => Nutrient.fromJson(e))
          .toList();
    }

    return Recipe(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      instructions: instructions,
      readyInMinutes: json['readyInMinutes'] ?? 0,
      servings: json['servings'] ?? 0,
      ingredients: ingredients,
      nutrients: nutrients,
      vegetarian: json['vegetarian'] ?? false,
      vegan: json['vegan'] ?? false,
      glutenFree: json['glutenFree'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'instructions': instructions,
      'readyInMinutes': readyInMinutes,
      'servings': servings,
      'ingredients': ingredients,
      'nutrients': nutrients.map((n) => n.toJson()).toList(),
      'vegetarian': vegetarian,
      'vegan': vegan,
      'glutenFree': glutenFree,
    };
  }
}