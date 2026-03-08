import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletSetupPageTwo extends StatefulWidget {
  const WalletSetupPageTwo({super.key});

  @override
  State<WalletSetupPageTwo> createState() => _WalletSetupPageTwoState();
}

class _WalletSetupPageTwoState extends State<WalletSetupPageTwo> {
  // Variable local que guardará nuestra dirección simulada
  late String simulatedAddress;

  @override
  void initState() {
    super.initState();
    // Generamos una dirección falsa pero realista (formato SegWit bc1q)
    // En una app real, esto vendría de una librería criptográfica.
    simulatedAddress = 'bc1qsatoshimex7xje89x5dfg456hjz8nv9';
  }

  // Función para copiar al portapapeles
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: simulatedAddress));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Dirección copiada al portapapeles!'),
        backgroundColor: AppColors.primaryAmber,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Textos principales
            const Text(
              'TU INDENTIDAD DIGITAL',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Estamos generando tu dirección de Bitcoin única para este simulador.',
              style: TextStyle(
                color: AppColors.slateBlueGray,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),

            // 3. Tarjeta de la Dirección (Sin QR, todo en código)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.deepNavy,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.blueGray.withValues(alpha: .2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mostramos una versión acortada para que se vea elegante como en el boceto
                  Text(
                    'bc1qsatoshimex...z8nv9',
                    style: const TextStyle(
                      color: AppColors.primaryAmber,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'DIRECCIÓN DE BITCOIN',
                    style: TextStyle(
                      color: AppColors.slateBlueGray,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botón de Copiar interno
                  InkWell(
                    onTap: _copyToClipboard,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.charcoalBlack.withValues(alpha: .5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.blueGray.withValues(alpha: .3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.copy,
                            color: AppColors.primaryAmber,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Copiar',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. Tarjeta de Información Educativa
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAmber.withValues(alpha: .1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: AppColors.primaryAmber,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '¿Qué es esto?',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'En el mundo real, esta dirección es como tu número de cuenta para recibir pagos. Cualquiera puede enviarte Bitcoin si conoce esta serie de caracteres.',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
