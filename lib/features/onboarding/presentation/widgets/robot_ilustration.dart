import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class RobotIllustration extends StatelessWidget {
  const RobotIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: AppColors.primaryAmber.withValues(alpha: 0.05), // El fondo suave
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ROBOT ---
          Icon(Icons.smart_toy, size: 120, color: AppColors.primaryAmber),
        ],
      ),
    );
  }
}
