import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletActionButtons extends StatelessWidget {
  const WalletActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Botón Simular Envío (Ámbar)
        Expanded(
          child: ElevatedButton(
            onPressed: () => debugPrint('Ir a Enviar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAmber,
              foregroundColor: AppColors.charcoalBlack,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Column(
              children: [
                Icon(Icons.send_outlined),
                SizedBox(height: 4),
                Text(
                  'Simular envío',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Botón Simular Recepción (Oscuro)
        Expanded(
          child: ElevatedButton(
            onPressed: () => context.push('/wallet-receive'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepNavy,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Column(
              children: [
                Icon(Icons.call_received),
                SizedBox(height: 4),
                Text(
                  'Simular recepción',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
