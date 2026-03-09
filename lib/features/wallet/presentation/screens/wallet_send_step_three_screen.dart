// send_step3_content.dart
import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_data_container.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_warning_card.dart';

enum FeePriority { baja, media, alta }

class SendStep3Content extends StatefulWidget {
  final double amountToSend;
  final ValueChanged<int> onFeeChanged; // notifica los sats al padre

  const SendStep3Content({
    super.key,
    required this.amountToSend,
    required this.onFeeChanged,
  });

  @override
  State<SendStep3Content> createState() => _SendStep3ContentState();
}

class _SendStep3ContentState extends State<SendStep3Content> {
  FeePriority _selected = FeePriority.media;

  static const _fees = {
    FeePriority.baja: 2000,
    FeePriority.media: 4200,
    FeePriority.alta: 8000,
  };

  int get _currentSats => _fees[_selected]!;
  double get _totalBtc => widget.amountToSend + (_currentSats / 100000000);

  String _fmtSats(int s) {
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return s.toString().replaceAllMapped(reg, (m) => '${m[1]},');
  }

  String _fmtBtc(double b) =>
      b.toStringAsFixed(8).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');

  void _select(FeePriority p) {
    setState(() => _selected = p);
    widget.onFeeChanged(_fees[p]!);
  }

  @override
  void initState() {
    super.initState();
    // Notifica el valor inicial
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onFeeChanged(_currentSats),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SatoshiDataContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Comisión de red',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _FeeOption(
                priority: FeePriority.baja,
                selected: _selected,
                title: 'Baja (30-60 mins)',
                subtitle: 'Menor costo, confirmación lenta',
                usdCost: '~1.20 USD',
                onTap: _select,
              ),
              const SizedBox(height: 12),
              _FeeOption(
                priority: FeePriority.media,
                selected: _selected,
                title: 'Media (10-20 mins)',
                subtitle: 'Equilibrio ideal entre costo y velocidad',
                usdCost: '~2.50 USD',
                isRecommended: true,
                onTap: _select,
              ),
              const SizedBox(height: 12),
              _FeeOption(
                priority: FeePriority.alta,
                selected: _selected,
                title: 'Alta (~10 mins)',
                subtitle: 'Prioridad máxima, primer bloque disponible',
                usdCost: '~4.80 USD',
                onTap: _select,
              ),
              const SizedBox(height: 24),
              const SatoshiWarningCard(
                title: 'Sobre las comisiones',
                description:
                    'La comisión es el incentivo para que los mineros procesen tu transacción.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Resumen matemático
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              _SummaryRow(
                'Monto a enviar',
                '${_fmtBtc(widget.amountToSend)} BTC',
              ),
              const SizedBox(height: 12),
              _SummaryRow(
                'Comisión seleccionada',
                '${_fmtSats(_currentSats)} SATS',
                valueColor: AppColors.primaryAmber,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: AppColors.deepNavy, thickness: 2),
              ),
              _SummaryRow(
                'Total estimado',
                '${_fmtBtc(_totalBtc)} BTC',
                bold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool bold;
  const _SummaryRow(
    this.label,
    this.value, {
    this.valueColor = AppColors.white,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.blueGray, fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: bold ? 16 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _FeeOption extends StatelessWidget {
  final FeePriority priority;
  final FeePriority selected;
  final String title, subtitle, usdCost;
  final bool isRecommended;
  final ValueChanged<FeePriority> onTap;

  const _FeeOption({
    required this.priority,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.usdCost,
    this.isRecommended = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = priority == selected;
    return GestureDetector(
      onTap: () => onTap(priority),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.charcoalBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryAmber
                : AppColors.blueGray.withValues(alpha: .2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primaryAmber : AppColors.blueGray,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.blueGray,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (isRecommended)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAmber,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'RECOMENDADO',
                            style: TextStyle(
                              color: AppColors.charcoalBlack,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.blueGray,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              usdCost,
              style: TextStyle(
                color: isSelected ? AppColors.primaryAmber : AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
