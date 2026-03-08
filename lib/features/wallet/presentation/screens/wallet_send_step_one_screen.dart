// send_step1_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/wallet/presentation/providers/wallet_recipients_provider.dart';
import 'dart:convert';

class Recipient {
  final String name;
  final String address;
  Recipient({required this.name, required this.address});
}

class SendStep1Content extends ConsumerStatefulWidget {
  final TextEditingController addressController;
  final VoidCallback onAddRecipientTap;

  const SendStep1Content({
    super.key,
    required this.addressController,
    required this.onAddRecipientTap,
  });

  @override
  ConsumerState<SendStep1Content> createState() => _SendStep1ContentState();
}

class _SendStep1ContentState extends ConsumerState<SendStep1Content> {
  List<Recipient> _recipients = [];

  @override
  void initState() {
    super.initState();
    _parseRecipients();
  }

  void _parseRecipients() {
    final raw = ref.read(walletRecipientsProvider);
    final parsed = <Recipient>[];
    for (final item in raw) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        parsed.add(Recipient(name: map['name'], address: map['address']));
      } catch (_) {}
    }
    setState(() => _recipients = parsed);
  }

  @override
  Widget build(BuildContext context) {
    // Refrescamos si cambia el provider
    ref.listen(walletRecipientsProvider, (_, _) => _parseRecipients());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input de dirección
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.deepNavy,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.blueGray.withValues(alpha: .1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dirección del destinatario',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.charcoalBlack,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.blueGray.withValues(alpha: .2),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.addressController,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 13,
                          letterSpacing: 1.0,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'bc1q...',
                          hintStyle: TextStyle(color: AppColors.blueGray),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.qr_code_scanner,
                      color: AppColors.primaryAmber,
                      size: 24,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Las direcciones de Bitcoin son únicas para cada usuario.',
                style: TextStyle(
                  color: AppColors.blueGray,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Contactos guardados
        const Text(
          'DESTINATARIOS GUARDADOS',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              ..._recipients.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: _Avatar(
                    name: r.name,
                    initial: r.name.isNotEmpty ? r.name[0].toUpperCase() : '?',
                    onTap: () => widget.addressController.text = r.address,
                  ),
                ),
              ),
              _Avatar(
                name: 'Nuevo',
                icon: Icons.add,
                onTap: widget.onAddRecipientTap,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Warning
        _InfoCard(
          title: 'Siempre verifica los caracteres',
          description:
              'Verifica los primeros 4 y últimos 4 caracteres antes de enviar. Ej: bc1q...3f8a',
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String? initial;
  final IconData? icon;
  final VoidCallback onTap;

  const _Avatar({
    required this.name,
    this.initial,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.charcoalBlack,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryAmber.withValues(alpha: .5),
                width: 2,
              ),
            ),
            child: Center(
              child: icon != null
                  ? Icon(icon, color: AppColors.primaryAmber)
                  : Text(
                      initial ?? '',
                      style: const TextStyle(
                        color: AppColors.primaryAmber,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String description;
  const _InfoCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.deepNavy,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryAmber.withValues(alpha: .3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.primaryAmber,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primaryAmber,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.blueGray,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
