import 'package:flutter/material.dart';
import '../core/theme.dart';

class IngredientInput extends StatelessWidget {
  final TextEditingController controller;

  const IngredientInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(fontFamily: fontFamily),
      decoration: InputDecoration(
        labelText: "Enter ingredients (comma separated)",
        labelStyle: TextStyle(fontFamily: fontFamily),
        prefixIcon: Icon(Icons.shopping_basket, color: primaryColor),
        filled: true,
        fillColor: const Color(0xFFF0F5FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}