import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletBalanceOptionCard extends StatelessWidget {
  final String amount;
  final String description;
  final IconData icon;
  final bool isSelected;
  final bool isRecommended;
  final VoidCallback onTap;

  const WalletBalanceOptionCard({
    super.key,
    required this.amount,
    required this.description,
    required this.icon,
    required this.isSelected,
    this.isRecommended =
        false, // Por defecto es falso, a menos que le digamos lo contrario
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16), // Separación entre tarjetas
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.charcoalBlack : AppColors.deepNavy,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            // Si está seleccionado, borde naranja. Si no, borde transparente.
            color: isSelected
                ? AppColors.primaryAmber
                : AppColors.slateBlueGray,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Cuadrito del Icono
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.charcoalBlack.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primaryAmber : AppColors.blueGray,
              ),
            ),
            const SizedBox(width: 16),

            // Textos centrales
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        amount,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAmber,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'RECOMENDADO',
                            style: TextStyle(
                              color: AppColors.charcoalBlack,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.blueGray,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // Palomita (Check) de la derecha
            const SizedBox(width: 12),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected
                  ? AppColors.primaryAmber
                  : AppColors.blueGray.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
