import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletRecentActivity extends StatelessWidget {
  const WalletRecentActivity({super.key});

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
          const Text(
            'ACTIVIDAD RECIENTE',
            style: TextStyle(
              color: AppColors.blueGray,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 24),

          // ESTADO VACÍO (Cero transacciones)
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.blueGray.withOpacity(0.5),
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Aún no hay actividad.',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Simula tu primer envío para verlo aquí.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.blueGray, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
