import 'package:flutter/material.dart';

class InfoIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoIcon({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}