import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:satoshimex/features/wallet/presentation/providers/wallet_recipients_provider.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletActionButtons extends ConsumerWidget {
  const WalletActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // 1. Botón Simular Envío (Ámbar) - ¡AHORA ES INTELIGENTE!
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final hasRecipients = ref
                  .read(walletRecipientsProvider.notifier)
                  .hasRecipients;
              if (hasRecipients) {
                context.push('/wallet-send');
              } else {
                context.push('/add-recipient');
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
