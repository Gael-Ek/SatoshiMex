import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletIntroHeader extends StatelessWidget {
  const WalletIntroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const Text(
          'SATOSHIMX',
          style: TextStyle(
            color: AppColors.primaryAmber,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(width: 48), // Equilibrio visual para centrar el texto
      ],
    );
  }
}
