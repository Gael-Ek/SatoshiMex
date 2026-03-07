import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletLearningMissions extends StatelessWidget {
  const WalletLearningMissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.deepNavy, // Fondo de la tarjeta
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.blueGray.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
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

          // Misión 1
          _buildMissionTile(title: 'Simula tu primer envío'),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: AppColors.charcoalBlack, thickness: 1),
          ),

          // Misión 2
          _buildMissionTile(title: 'Primera conversión BTC a MXN'),
        ],
      ),
    );
  }

  // Pequeño sub-widget para no repetir código
  Widget _buildMissionTile({required String title}) {
    return Row(
      children: [
        // Indicador de "Pendiente" (Círculo vacío)
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.blueGray, width: 2),
          ),
        ),
        const SizedBox(width: 16),
        // Texto de la misión
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Recompensa en XP (Plano por ahora)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.charcoalBlack,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '+50 XP',
            style: TextStyle(
              color: AppColors.primaryAmber,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
