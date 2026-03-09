import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletLearningMissions extends StatelessWidget {
  const WalletLearningMissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MISIONES DE APRENDIZAJE',
          style: TextStyle(
            color: AppColors.blueGray,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),

        // Contenedor oscuro principal
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.deepNavy,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.blueGray.withValues(alpha: .1)),
          ),
          child: Column(
            children: [
              _buildMissionItem('Simula tu primer envío', isLast: false),
              _buildMissionItem('Primera conversión BTC a MXN', isLast: true),
            ],
          ),
        ),
      ],
    );
  }

  // Widget para construir cada misión sin la etiqueta de XP
  Widget _buildMissionItem(String title, {required bool isLast}) {
    return Column(
      children: [
        Row(
          children: [
            // Círculo indicador de estado
            const Icon(
              Icons.circle_outlined,
              color: AppColors.blueGray,
              size: 22,
            ),
            const SizedBox(width: 16),
            // Título de la misión
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // ¡Se eliminó el contenedor del +50 XP aquí!
          ],
        ),

        // Línea divisoria si no es el último elemento
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(
              color: AppColors.charcoalBlack.withValues(alpha: .5),
              thickness: 1,
            ),
          ),
      ],
    );
  }
}
