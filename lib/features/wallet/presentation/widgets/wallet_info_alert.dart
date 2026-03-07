import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart'; // Tu regla de oro

class WalletInfoAlert extends StatelessWidget {
  final String text;

  const WalletInfoAlert({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.charcoalBlack, // Fondo oscuro
        borderRadius: BorderRadius.circular(12),
        // Un borde sutil para enmarcarlo
        border: Border.all(color: AppColors.blueGray.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.primaryAmber,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.blueGray,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
