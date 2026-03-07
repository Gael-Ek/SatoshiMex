import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';

// Importa tus widgets de la billetera
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_learning_progress.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_balance_option_card.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_info_alert.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Para guardar la opción seleccionada

// ¡OJO! Ahora es StatefulWidget
class WalletSetupPageOne extends StatefulWidget {
  const WalletSetupPageOne({super.key});

  @override
  State<WalletSetupPageOne> createState() => _WalletSetupPageOneState();
}

class _WalletSetupPageOneState extends State<WalletSetupPageOne> {
  // Variable para guardar la opción elegida. Empezamos en 0 (la primera opción).
  int selectedOption = 0;

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Barra de progreso reutilizada (Paso 1 de 3)
              const WalletLearningProgress(currentStep: 1, totalSteps: 3),
              const SizedBox(height: 24),

              // 2. Textos principales
              const Text(
                'Saldo Inicial de Práctica',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '¿Con cuánto Bitcoin te gustaría empezar a practicar?',
                style: TextStyle(color: AppColors.blueGray, fontSize: 16),
              ),
              const SizedBox(height: 32),

              // 3. Opciones de Saldo (Las tarjetas)
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    WalletBalanceOptionCard(
                      amount: '0.001 BTC',
                      description:
                          'Ideal para familiarizarse con la plataforma y transacciones básicas.',
                      icon: Icons.account_balance_wallet_outlined,
                      isRecommended: true,
                      isSelected: selectedOption == 0, // ¿Es la opción 0?
                      onTap: () {
                        setState(
                          () => selectedOption = 0,
                        ); // Actualiza la pantalla
                      },
                    ),
                    WalletBalanceOptionCard(
                      amount: '0.01 BTC',
                      description:
                          'Perfecto para practicar estrategias de trading de corto plazo.',
                      icon: Icons.trending_up,
                      isSelected: selectedOption == 1,
                      onTap: () {
                        setState(() => selectedOption = 1);
                      },
                    ),
                    WalletBalanceOptionCard(
                      amount: '0.1 BTC',
                      description:
                          'Diseñado para simular gestión de carteras de alto volumen.',
                      icon: Icons.rocket_launch_outlined,
                      isSelected: selectedOption == 2,
                      onTap: () {
                        setState(() => selectedOption = 2);
                      },
                    ),

                    const SizedBox(height: 16),

                    // 4. Widget de Alerta
                    const WalletInfoAlert(
                      text:
                          'Este saldo es ficticio y solo para fines educativos. No tiene valor real fuera del simulador.',
                    ),
                  ],
                ),
              ),

              // 5. Botones Inferiores (Atrás y Siguiente alineados en Row)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: [
                    // Botón Atrás
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
                    // Botón Siguiente (reutilizando tu SatoshiButton)
                    Expanded(
                      flex: 2,
                      child: SatoshiButton(
                        text: 'Siguiente',
                        icon: Icons.arrow_forward,
                        onPressed: () async {
                          // 1. Convertimos la opción (0, 1 o 2) en el texto del saldo
                          String balanceString = '0.001 BTC';
                          if (selectedOption == 1) balanceString = '0.01 BTC';
                          if (selectedOption == 2) balanceString = '0.1 BTC';

                          // 2. Lo guardamos en la memoria
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString(
                            'simulatedBalance',
                            balanceString,
                          );

                          // 3. Avanzamos a la página 2
                          if (context.mounted) {
                            context.push('/wallet-setup-2');
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
      ),
    );
  }
}
