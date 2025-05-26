import 'package:flutter/material.dart';
import 'package:mobile/screens/ai_recipe_generator_screen.dart';
import '../../../widgets/home_button.dart';
import '../../../core/theme.dart';
import './recipe_search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {
        'icon': Icons.search,
        'label': 'Ingredient-Based Recipe Search',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecipeSearchScreen()),
        ),
      },
      {
        'icon': Icons.smart_toy,
        'label': 'AI Recipe Generator',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AIRecipeGeneratorScreen()),
        ),
      },
      {
        'icon': Icons.dining,
        'label': 'Join Cooking Room',
        'onTap': () {}, // TODO
      },
      {
        'icon': Icons.add_circle_outline,
        'label': 'Create Cooking Room',
        'onTap': () {}, // TODO
      },
      {
        'icon': Icons.favorite,
        'label': 'Favorite Recipes',
        'onTap': () {}, // TODO
      },
      {
        'icon': Icons.chat,
        'label': 'Chat with AI Chef',
        'onTap': () {}, // TODO
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dishly"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily,
              ),
            ),
            const SizedBox(height: 20),
            ...buttons.map((btn) => HomeButton(
              label: btn['label'],
              icon: btn['icon'],
              onPressed: btn['onTap'],
            )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFEDF3FA),
        selectedItemColor: primaryColor,
        unselectedItemColor: const Color(0xFF8497B0),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Recipes"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
        ],
      ),
    );
  }
}