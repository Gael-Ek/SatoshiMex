import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletLearningProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const WalletLearningProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    // Calculamos el porcentaje (ej. 2 / 3 = 0.66)
    final double progress = currentStep / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'PROGRESO DE APRENDIZAJE',
              style: TextStyle(
                color: AppColors.blueGray,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              currentStep == totalSteps
                  ? 'COMPLETADO'
                  : '$currentStep de $totalSteps',
              style: const TextStyle(
                color: AppColors.primaryAmber,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor:
                AppColors.charcoalBlack, // Fondo oscuro de la barra
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryAmber,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
