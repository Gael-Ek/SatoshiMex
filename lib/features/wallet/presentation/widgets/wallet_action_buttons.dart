import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletActionButtons extends StatelessWidget {
  const WalletActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Botón Simular Envío (Ámbar) - ¡AHORA ES INTELIGENTE!
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              // LÓGICA DEL INTERCEPTOR
              final prefs = await SharedPreferences.getInstance();
              final recipientsList =
                  prefs.getStringList('walletRecipients') ?? [];

              if (context.mounted) {
                if (recipientsList.isEmpty) {
                  // Camino A: No tiene a quién enviarle, lo mandamos a crear uno
                  context.push('/add-recipient-1');
                } else {
                  // Camino B: Ya tiene contactos, lo mandamos a su agenda
                  // (Esta ruta la crearemos en el siguiente paso)
                  context.push('/wallet-send-step-1');
                }
              }
            },
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

        // 2. Botón Simular Recepción (Oscuro)
        Expanded(
          child: ElevatedButton(
            onPressed: () =>
                context.push('/wallet-receive'), // Ya lo teníamos conectado
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
