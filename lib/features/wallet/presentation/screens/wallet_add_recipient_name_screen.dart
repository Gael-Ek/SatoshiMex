// wallet_add_recipient_name_content.dart
import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_data_container.dart';

class RecipientNameContent extends StatelessWidget {
  final TextEditingController nameController;

  const RecipientNameContent({super.key, required this.nameController});

  void _fillSuggestion(String name) {
    nameController.text = name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Crear destinatario',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Para enviar Bitcoin necesitas la dirección de la persona que recibirá la transacción.',
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
              // Encabezado paso
              Row(
                children: [
                  _StepBadge(number: '1'),
                  const SizedBox(width: 12),
                  const Text(
                    'Paso 1: Nombre del destinatario',
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
                'Apodo o nombre',
                style: TextStyle(
                  color: AppColors.blueGray,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.charcoalBlack,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.blueGray.withValues(alpha: .2),
                  ),
                ),
                child: TextField(
                  controller: nameController,
                  style: const TextStyle(color: AppColors.white),
                  decoration: const InputDecoration(
                    hintText: 'Ej: Mi Wallet Personal',
                    hintStyle: TextStyle(color: AppColors.blueGray),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'SUGERENCIAS',
                style: TextStyle(
                  color: AppColors.blueGray,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _SuggestionAvatar(
                    initial: 'A',
                    name: 'Alice',
                    onTap: _fillSuggestion,
                  ),
                  const SizedBox(width: 24),
                  _SuggestionAvatar(
                    initial: 'B',
                    name: 'Bob',
                    onTap: _fillSuggestion,
                  ),
                  const SizedBox(width: 24),
                  _SuggestionAvatar(
                    initial: 'S',
                    name: 'Satoshi',
                    onTap: _fillSuggestion,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.charcoalBlack.withValues(alpha: .5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info,
                      color: AppColors.primaryAmber.withValues(alpha: .8),
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Este nombre solo te ayudará a identificar a quién envías Bitcoin.',
                        style: TextStyle(
                          color: AppColors.blueGray,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepBadge extends StatelessWidget {
  final String number;
  const _StepBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: AppColors.primaryAmber,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _SuggestionAvatar extends StatelessWidget {
  final String initial, name;
  final void Function(String) onTap;

  const _SuggestionAvatar({
    required this.initial,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(name),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.charcoalBlack,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryAmber.withValues(alpha: .5),
              ),
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: AppColors.primaryAmber,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(color: AppColors.blueGray, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
