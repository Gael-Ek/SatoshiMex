import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';

// ¡AQUÍ ESTÁN TUS LEGOS IMPORTADOS!
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_learning_progress.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_data_container.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_warning_card.dart';

enum FeePriority { baja, media, alta }

class WalletSendStepThreeScreen extends StatefulWidget {
  final String recipientAddress;
  final double amountToSend;

  const WalletSendStepThreeScreen({
    super.key,
    required this.recipientAddress,
    required this.amountToSend,
  });

  @override
  State<WalletSendStepThreeScreen> createState() =>
      _WalletSendStepThreeScreenState();
}

class _WalletSendStepThreeScreenState extends State<WalletSendStepThreeScreen> {
  FeePriority _selectedFee = FeePriority.media;

  final int _feeBajaSats = 2000;
  final int _feeMediaSats = 4200;
  final int _feeAltaSats = 8000;

  int get _currentFeeSats {
    switch (_selectedFee) {
      case FeePriority.baja:
        return _feeBajaSats;
      case FeePriority.media:
        return _feeMediaSats;
      case FeePriority.alta:
        return _feeAltaSats;
    }
  }

  double get _totalEstimatedBtc {
    double feeInBtc = _currentFeeSats / 100000000;
    return widget.amountToSend + feeInBtc;
  }

  String _formatSats(int sats) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String mathFunc(Match match) => '${match[1]},';
    return sats.toString().replaceAllMapped(reg, mathFunc);
  }

  String _formatBtc(double btc) {
    return btc.toStringAsFixed(8).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Billetera',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Simular envío de\nBitcoin',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              const WalletLearningProgress(currentStep: 3, totalSteps: 4),
              const SizedBox(height: 32),

              // ¡CÓDIGO REDUCIDO AQUÍ! Usamos SatoshiDataContainer directamente
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: SatoshiDataContainer(
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

                        _buildFeeOption(
                          priority: FeePriority.baja,
                          title: 'Baja (30-60 mins)',
                          subtitle: 'Menor costo, confirmación lenta',
                          usdCost: '~1.20 USD',
                        ),
                        const SizedBox(height: 12),

                        _buildFeeOption(
                          priority: FeePriority.media,
                          title: 'Media (10-20 mins)',
                          subtitle: 'Equilibrio ideal entre costo y velocidad',
                          usdCost: '~2.50 USD',
                          isRecommended: true,
                        ),
                        const SizedBox(height: 12),

                        _buildFeeOption(
                          priority: FeePriority.alta,
                          title: 'Alta (~10 mins)',
                          subtitle:
                              'Prioridad máxima, primer bloque disponible',
                          usdCost: '~4.80 USD',
                        ),
                        const SizedBox(height: 24),

                        // ¡CÓDIGO REDUCIDO AQUÍ! Usamos tu SatoshiWarningCard
                        const SatoshiWarningCard(
                          title: 'Sobre las comisiones',
                          description:
                              'La comisión es el incentivo para que los mineros procesen tu transacción. A mayor comisión, más rápido se confirma.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Resumen Matemático Inferior (Se queda igual, es puro texto dinámico)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Monto a enviar',
                          style: TextStyle(
                            color: AppColors.blueGray,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${_formatBtc(widget.amountToSend)} BTC',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Comisión seleccionada',
                          style: TextStyle(
                            color: AppColors.blueGray,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${_formatSats(_currentFeeSats)} SATS',
                          style: const TextStyle(
                            color: AppColors.primaryAmber,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: AppColors.deepNavy, thickness: 2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total estimado',
                          style: TextStyle(
                            color: AppColors.blueGray,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${_formatBtc(_totalEstimatedBtc)} BTC',
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
              ),
              const SizedBox(height: 24),

              SatoshiButton(
                text: 'Continuar',
                onPressed: () {
                  context.push(
                    '/wallet-send-step-4',
                    extra: {
                      'address': widget.recipientAddress,
                      'amount': widget.amountToSend,
                      'feeSats': _currentFeeSats,
                      'totalBtc': _totalEstimatedBtc,
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Widget de las opciones (ya corregido el Wrap)
  Widget _buildFeeOption({
    required FeePriority priority,
    required String title,
    required String subtitle,
    required String usdCost,
    bool isRecommended = false,
  }) {
    final isSelected = _selectedFee == priority;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFee = priority;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.charcoalBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryAmber
                : AppColors.blueGray.withOpacity(0.2),
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
