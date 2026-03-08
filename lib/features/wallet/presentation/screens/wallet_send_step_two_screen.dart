import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';
import 'package:satoshimex/core/services/bitcoin_api_service.dart';

// ¡NUESTROS LEGOS!
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_learning_progress.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_data_container.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/satoshi_warning_card.dart';

class WalletSendStepTwoScreen extends StatefulWidget {
  final String recipientAddress;

  const WalletSendStepTwoScreen({super.key, required this.recipientAddress});

  @override
  State<WalletSendStepTwoScreen> createState() =>
      _WalletSendStepTwoScreenState();
}

class _WalletSendStepTwoScreenState extends State<WalletSendStepTwoScreen> {
  final TextEditingController _amountController = TextEditingController();

  double _availableBalanceBtc = 0.0;
  double _currentBtcPriceMxn = 0.0;
  bool _isLoading = true;

  String _mxnEquivalent = '≈ \$0.00 MXN';
  String _satsEquivalent = '≈ 0 SATS';

  double? _selectedPercentage;

  @override
  void initState() {
    super.initState();
    _loadData();
    _amountController.addListener(_calculateEquivalents);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedBalance = prefs.getString('simulatedBalance') ?? '0.001 BTC';

    final parsedBalance =
        double.tryParse(savedBalance.replaceAll(' BTC', '').trim()) ?? 0.0;
    final priceFromApi = await BitcoinApiService.getBitcoinPriceInMXN();

    setState(() {
      _availableBalanceBtc = parsedBalance;
      _currentBtcPriceMxn = priceFromApi;
      _isLoading = false;
    });
  }

  String _formatNumber(double number, {bool isCurrency = false}) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String mathFunc(Match match) => '${match[1]},';
    if (isCurrency) {
      return number.toStringAsFixed(2).replaceAllMapped(reg, mathFunc);
    }
    return number.truncate().toString().replaceAllMapped(reg, mathFunc);
  }

  void _calculateEquivalents() {
    final text = _amountController.text.trim();

    if (_selectedPercentage != null) {
      final expectedAmount = _availableBalanceBtc * _selectedPercentage!;
      final expectedStr = expectedAmount
          .toStringAsFixed(8)
          .replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
      if (text != expectedStr) {
        setState(() {
          _selectedPercentage = null;
        });
      }
    }

    if (text.isEmpty) {
      setState(() {
        _mxnEquivalent = '≈ \$0.00 MXN';
        _satsEquivalent = '≈ 0 SATS';
      });
      return;
    }

    final double? amountBtc = double.tryParse(text);
    if (amountBtc != null) {
      final mxn = amountBtc * _currentBtcPriceMxn;
      final sats = amountBtc * 100000000;

      setState(() {
        _mxnEquivalent = '≈ \$${_formatNumber(mxn, isCurrency: true)} MXN';
        _satsEquivalent = '≈ ${_formatNumber(sats)} SATS';
      });
    }
  }

  void _setPercentage(double percent) {
    setState(() {
      _selectedPercentage = percent;
    });

    final amount = _availableBalanceBtc * percent;
    _amountController.text = amount
        .toStringAsFixed(8)
        .replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
  }

  void _validateAndContinue() {
    final text = _amountController.text.trim();
    final double? amountToDeduct = double.tryParse(text);

    if (amountToDeduct == null || amountToDeduct <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa un monto mayor a 0'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (amountToDeduct > _availableBalanceBtc) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fondos insuficientes en tu saldo de práctica'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.push(
      '/wallet-send-step-3',
      extra: {'address': widget.recipientAddress, 'amount': amountToDeduct},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.blueDark,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryAmber),
        ),
      );
    }

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
              const WalletLearningProgress(currentStep: 2, totalSteps: 4),
              const SizedBox(height: 32),

              // ¡CÓDIGO REDUCIDO! Usamos nuestro SatoshiDataContainer
              SatoshiDataContainer(
                child: Column(
                  children: [
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryAmber,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'BTC',
                                style: TextStyle(
                                  color: AppColors.charcoalBlack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'MXN',
                              style: TextStyle(
                                color: AppColors.blueGray,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'SATS',
                              style: TextStyle(
                                color: AppColors.blueGray,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.charcoalBlack,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.blueGray.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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
                      child: Divider(
                        color: AppColors.charcoalBlack,
                        thickness: 2,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Saldo disponible:',
                          style: TextStyle(
                            color: AppColors.blueGray,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '$_availableBalanceBtc BTC',
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
                        Expanded(child: _buildPercentageButton('25%', 0.25)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildPercentageButton('50%', 0.50)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildPercentageButton('100%', 1.0)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ¡CÓDIGO REDUCIDO! Usamos SatoshiWarningCard adaptada a modo informativo
              const SatoshiWarningCard(
                title: 'Fracciones de Bitcoin',
                description:
                    'Puedes enviar una fracción de Bitcoin. Un Bitcoin se divide en 100 millones de Satoshis (SATS).',
              ),

              const Spacer(),

              SatoshiButton(
                text: 'Continuar',
                icon: Icons.arrow_forward_ios,
                onPressed: _validateAndContinue,
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'En el siguiente paso elegirás la comisión de red.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blueGray,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPercentageButton(String text, double percent) {
    final isSelected = _selectedPercentage == percent;

    return GestureDetector(
      onTap: () => _setPercentage(percent),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.charcoalBlack,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryAmber.withOpacity(0.5)
                : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.primaryAmber : AppColors.blueGray,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
