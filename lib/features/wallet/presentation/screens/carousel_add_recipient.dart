// carousel_add_recipient.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:satoshimex/features/wallet/presentation/screens/wallet_add_recipient_address_screen.dart';
import 'package:satoshimex/features/wallet/presentation/screens/wallet_add_recipient_name_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/button.dart';
import 'package:satoshimex/features/wallet/presentation/providers/wallet_recipients_provider.dart';

class CarouselAddRecipient extends ConsumerStatefulWidget {
  const CarouselAddRecipient({super.key});

  @override
  ConsumerState<CarouselAddRecipient> createState() =>
      _CarouselAddRecipientState();
}

class _CarouselAddRecipientState extends ConsumerState<CarouselAddRecipient> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();

  int _currentPage = 0;
  String _generatedAddress = '';
  bool _isSaving = false;

  static const int _totalPages = 2;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // ── Navegación

  void _goNext() {
    if (_currentPage == 0) {
      // Validar nombre antes de avanzar
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor ingresa un nombre o elige una sugerencia'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

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

  // ── Guardar con Riverpod ────────────────────────────────────

  Future<void> _saveAndFinish() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final name = _nameController.text.trim();
      final recipientJson = '{"name":"$name","address":"$_generatedAddress"}';

      await ref
          .read(walletRecipientsProvider.notifier)
          .addRecipient(recipientJson);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Contacto guardado con éxito!'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/wallet_dashboard');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ── UI ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _totalPages - 1;

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
          'Crear destinatario',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!isLastPage)
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
          children: [
            // ── Barra de progreso ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: _WalletStepProgress(
                current: _currentPage + 1,
                total: _totalPages,
              ),
            ),

            // ── Páginas ──
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  // Página 1
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: RecipientNameContent(
                      nameController: _nameController,
                    ),
                  ),
                  // Página 2
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: RecipientAddressContent(
                      recipientName: _nameController.text.trim(),
                      onAddressGenerated: (addr) => _generatedAddress = addr,
                    ),
                  ),
                ],
              ),
            ),

            // ── Indicador de puntos ──
            SmoothPageIndicator(
              controller: _pageController,
              count: _totalPages,
              effect: ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: AppColors.primaryAmber,
                dotColor: AppColors.primaryAmber.withValues(alpha: 0.5),
              ),
            ),

            // ── Botón principal ──
            Padding(
              padding: const EdgeInsets.all(24),
              child: _isSaving
                  ? const CircularProgressIndicator(
                      color: AppColors.primaryAmber,
                    )
                  : CustomButton(
                      text: isLastPage ? 'Guardar Contacto' : 'Siguiente',
                      onPressed: isLastPage ? _saveAndFinish : _goNext,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de barra de progreso por pasos
class _WalletStepProgress extends StatelessWidget {
  final int current;
  final int total;
  const _WalletStepProgress({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = i < current;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? 8 : 0),
            height: 4,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primaryAmber
                  : AppColors.blueGray.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
