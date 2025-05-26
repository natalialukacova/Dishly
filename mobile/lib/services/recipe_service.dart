import 'dart:convert';
import 'package:flutter/foundation.dart'; // for compute
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  static const String baseUrl = 'http://192.168.0.145:5000';

  static Future<List<Recipe>> searchRecipes(List<String> ingredients) async {
    final query = ingredients.join(',');
    final url = Uri.parse('$baseUrl/api/recipes/search?ingredients=$query');

    try {
      final response = await http.get(url);
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        // Use compute to parse JSON in a background isolate
        return compute(_parseRecipes, response.body);
      } else {
        throw Exception('Failed to fetch recipes: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error in searchRecipes: $e');
      rethrow;
    }
  }

  static List<Recipe> _parseRecipes(String body) {
    final List<dynamic> jsonList = json.decode(body);
    print('Decoded JSON: $jsonList');
    return jsonList.map((json) => Recipe.fromJson(json)).toList();
  }
}
