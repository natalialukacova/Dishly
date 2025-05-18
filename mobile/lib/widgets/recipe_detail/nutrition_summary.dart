import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/nutrient.dart';

class NutritionSummary extends StatelessWidget {
  final List<Nutrient> nutrients;

  const NutritionSummary({super.key, required this.nutrients});

  @override
  Widget build(BuildContext context) {
    final keyNutrients = ['Calories', 'Fat', 'Carbohydrates', 'Protein'];
    final displayNutrients = nutrients
        .where((n) => keyNutrients.contains(n.name))
        .toList();

    IconData _getIcon(String name) {
      switch (name.toLowerCase()) {
        case 'calories':
          return Icons.local_fire_department;
        case 'fat':
          return Icons.opacity;
        case 'carbohydrates':
          return Icons.bubble_chart;
        case 'protein':
          return Icons.fitness_center;
        default:
          return Icons.info_outline;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nutrition (per serving)",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: primaryColor,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 12) / 2;

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: displayNutrients.map((n) {
                return Container(
                  width: itemWidth,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryColor.withOpacity(0.15)),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(_getIcon(n.name), size: 18, color: primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.name,
                                style:  TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: fontFamily,
                                )),
                            Text('${n.amount.toStringAsFixed(1)} ${n.unit}',
                                style:  TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontFamily: fontFamily,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
