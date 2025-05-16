import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(SmartRecipeAssistantApp());
}

class SmartRecipeAssistantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DISHLY',
      theme: ThemeData(
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        primaryColor: primaryColor,
        fontFamily: fontFamily,
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
