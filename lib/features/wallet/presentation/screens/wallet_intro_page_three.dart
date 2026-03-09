import 'package:flutter/material.dart';

// Nuestra regla de oro para los colores:
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletIntroPageThree extends StatelessWidget {
  const WalletIntroPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 220, // Un poco más alta para que luzca
              decoration: BoxDecoration(
                // Gradiente sofisticado (DeepNavy a Charcoal)
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.deepNavy, AppColors.blueGray],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
                // Borde sutil para dar definición
                border: Border.all(
                  color: AppColors.blueGray.withValues(alpha: .2),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fila Superior: Logo simulado y Nombre
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAmber.withValues(alpha: .1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.currency_bitcoin,
                          color: AppColors.primaryAmber,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'SatoshiMex Wallet',
                        style: TextStyle(
                          color: AppColors.slateBlueGray,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Fila Central: Balance simulado
                  const Text(
                    'Balance de Práctica',
                    style: TextStyle(
                      color: AppColors.slateBlueGray,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '1.2580 BTC',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),

                  const Spacer(),

                  // Fila Inferior: Dirección truncada simulada
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code,
                          color: AppColors.slateBlueGray,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'bc1qxy...xyz321',
                          style: TextStyle(
                            color: AppColors.slateBlueGray,
                            fontSize: 12,
                            fontFamily:
                                'Monospace', // Usar mono si tienes la fuente
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Etiqueta flotante (Mantenida del diseño original)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryAmber,
                  borderRadius: BorderRadius.circular(8),
                  // Añadimos brillo a la etiqueta
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryAmber.withValues(alpha: .5),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'SIMULACIÓN ACTIVA',
                  style: TextStyle(
                    color: AppColors.charcoalBlack,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Título
        const Text(
          'Modo Simulación',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        // Descripción
        const Text(
          'Todas las operaciones aquí son simulaciones seguras para aprender. Puedes cometer errores y ver qué pasaría en la vida real sin arriesgar fondos.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: AppColors.slateBlueGray,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
