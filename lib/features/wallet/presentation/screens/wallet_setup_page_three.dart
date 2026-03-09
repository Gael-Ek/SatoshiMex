import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletSetupPageThree extends StatelessWidget {
  final String balance;
  final String address;
  const WalletSetupPageThree({
    super.key,
    required this.balance,
    required this.address,
  }); // Constructor limpio

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Resumen de tu Billetera',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Tu entorno seguro de aprendizaje está listo.',
          style: TextStyle(color: AppColors.blueGray, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),

        // Tarjeta de Resumen donde imprimimos las variables de la memoria
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.deepNavy,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.slateBlueGray),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.verified,
                    color: AppColors.primaryAmber,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'ÉXITO',
                    style: TextStyle(
                      color: AppColors.primaryAmber,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Resumen de tu Billetera',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Divider(color: AppColors.charcoalBlack, thickness: 2),
              ),

              const Text(
                'SALDO INICIAL',
                style: TextStyle(
                  color: AppColors.blueGray,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                balance,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ), // <-- Aquí pinta el saldo

              const SizedBox(height: 20),

              const Text(
                'DIRECCIÓN SIMULADA',
                style: TextStyle(
                  color: AppColors.blueGray,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.blueGray.withValues(alpha: .3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.key,
                      color: AppColors.charcoalBlack,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        address,
                        style: const TextStyle(
                          color: AppColors.charcoalBlack,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ), // <-- Aquí pinta la dirección
                    const Icon(
                      Icons.copy,
                      color: AppColors.charcoalBlack,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
