import 'package:flutter/material.dart';
import '../core/theme.dart';

class DietaryFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const DietaryFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontFamily: fontFamily,
          color: selected ? Colors.white : primaryColor,
        ),
      ),
      backgroundColor: const Color(0xFFE5EEF8),
      selectedColor: primaryColor,
      selected: selected,
      onSelected: onSelected,
    );
  }
}
