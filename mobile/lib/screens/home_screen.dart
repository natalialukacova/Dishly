import 'package:flutter/material.dart';
import 'recipe_search_screen.dart';

void main() {
  runApp(SmartRecipeAssistantApp());
}

class SmartRecipeAssistantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Recipe Assistant',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF6FAFF),
        primaryColor: Color(0xFF2E5C9A),
        fontFamily: 'Sans',
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> buttons = [
    {'icon': Icons.search, 'label': 'Ingredient-Based Recipe Search'},
    {'icon': Icons.smart_toy, 'label': 'AI Recipe Generator'},
    {'icon': Icons.dining, 'label': 'Join Cooking Room'},
    {'icon': Icons.add_circle_outline, 'label': 'Create Cooking Room'},
    {'icon': Icons.favorite, 'label': 'Favorite Recipes'},
    {'icon': Icons.chat, 'label': 'Chat with AI Chef'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Recipe Assistant"),
        backgroundColor: Color(0xFF2E5C9A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...buttons.map((btn) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE5EEF8),
                  foregroundColor: Color(0xFF1C3552), 
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  minimumSize: Size(double.infinity, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 1,
                  alignment: Alignment.centerLeft, 
                ),
                onPressed: () {
                  switch (btn['label']) {
                    case 'Ingredient-Based Recipe Search':
                      Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeSearchScreen()));
                      break;
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(btn['icon'], size: 28, color: Color(0xFF1C3552)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        btn['label'],
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF1C3552),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFEDF3FA),
        selectedItemColor: Color(0xFF2E5C9A),
        unselectedItemColor: Color(0xFF8497B0),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Recipes"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
        ],
      ),
    );
  }
}