import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletIntroHeader extends StatelessWidget {
  const WalletIntroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
