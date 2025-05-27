import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/recipe.dart';

class FavoriteRecipeService {
  static const String baseUrl = 'http://192.168.0.145:5000';
  static const String apiKey = '11761ad04c3145b889c62fcf2816c3a4';

  static Future<void> addToFavorites(Recipe recipe) async {
    final url = Uri.parse('$baseUrl/api/favoriterecipe');
    final payload = {
      'id': const Uuid().v4(),
      'recipeId': recipe.id.toString(),
      'title': recipe.title,
      'image': recipe.image,
      'instructions': recipe.instructions,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add to favorites: ${response.statusCode}');
    }
  }

  static Future<void> removeFavorite(String id) async {
    final url = Uri.parse('$baseUrl/api/favoriterecipe/$id');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete favorite: ${response.statusCode}');
    }
  }

  static Future<List<Recipe>> getAllFavorites() async {
    final url = Uri.parse('$baseUrl/api/favoriterecipe');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> favorites = json.decode(response.body);
      final List<Recipe> detailedRecipes = [];

      for (var fav in favorites) {
        final id = fav['recipeId'];
        final apiRes = await http.get(Uri.parse(
          'https://api.spoonacular.com/recipes/$id/information?includeNutrition=true&apiKey=$apiKey',
        ));

        if (apiRes.statusCode == 200) {
          final jsonRecipe = json.decode(apiRes.body);
          detailedRecipes.add(Recipe.fromJson(jsonRecipe));
        }
      }

      return detailedRecipes;
    } else {
      throw Exception('Failed to load favorites: ${response.statusCode}');
    }
  }

  static Future<String?> getFavoriteIdForRecipe(Recipe recipe) async {
    final url = Uri.parse('$baseUrl/api/favoriterecipe');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> favorites = json.decode(response.body);
      final match = favorites.firstWhere(
            (fav) => fav['recipeId'].toString() == recipe.id.toString(),
        orElse: () => null,
      );

      return match != null ? match['id'] : null;
    } else {
      throw Exception('Failed to load favorites');
    }
  }

}
