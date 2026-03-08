// carruse_send_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:satoshimex/features/wallet/presentation/screens/wallet_send_step_four_screen.dart';
import 'package:satoshimex/features/wallet/presentation/screens/wallet_send_step_one_screen.dart';
import 'package:satoshimex/features/wallet/presentation/screens/wallet_send_step_three_screen.dart';
import 'package:satoshimex/features/wallet/presentation/screens/wallet_send_step_two_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/button.dart';
import 'package:satoshimex/features/wallet/presentation/providers/wallet_transaction_provider.dart';
import 'package:satoshimex/features/wallet/presentation/widgets/wallet_learning_progress.dart';

class CarruseSendStep extends ConsumerStatefulWidget {
  const CarruseSendStep({super.key});

  @override
  ConsumerState<CarruseSendStep> createState() => _CarruseSendStepState();
}

class _CarruseSendStepState extends ConsumerState<CarruseSendStep> {
  final _pageController = PageController();

  // Controllers compartidos entre pasos
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();

  int _currentPage = 0;
  static const int _totalPages = 4;

  // Estado acumulado entre pasos
  int _feeSats = 4200; // default: media
  bool _isSending = false;

  // Llaves para acceder al estado del paso 4 (checkbox)
  bool _isChecked = false;

  @override
  void dispose() {
    _pageController.dispose();
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // ── Getters calculados ──────────────────────────────────

  double get _amount => double.tryParse(_amountController.text.trim()) ?? 0.0;

  double get _totalBtc => _amount + (_feeSats / 100000000);

  // ── Navegación ──────────────────────────────────────────

  void _goBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      context.pop();
    }
  }

  Future<void> _goNext() async {
    // Validaciones por paso
    if (_currentPage == 0) {
      if (_addressController.text.trim().isEmpty) {
        _snack('Ingresa o selecciona una dirección', error: true);
        return;
      }
    }

    if (_currentPage == 1) {
      final walletAsync = ref.read(walletTransaction_Provider);
      final wallet = walletAsync.value;
      if (_amount <= 0) {
        _snack('Ingresa un monto mayor a 0', error: true);
        return;
      }
      if (wallet != null && _amount > wallet.balanceBtc) {
        _snack('Fondos insuficientes en tu saldo de práctica', error: true);
        return;
      }
    }

    if (_currentPage == _totalPages - 1) {
      // Paso 4: confirmar y enviar
      if (!_isChecked) {
        _snack(
          'Por favor, marca la casilla de verificación para continuar.',
          error: true,
        );
        return;
      }
      await _confirmSend();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  Future<void> _confirmSend() async {
    setState(() => _isSending = true);
    try {
      await ref
          .read(walletTransaction_Provider.notifier)
          .confirmSend(
            address: _addressController.text.trim(),
            amount: _amount,
            feeSats: _feeSats,
            totalBtc: _totalBtc,
          );

      if (!mounted) return;

      // Nombre para la pantalla de éxito
      final name = ref
          .read(walletTransaction_Provider.notifier)
          .findRecipientName(_addressController.text.trim());

      context.go(
        '/wallet-send-success',
        extra: {'recipientName': name, 'amount': _amount, 'feeSats': _feeSats},
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  String get _buttonLabel {
    if (_currentPage == _totalPages - 1) return 'Confirmar y enviar simulación';
    return 'Continuar';
  }

  // ── UI ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: _goBack,
        ),
        title: const Text(
          'Billetera',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (_currentPage < _totalPages - 1)
            TextButton(
              onPressed: () => _pageController.animateToPage(
                _totalPages - 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              ),
              child: Text(
                'Saltar',
                style: GoogleFonts.poppins(
                  color: AppColors.primaryAmber,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título + barra de progreso
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                  WalletLearningProgress(
                    currentStep: _currentPage + 1,
                    totalSteps: _totalPages,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Páginas
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  // Paso 1
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    physics: const BouncingScrollPhysics(),
                    child: SendStep1Content(
                      addressController: _addressController,
                      onAddRecipientTap: () => context
                          .push('/add-recipient')
                          .then(
                            (_) => setState(() {}),
                          ), // refresca después de crear
                    ),
                  ),
                  // Paso 2
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    physics: const BouncingScrollPhysics(),
                    child: SendStep2Content(
                      amountController: _amountController,
                      onMxnChanged: (_) {},
                      onSatsChanged: (_) {},
                    ),
                  ),
                  // Paso 3
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    physics: const BouncingScrollPhysics(),
                    child: SendStep3Content(
                      amountToSend: _amount,
                      onFeeChanged: (sats) => setState(() => _feeSats = sats),
                    ),
                  ),
                  // Paso 4
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    physics: const BouncingScrollPhysics(),
                    child: SendStep4Content(
                      address: _addressController.text.trim(),
                      amount: _amount,
                      feeSats: _feeSats,
                      totalBtc: _totalBtc,
                    ),
                  ),
                ],
              ),
            ),

            // Indicador de puntos
            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _totalPages,
                effect: ExpandingDotsEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: AppColors.primaryAmber,
                  dotColor: AppColors.primaryAmber.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 5),

            if (_currentPage == _totalPages - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
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
                        onChanged: (v) =>
                            setState(() => _isChecked = v ?? false),
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
              ),

            // Botón principal
            Padding(
              padding: const EdgeInsets.all(24),
              child: _isSending
                  ? const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primaryAmber,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Firmando transacción...',
                            style: TextStyle(
                              color: AppColors.primaryAmber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : CustomButton(text: _buttonLabel, onPressed: _goNext),
            ),
          ],
        ),
      ),
    );
  }
}
