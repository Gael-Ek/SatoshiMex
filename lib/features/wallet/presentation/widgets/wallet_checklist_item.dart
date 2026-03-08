import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletChecklistItem extends StatelessWidget {
  final String title;

  const WalletChecklistItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ), // Separación entre cada tarjeta
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.2), // Fondo de la tarjeta
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Cuadrito naranja con la palomita
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColors.primaryAmber,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.check,
              color: AppColors.charcoalBlack,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          // Texto del objetivo
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
