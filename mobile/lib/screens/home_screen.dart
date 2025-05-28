import 'package:flutter/material.dart';
import 'package:mobile/screens/ai_recipe_generator_screen.dart';
import 'package:mobile/screens/favorites_screen.dart';
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
        'icon': Icons.favorite,
        'label': 'Favorite Recipes',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FavoriteRecipesScreen()),
        ),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Dishly_logo.png',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Ready to Cook Something Delicious?",
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: primaryColor,
                      fontFamily: fontFamily,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ...buttons.map(
                        (btn) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: HomeButton(
                        label: btn['label'],
                        icon: btn['icon'],
                        onPressed: btn['onTap'],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
