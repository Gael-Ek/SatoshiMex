import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

// --- IMPORTR WIDGETS AQUÍ ---
import 'package:satoshimex/core/widgets/app_widgets.dart'; // Asumiendo que exportaste SatoshiButton aquí
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_intro_header.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_intro_image.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_page_indicator.dart';

class WalletIntroPageOne extends StatelessWidget {
  const WalletIntroPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              // 1. Usamos tu nuevo widget del Header (X y SATOSHIMX)
              const WalletIntroHeader(),

              const Spacer(flex: 1),

              // 2. Usamos tu nuevo widget de la Imagen (Pasándole el birrete)
              const WalletIntroImage(mainIcon: Icons.school),

              const Spacer(flex: 1),

              // 3. Textos informativos (Estos se quedan aquí porque cambian en cada página)
              const Text(
                'Billetera de Entrenamiento',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Practica cómo enviar Bitcoin sin arriesgar dinero real.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.blueGray, fontSize: 16),
              ),

              const Spacer(flex: 2),

              // 4. Tu nuevo widget indicador de página (Página 1 es el índice 0)
              const WalletPageIndicator(currentPage: 0),

              const SizedBox(height: 32),

              // 5. Tu nuevo botón naranja global
              SatoshiButton(
                text: 'Siguiente',
                icon: Icons.arrow_forward,
                onPressed: () {
                  context.push('/wallet-intro-2');
                  debugPrint('Saltar a la página 2');
                },
              ),

              // Un pequeño espacio extra al final
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
