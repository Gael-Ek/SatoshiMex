import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletPageIndicator extends StatelessWidget {
  final int currentPage; // Recibe 0, 1 o 2

  const WalletPageIndicator({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // Generamos 3 puntitos
      children: List.generate(3, (index) {
        bool isActive = index == currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          // Si está activo es más ancho (tipo cápsula), si no, es un circulito
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryAmber : AppColors.blueGray,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
