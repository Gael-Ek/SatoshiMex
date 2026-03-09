import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_intro_image.dart';

class WalletIntroPageOne extends StatelessWidget {
  const WalletIntroPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const WalletIntroImage(mainIcon: Icons.school),

        const SizedBox(height: 32),

        // 3. Textos informativos
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
          textAlign: TextAlign.start,
          style: TextStyle(color: AppColors.slateBlueGray, fontSize: 16),
        ),
      ],
    );
  }
}
