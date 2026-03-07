import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para copiar al portapapeles
import 'package:go_router/go_router.dart';

// Regla de oro de los colores
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';

// Importamos el widget reutilizable de la barra de progreso
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_learning_progress.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Para guardar la dirección generada

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
    return Scaffold(
      backgroundColor: AppColors.blueDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Barra de progreso (Paso 2 de 3)
                    const WalletLearningProgress(currentStep: 2, totalSteps: 3),
                    const SizedBox(height: 32),

                    // 2. Textos principales
                    const Text(
                      'Tu Identidad Digital',
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
                        color: AppColors.blueGray,
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
                          color: AppColors.blueGray.withOpacity(0.2),
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
                              color: AppColors.blueGray,
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
                                color: AppColors.charcoalBlack.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.blueGray.withOpacity(0.3),
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
                        color: AppColors.charcoalBlack,
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
                                  color: AppColors.primaryAmber.withOpacity(
                                    0.1,
                                  ),
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
                              color: AppColors.blueGray,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              // Aquí podrías abrir un modal o navegar a un artículo del glosario
                              debugPrint('Abrir glosario de direcciones');
                            },
                            child: Row(
                              children: [
                                const Text(
                                  'Saber más',
                                  style: TextStyle(
                                    color: AppColors.primaryAmber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.primaryAmber,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 24,
                    ), // Espacio extra al final del scroll
                  ],
                ),
              ),
            ),

            // 5. Botones Inferiores (Mantenemos la UX de la pantalla 1)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.charcoalBlack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Atrás',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: SatoshiButton(
                      text: 'Siguiente',
                      icon: Icons.arrow_forward,
                      onPressed: () async {
                        // 1. Guardamos la dirección generada en la memoria
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString(
                          'simulatedAddress',
                          simulatedAddress,
                        );

                        // 2. Vamos a la página 3 (¡Ya no usamos el "extra" en el router!)
                        if (context.mounted) {
                          context.push('/wallet-setup-3');
                        }
                      },
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
