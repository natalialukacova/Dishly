import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(SmartRecipeAssistantApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class SmartRecipeAssistantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
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
