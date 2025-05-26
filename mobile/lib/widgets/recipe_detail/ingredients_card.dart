import 'package:flutter/material.dart';
import '../../core/theme.dart';

class IngredientsCard extends StatelessWidget {
  final List<String> ingredients;

  const IngredientsCard({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ingredients",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 12),
          ...ingredients.map((i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 18, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    i,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
