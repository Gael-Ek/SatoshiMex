import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:satoshimex/core/config/constants/app_colors.dart';

import 'package:satoshimex/core/widgets/button.dart';

import 'package:satoshimex/features/screens.dart';

import 'package:satoshimex/features/wallet/presentation/providers/wallet_provider.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingWallet extends ConsumerStatefulWidget {
  const OnboardingWallet({super.key});

  @override
  ConsumerState<OnboardingWallet> createState() => _OnboardingWalletState();
}

class _OnboardingWalletState extends ConsumerState<OnboardingWallet> {
  final PageController controller = PageController();

  int currentPage = 0;

  final List<Widget> pages = const [
    WalletIntroPageOne(),

    WalletIntroPageTwo(),

    WalletIntroPageThree(),
  ];

  void nextPage() {
    if (currentPage < pages.length - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),

        curve: Curves.ease,
      );
    } else {
      completeOnboarding();
    }
  }

  void skipOnboarding() {
    controller.animateToPage(
      pages.length - 1,

      duration: const Duration(milliseconds: 300),

      curve: Curves.ease,
    );
  }

  void completeOnboarding() {
    ref.read(walletStateProvider.notifier).markIntroAsSeen();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,

      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          // Esta función se ejecuta cuando el usuario regresa
          ref.read(walletStateProvider.notifier).markIntroAsSeen();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            // Mostrar el boton de saltar solo si no estamos en la primera pagina
            if (currentPage != pages.length - 1)
              TextButton(
                onPressed: skipOnboarding,

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
              Expanded(
                child: PageView.builder(
                  controller: controller,

                  itemCount: pages.length,

                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },

                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),

                      child: pages[index],
                    );
                  },
                ),
              ),

              //Indicadores
              SmoothPageIndicator(
                controller: controller,

                count: 3,

                effect: ExpandingDotsEffect(
                  dotHeight: 10,

                  dotWidth: 10,

                  activeDotColor: AppColors.primaryAmber,

                  dotColor: AppColors.primaryAmber.withValues(alpha: 0.5),
                ),
              ),

              ///Boton de navegacion
              Padding(
                padding: const EdgeInsets.all(24),

                child: CustomButton(
                  text: currentPage == 2 ? 'Comenzar' : 'Siguiente',

                  onPressed: () {
                    if (currentPage == 2) {
                      completeOnboarding();
                      context.pop();
                    } else {
                      nextPage();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
