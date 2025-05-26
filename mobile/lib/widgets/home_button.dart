import 'package:flutter/material.dart';
import '../core/theme.dart';

class HomeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const HomeButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE5EEF8),
          foregroundColor: const Color(0xFF1C3552),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          minimumSize: const Size(double.infinity, 70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 1,
          alignment: Alignment.centerLeft,
          textStyle: TextStyle(
            fontFamily: fontFamily,
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon, size: 28, color: const Color(0xFF1C3552)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF1C3552),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
