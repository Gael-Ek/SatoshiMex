import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/button.dart';
import 'package:satoshimex/features/screens.dart';
import 'package:satoshimex/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:satoshimex/shared/models/wallet/wallet.dart';

class WalletCreate extends ConsumerStatefulWidget {
  const WalletCreate({super.key});

  @override
  ConsumerState<WalletCreate> createState() => _WalletCreateState();
}

class _WalletCreateState extends ConsumerState<WalletCreate> {
  final PageController controller = PageController();
  int currentPage = 0;
  static const int totalPages = 3;

  String _selectedBalance = '0.001 BTC';
  final String _simulatedAddress = 'bc1qsatoshimex7xje89x5dfg456hjz8nv9';

  double get progress => (currentPage + 1) / totalPages;

  void nextPage() {
    if (currentPage < totalPages - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      completeOnboarding();
    }
  }

  void completeOnboarding() {
    ref
        .read(walletStateProvider.notifier)
        .completeWalletSetup(
          WalletModel(balance: _selectedBalance, address: _simulatedAddress),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Wallet creada!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Paso ${currentPage + 1} de $totalPages',
          style: const TextStyle(
            color: AppColors.slateBlueGray,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: AppColors.charcoalBlack,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryAmber,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: totalPages,
                onPageChanged: (index) => setState(() => currentPage = index),
                itemBuilder: (_, index) {
                  final pages = [
                    WalletSetupPageOne(
                      onBalanceSelected: (balance) =>
                          setState(() => _selectedBalance = balance),
                    ),
                    const WalletSetupPageTwo(),
                    WalletSetupPageThree(
                      balance: _selectedBalance,
                      address: _simulatedAddress,
                    ),
                  ];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: pages[index],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: CustomButton(
                text: currentPage == totalPages - 1
                    ? 'Crear Cartera'
                    : 'Siguiente',
                onPressed: () {
                  if (currentPage < totalPages - 1) {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  } else {
                    debugPrint('Cartera creada');
                    completeOnboarding();
                    context.pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
