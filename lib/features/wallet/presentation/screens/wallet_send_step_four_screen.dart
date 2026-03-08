// send_step4_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/wallet/presentation/providers/wallet_transaction_provider.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_data_container.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_warning_card.dart';

class SendStep4Content extends ConsumerStatefulWidget {
  final String address;
  final double amount;
  final int feeSats;
  final double totalBtc;

  const SendStep4Content({
    super.key,
    required this.address,
    required this.amount,
    required this.feeSats,
    required this.totalBtc,
  });

  @override
  ConsumerState<SendStep4Content> createState() => _SendStep4ContentState();
}

class _SendStep4ContentState extends ConsumerState<SendStep4Content> {
  String _recipientName = 'Desconocido';
  double _amountInMxn = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final walletAsync = ref.read(walletTransaction_Provider);
    walletAsync.whenData((wallet) {
      final name = ref
          .read(walletTransaction_Provider.notifier)
          .findRecipientName(widget.address);
      setState(() {
        _recipientName = name;
        _amountInMxn = widget.amount * wallet.btcPriceMxn;
      });
    });
  }

  String _fmt(double n, {bool currency = false}) {
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String fn(Match m) => '${m[1]},';
    return currency
        ? n.toStringAsFixed(2).replaceAllMapped(reg, fn)
        : n.truncate().toString().replaceAllMapped(reg, fn);
  }

  String _fmtBtc(double b) =>
      b.toStringAsFixed(8).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');

  @override
  Widget build(BuildContext context) {
    final feeType = widget.feeSats == 2000
        ? 'Baja'
        : widget.feeSats == 4200
        ? 'Media'
        : 'Alta';

    final feeColor = widget.feeSats == 2000
        ? Colors.green
        : widget.feeSats == 4200
        ? AppColors.primaryAmber
        : Colors.redAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Destinatario ──────────────────────────────
        SatoshiDataContainer(
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryAmber.withValues(alpha: .15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryAmber.withValues(alpha: .4),
                  ),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: AppColors.primaryAmber,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DESTINATARIO',
                      style: TextStyle(
                        color: AppColors.blueGray,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _recipientName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Dirección con mejor presentación
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.charcoalBlack,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        // Mostramos la dirección truncada con ... en medio
                        widget.address.length > 20
                            ? '${widget.address.substring(0, 10)}...${widget.address.substring(widget.address.length - 10)}'
                            : widget.address,
                        style: const TextStyle(
                          color: AppColors.blueGray,
                          fontSize: 11,
                          letterSpacing: 0.8,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── Resumen financiero ────────────────────────
        SatoshiDataContainer(
          child: Column(
            children: [
              _SummaryRow(
                icon: Icons.arrow_upward_rounded,
                iconColor: Colors.redAccent,
                label: 'Monto a enviar',
                value: '${_fmtBtc(widget.amount)} BTC',
                sub: '≈ \$${_fmt(_amountInMxn, currency: true)} MXN',
              ),
              const _Divider(),
              _SummaryRow(
                icon: Icons.bolt_rounded,
                iconColor: feeColor,
                label: 'Comisión de red',
                value: feeType,
                valueColor: feeColor,
                sub: '${_fmt(widget.feeSats.toDouble())} SATS',
              ),
              const _Divider(),
              _SummaryRow(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: AppColors.white,
                label: 'Total a deducir',
                value: '${_fmtBtc(widget.totalBtc)} BTC',
                isBold: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── Warning ───────────────────────────────────
        const SatoshiWarningCard(
          title: 'Recuerda',
          description:
              'Una vez enviada una transacción real en la red Bitcoin, no se puede deshacer.',
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ── Helpers ────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? sub;
  final Color valueColor;
  final bool isBold;

  const _SummaryRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.sub,
    this.valueColor = AppColors.white,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.blueGray,
                fontSize: isBold ? 15 : 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: isBold ? 16 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (sub != null)
                Text(
                  sub!,
                  style: const TextStyle(
                    color: AppColors.blueGray,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Divider(color: AppColors.charcoalBlack, thickness: 1, height: 1),
    );
  }
}
