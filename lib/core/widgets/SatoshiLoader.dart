import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class SatoshiLoader extends StatelessWidget {
  const SatoshiLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'APRENDE. PRACTICA. DOMINA.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              letterSpacing: 3.0,
            ),
          ),
          const SizedBox(height: 30),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAmber),
              backgroundColor: Color(0xFF1C2128),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'CARGANDO ECOSISTEMA...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
