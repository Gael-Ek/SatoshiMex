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
  bool _isChecked = false;
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

  bool get isChecked => _isChecked;

  @override
  Widget build(BuildContext context) {
    final feeType = widget.feeSats == 2000
        ? 'Baja'
        : widget.feeSats == 4200
        ? 'Media'
        : 'Alta';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SatoshiDataContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Destinatario
              Row(
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
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.primaryAmber.withValues(alpha: .8),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DESTINATARIO',
                        style: TextStyle(
                          color: AppColors.blueGray,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        _recipientName,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Dirección
              const Text(
                'DIRECCIÓN DE BITCOIN',
                style: TextStyle(
                  color: AppColors.blueGray,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.charcoalBlack,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.address,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 13,
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: AppColors.charcoalBlack, thickness: 2),
              ),

              // Monto
              _ReceiptRow(
                label: 'Monto a enviar',
                value: '${_fmtBtc(widget.amount)} BTC',
                sub: '≈ \$${_fmt(_amountInMxn, currency: true)} MXN',
              ),
              const SizedBox(height: 20),

              // Comisión
              _ReceiptRow(
                label: 'Comisión de red',
                value: feeType,
                valueColor: AppColors.primaryAmber,
                sub: '${_fmt(widget.feeSats.toDouble())} SATS',
              ),
              const SizedBox(height: 20),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total a deducir',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_fmtBtc(widget.totalBtc)} BTC',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        const SatoshiWarningCard(
          title: 'Recuerda',
          description:
              'Una vez enviada una transacción real en la red Bitcoin, no se puede deshacer.',
        ),
        const SizedBox(height: 24),

        // Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _isChecked,
                activeColor: AppColors.primaryAmber,
                checkColor: AppColors.charcoalBlack,
                side: const BorderSide(color: AppColors.blueGray),
                onChanged: (v) => setState(() => _isChecked = v ?? false),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'He verificado que la dirección y el monto son correctos.',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label, value;
  final String? sub;
  final Color valueColor;
  const _ReceiptRow({
    required this.label,
    required this.value,
    this.sub,
    this.valueColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.blueGray, fontSize: 14),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (sub != null)
              Text(
                sub!,
                style: const TextStyle(color: AppColors.blueGray, fontSize: 12),
              ),
          ],
        ),
      ],
    );
  }
}
