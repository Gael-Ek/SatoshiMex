// wallet_add_recipient_address_content.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_data_container.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_warning_card.dart';

class RecipientAddressContent extends StatefulWidget {
  final String recipientName;
  final ValueChanged<String>
  onAddressGenerated; // notifica la dirección al padre

  const RecipientAddressContent({
    super.key,
    required this.recipientName,
    required this.onAddressGenerated,
  });

  @override
  State<RecipientAddressContent> createState() =>
      _RecipientAddressContentState();
}

class _RecipientAddressContentState extends State<RecipientAddressContent> {
  String _address = '';

  @override
  void initState() {
    super.initState();
    _generateAddress();
  }

  void _generateAddress() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final suffix = String.fromCharCodes(
      Iterable.generate(
        38,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
    final address = 'bc1q$suffix';
    setState(() => _address = address);
    widget.onAddressGenerated(address); // le dice al padre cuál es la dirección
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dirección para ${widget.recipientName}',
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Hemos generado una dirección segura de simulación para este destinatario.',
          style: TextStyle(
            color: AppColors.blueGray,
            fontSize: 16,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 32),
        SatoshiDataContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryAmber,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Paso 2: Dirección generada',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'DIRECCIÓN BITCOIN (SIMULADA)',
                style: TextStyle(
                  color: AppColors.primaryAmber,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.charcoalBlack,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _address,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SatoshiWarningCard(
          title: 'No uses esta dirección',
          description:
              'Esta es una dirección generada únicamente para fines educativos dentro de SatoshiMex.',
        ),
      ],
    );
  }
}
