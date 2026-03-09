import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class RoadmapStatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const RoadmapStatChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF04233B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryAmber.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryAmber, size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
