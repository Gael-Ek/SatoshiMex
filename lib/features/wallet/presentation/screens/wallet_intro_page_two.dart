import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_checklist_item.dart';

class WalletIntroPageTwo extends StatelessWidget {
  const WalletIntroPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Lo que aprenderás',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Domina los conceptos básicos antes de empezar a operar con fondos reales.',
          style: TextStyle(color: AppColors.slateBlueGray, fontSize: 16),
        ),

        const SizedBox(height: 32),

        // Lista de objetivos usando tu nuevo widget
        const WalletChecklistItem(title: 'Enviar Bitcoin'),
        const WalletChecklistItem(title: 'Verificar direcciones'),
        const WalletChecklistItem(title: 'Confirmaciones de transacción'),
        const WalletChecklistItem(title: 'Cómo funciona la red Bitcoin'),
      ],
    );
  }
}
