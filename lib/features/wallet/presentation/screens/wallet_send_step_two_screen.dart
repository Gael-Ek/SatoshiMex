// send_step2_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_data_container.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_warning_card.dart';
import 'package:satoshimex/features/wallet/presentation/providers/wallet_transaction_provider.dart';

class SendStep2Content extends ConsumerStatefulWidget {
  final TextEditingController amountController;
  // Notifica cambios de equivalentes al padre si los necesita
  final ValueChanged<String> onMxnChanged;
  final ValueChanged<String> onSatsChanged;

  const SendStep2Content({
    super.key,
    required this.amountController,
    required this.onMxnChanged,
    required this.onSatsChanged,
  });

  @override
  ConsumerState<SendStep2Content> createState() => _SendStep2ContentState();
}

class _SendStep2ContentState extends ConsumerState<SendStep2Content> {
  String _mxnEquivalent = '≈ \$0.00 MXN';
  String _satsEquivalent = '≈ 0 SATS';
  double? _selectedPercentage;

  @override
  void initState() {
    super.initState();
    widget.amountController.addListener(_calculateEquivalents);
  }

  @override
  void dispose() {
    widget.amountController.removeListener(_calculateEquivalents);
    super.dispose();
  }

  void _calculateEquivalents() {
    final walletAsync = ref.read(walletTransaction_Provider);
    final wallet = walletAsync.value;
    if (wallet == null) return;

    final text = widget.amountController.text.trim();

    // Desseleccionar porcentaje si el usuario escribe manualmente
    if (_selectedPercentage != null) {
      final expected = (wallet.balanceBtc * _selectedPercentage!)
          .toStringAsFixed(8)
          .replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
      if (text != expected) setState(() => _selectedPercentage = null);
    }

    if (text.isEmpty) {
      setState(() {
        _mxnEquivalent = '≈ \$0.00 MXN';
        _satsEquivalent = '≈ 0 SATS';
      });
      return;
    }

    final amount = double.tryParse(text);
    if (amount != null) {
      final mxn = amount * wallet.btcPriceMxn;
      final sats = amount * 100000000;
      final mxnStr = '≈ \$${_fmt(mxn, currency: true)} MXN';
      final satsStr = '≈ ${_fmt(sats)} SATS';
      setState(() {
        _mxnEquivalent = mxnStr;
        _satsEquivalent = satsStr;
      });
      widget.onMxnChanged(mxnStr);
      widget.onSatsChanged(satsStr);
    }
  }

  String _fmt(double n, {bool currency = false}) {
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String fn(Match m) => '${m[1]},';
    return currency
        ? n.toStringAsFixed(2).replaceAllMapped(reg, fn)
        : n.truncate().toString().replaceAllMapped(reg, fn);
  }

  void _setPercentage(double percent, double balance) {
    setState(() => _selectedPercentage = percent);
    widget.amountController.text = (balance * percent)
        .toStringAsFixed(8)
        .replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
  }

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(walletTransaction_Provider);

    return walletAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryAmber),
      ),
      error: (e, _) => Center(
        child: Text(
          'Error: $e',
          style: const TextStyle(color: AppColors.white),
        ),
      ),
      data: (wallet) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SatoshiDataContainer(
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Monto a enviar',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        _CurrencyTag(label: 'BTC', active: true),
                        const SizedBox(width: 8),
                        _CurrencyTag(label: 'MXN'),
                        const SizedBox(width: 8),
                        _CurrencyTag(label: 'SATS'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Input
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.charcoalBlack,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.blueGray.withValues(alpha: .2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: widget.amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: '0.00',
                            hintStyle: TextStyle(color: AppColors.blueGray),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Text(
                        'BTC',
                        style: TextStyle(
                          color: AppColors.blueGray,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _mxnEquivalent,
                      style: const TextStyle(
                        color: AppColors.blueGray,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _satsEquivalent,
                      style: const TextStyle(
                        color: AppColors.blueGray,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: AppColors.charcoalBlack, thickness: 2),
                ),

                // Balance y porcentajes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Saldo disponible:',
                      style: TextStyle(color: AppColors.blueGray, fontSize: 13),
                    ),
                    Text(
                      '${wallet.balanceBtc} BTC',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _PctButton(
                        label: '25%',
                        selected: _selectedPercentage == 0.25,
                        onTap: () => _setPercentage(0.25, wallet.balanceBtc),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PctButton(
                        label: '50%',
                        selected: _selectedPercentage == 0.50,
                        onTap: () => _setPercentage(0.50, wallet.balanceBtc),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PctButton(
                        label: '100%',
                        selected: _selectedPercentage == 1.0,
                        onTap: () => _setPercentage(1.0, wallet.balanceBtc),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SatoshiWarningCard(
            title: 'Fracciones de Bitcoin',
            description:
                'Puedes enviar una fracción de Bitcoin. Un Bitcoin se divide en 100 millones de Satoshis (SATS).',
          ),
        ],
      ),
    );
  }
}

class _CurrencyTag extends StatelessWidget {
  final String label;
  final bool active;
  const _CurrencyTag({required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return active
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryAmber,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.charcoalBlack,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Text(
            label,
            style: const TextStyle(
              color: AppColors.blueGray,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          );
  }
}

class _PctButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _PctButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.charcoalBlack,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? AppColors.primaryAmber.withValues(alpha: .5)
                : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.primaryAmber : AppColors.blueGray,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
