import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_balance_option_card.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_info_alert.dart';

class WalletSetupPageOne extends StatefulWidget {
  final void Function(String balance) onBalanceSelected;

  const WalletSetupPageOne({super.key, required this.onBalanceSelected});

  @override
  State<WalletSetupPageOne> createState() => _WalletSetupPageOneState();
}

class _WalletSetupPageOneState extends State<WalletSetupPageOne> {
  int selectedOption = 0;

  static const _options = [
    (
      '0.001 BTC',
      'Ideal para familiarizarse con la plataforma.',
      Icons.account_balance_wallet_outlined,
    ),
    ('0.01 BTC', 'Perfecto para estrategias de trading.', Icons.trending_up),
    (
      '0.1 BTC',
      'Gestión de carteras de alto volumen.',
      Icons.rocket_launch_outlined,
    ),
  ];

  void _selectOption(int index) {
    setState(() => selectedOption = index);
    widget.onBalanceSelected(_options[index].$1);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ELIGE TU SALDO',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '¿Con cuánto Bitcoin te gustaría empezar a practicar?',
              style: TextStyle(color: AppColors.slateBlueGray, fontSize: 16),
            ),
            const SizedBox(height: 32),

            ..._options.asMap().entries.map((entry) {
              final index = entry.key;
              final (amount, description, icon) = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < _options.length - 1 ? 12 : 0,
                ),
                child: WalletBalanceOptionCard(
                  amount: amount,
                  description: description,
                  icon: icon,
                  isRecommended: index == 0,
                  isSelected: selectedOption == index,
                  onTap: () => _selectOption(index),
                ),
              );
            }),

            const SizedBox(height: 32),
            const WalletInfoAlert(
              text: 'Este saldo es ficticio y solo para fines educativos.',
            ),
          ],
        ),
      ),
    );
  }
}
