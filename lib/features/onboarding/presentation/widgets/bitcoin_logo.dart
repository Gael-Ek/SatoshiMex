import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class BitcoinLogo extends StatelessWidget {
  const BitcoinLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ///Círculo punteado exterior
          IgnorePointer(
            child: DottedBorder(
              options: CircularDottedBorderOptions(
                color: AppColors.primaryAmber.withValues(alpha: 0.3),
                strokeWidth: 1.5,
                dashPattern: const [10, 10],
              ),
              child: const SizedBox(width: 280, height: 280),
            ),
          ),

          ///Glow / resplandor
          /// Glow / resplandor
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryAmber.withValues(alpha: 0.10),
                  blurRadius: 60,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),

          /// Círculo con el icono
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryAmber.withValues(alpha: 0.1),
              border: Border.all(
                color: AppColors.primaryAmber.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.currency_bitcoin,
                size: 110,
                color: AppColors.primaryAmber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
