import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class SatoshiLogo extends StatelessWidget {
  const SatoshiLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo de Águila y Bitcoin
        Image.asset(
          'assets/images/logo_satoshi.png',
          height: 180,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.currency_bitcoin,
            size: 120,
            color: AppColors.primaryAmber,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'SatoshiMex',
          style: TextStyle(
            color: Colors.white,
            fontSize: 42,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
