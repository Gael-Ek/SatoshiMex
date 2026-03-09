import 'package:flutter/material.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class WalletBalanceCard extends StatelessWidget {
  final String balance; // Ej: "0.1 BTC"
  final double btcPriceInMxn; // Ej: 1350000.0 (Viene de la API)

  const WalletBalanceCard({
    super.key,
    required this.balance,
    required this.btcPriceInMxn,
  });

  // Función sencilla para formatear números con comas (Ej: 1000000 -> 1,000,000)
  String _formatWithCommas(double number) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String mathFunc(Match match) => '${match[1]},';
    return number
        .toStringAsFixed(number.truncateToDouble() == number ? 0 : 2)
        .replaceAllMapped(reg, mathFunc);
  }

  @override
  Widget build(BuildContext context) {
    // Extraemos el número puro
    final double btcAmount =
        double.tryParse(balance.replaceAll(' BTC', '').trim()) ?? 0.0;

    // Calculamos el valor en Pesos Mexicanos
    final double mxnValue = btcAmount * btcPriceInMxn;

    // Calculamos los Satoshis
    final double satsValue = btcAmount * 100000000;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.deepNavy,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.slateBlueGray),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.currency_bitcoin,
              size: 120,
              color: AppColors.blueGray.withValues(alpha: .05),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.charcoalBlack.withValues(alpha: .5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: AppColors.primaryAmber,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Saldo de práctica',
                    style: TextStyle(
                      color: AppColors.slateBlueGray,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    balance.replaceAll(' BTC', ''),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'BTC',
                    style: TextStyle(
                      color: AppColors.primaryAmber,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 2. ¡AQUÍ PINTAMOS LOS RESULTADOS MATEMÁTICOS REALES!
              Text(
                '≈ \$${_formatWithCommas(mxnValue)} MXN | ≈ ${_formatWithCommas(satsValue)} SATS',
                style: const TextStyle(
                  color: AppColors.slateBlueGray,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.charcoalBlack.withValues(alpha: .5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primaryAmber.withValues(alpha: .8),
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SALDO EDUCATIVO. NO ES DINERO REAL.',
                      style: TextStyle(
                        color: AppColors.primaryAmber.withValues(alpha: .8),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
