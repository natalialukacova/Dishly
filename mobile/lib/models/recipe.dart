class Recipe {
  final String id;
  final String title;
  final List<String> ingredients;
  final String instructions;
  final String image;

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.image,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Untitled',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: json['instructions'] ?? 'No instructions available.',
      image: json['image'] ?? 'https://via.placeholder.com/150',
    );
  }
}

