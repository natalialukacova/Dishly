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
    return Recipe(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      instructions: json['instructions'] ?? '',
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      ingredients: List<String>.from(json['ingredients']),
      nutrients: (json['nutrients'] as List)
          .map((e) => Nutrient.fromJson(e))
          .toList(),
      vegetarian: json['vegetarian'],
      vegan: json['vegan'],
      glutenFree: json['glutenFree'],
    );
  }
}
