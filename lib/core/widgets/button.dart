import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSecondary
        ? Colors.transparent
        : AppColors.primaryAmber;

    final borderColor = isSecondary
        ? Colors.grey.withValues(alpha: 0.5)
        : Colors.transparent;

    final textColor = isSecondary ? Colors.grey.shade400 : Colors.black;

    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),

          /// sombra solo para el primary
          boxShadow: isSecondary
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primaryAmber.withValues(alpha: 0.20),
                    blurRadius: 8,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: borderColor, width: isSecondary ? 2 : 0),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
