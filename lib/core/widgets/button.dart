import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        // Usamos un Container para aplicar el resplandor exterior
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            // Resplandor interior más fuerte y cercano
            BoxShadow(
              color: AppColors.primaryAmber.withValues(alpha: 0.6),
              blurRadius: 15,
              spreadRadius: 3,
            ),
            // Resplandor exterior más suave y expansivo
            BoxShadow(
              color: AppColors.primaryAmber.withValues(alpha: 0.3),
              blurRadius: 30,
              spreadRadius: 8,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryAmber,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
