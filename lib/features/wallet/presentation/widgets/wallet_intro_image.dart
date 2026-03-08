import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletIntroImage extends StatelessWidget {
  final IconData mainIcon; // El icono que irá en el centro

  const WalletIntroImage({super.key, required this.mainIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Cuadro oscuro central
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(
                32,
              ), // Bordes bien redondeados
            ),
            child: Center(
              child: Icon(mainIcon, size: 90, color: AppColors.primaryAmber),
            ),
          ),

          // 2. Insignia flotante de Bitcoin (Esquina inferior derecha)
          Positioned(
            bottom: -15,
            right: -15,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryAmber,
                shape: BoxShape.circle,
                // Le ponemos un borde del color del fondo principal para que resalte
                border: Border.all(color: AppColors.blueDark, width: 6),
              ),
              child: const Center(
                child: Icon(
                  Icons.currency_bitcoin,
                  color: AppColors.charcoalBlack,
                  size: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
