import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  static const String baseUrl = 'http://10.0.2.2:5000';
  static Future<List<Recipe>> searchRecipes(List<String> ingredients) async {
    final query = ingredients.join(',');
    final url = Uri.parse('$baseUrl/api/recipes/search?ingredients=$query');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch recipes');
    }
  }
}
