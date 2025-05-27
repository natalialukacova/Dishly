import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/recipe.dart';

/// Stores a recipe via HTTP POST
Future<void> storeRecipe(Recipe recipe) async {
  final recipeText = """
Ingredients:
${recipe.ingredients.map((i) => "- $i").join("\n")}

Instructions:
${recipe.instructions}
""";

  await http.post(
    Uri.parse('http://192.168.0.145:5000/store_recipe'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'recipe_id': recipe.id,
      'recipe_text': recipeText,
    }),
  );
}

/// Loads memory (chat history) for a given recipe
Future<List<Map<String, String>>> fetchChatMemory(int recipeId) async {
  final response = await http.get(
    Uri.parse('http://192.168.0.145:8000/memory/$recipeId'),
  );

  if (response.statusCode == 200) {
    final List memory = json.decode(response.body)['memory'];
    return memory.map<Map<String, String>>((m) {
      return {
        'role': m['role']?.toString() ?? 'assistant',
        'content': m['content']?.toString() ?? '',
      };
    }).toList();
  } else {
    return [];
  }
}

/// Creates a WebSocket channel connected to the backend
WebSocketChannel connectWebSocket({String baseUrl = '192.168.0.145'}) {
  final uri = Uri.parse('ws://$baseUrl:8000/ws');
  return WebSocketChannel.connect(uri);
}
