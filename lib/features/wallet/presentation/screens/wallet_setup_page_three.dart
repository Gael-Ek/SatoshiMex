import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_learning_progress.dart';

// 1. ¡AHORA ES UN STATEFUL WIDGET Y YA NO PIDE PARÁMETROS!
class WalletSetupPageThree extends StatefulWidget {
  const WalletSetupPageThree({super.key}); // Constructor limpio

  @override
  State<WalletSetupPageThree> createState() => _WalletSetupPageThreeState();
}

class _WalletSetupPageThreeState extends State<WalletSetupPageThree> {
  // 2. Variables temporales que cambiarán cuando lea la memoria
  String balance = 'Cargando...';
  String address = 'Cargando...';

  @override
  void initState() {
    super.initState();
    _loadWalletData(); // Al abrir la pantalla, busca en la memoria
  }

  // 3. Función que lee los datos guardados de la página 1 y 2
  Future<void> _loadWalletData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      balance = prefs.getString('simulatedBalance') ?? '0.001 BTC';
      address = prefs.getString('simulatedAddress') ?? 'bc1q...';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const WalletLearningProgress(currentStep: 3, totalSteps: 3),
              const SizedBox(height: 48),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.charcoalBlack,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryAmber.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: AppColors.primaryAmber,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                '¡Billetera Creada!',
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
                  border: Border.all(
                    color: AppColors.blueGray.withOpacity(0.2),
                  ),
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
                      child: Divider(
                        color: AppColors.charcoalBlack,
                        thickness: 2,
                      ),
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
                        color: AppColors.charcoalBlack,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.blueGray.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.key,
                            color: AppColors.blueGray,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              address,
                              style: const TextStyle(
                                color: AppColors.blueGray,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ), // <-- Aquí pinta la dirección
                          const Icon(
                            Icons.copy,
                            color: AppColors.blueGray,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 4. Botón Final (Guarda que YA TIENE BILLETERA y navega)
              SatoshiButton(
                text: 'Ir a mi Billetera',
                icon: Icons.arrow_forward,
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  // Guardamos la bandera clave:
                  await prefs.setBool('hasWallet', true);

                  if (context.mounted) {
                    context.go('/home'); // Regresa al menú principal
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
