import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';
import 'package:satoshimex/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:satoshimex/features/onboarding/presentation/screens/chatbot_page.dart';
import 'package:satoshimex/features/onboarding/presentation/screens/learn_bitcoin_page.dart';
import 'package:satoshimex/features/onboarding/presentation/screens/progress_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController controller = PageController();
  int currentPage = 0;

  final List<Widget> pages = const [
    LearnBitcoinPage(),
    ChatbotPage(),
    ProgressPage(),
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
    ref.read(onboardginShowProvider.notifier).completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Column(
                children: [
                  //Verificar si es la ultima pagina
                  if (currentPage == pages.length - 1) ...[
                    //Boto para ir a iniciar sesion
                    CustomButton(
                      text: 'Registrarse',
                      onPressed: () {
                        context.push('/register');
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  CustomButton(
                    text: currentPage == pages.length - 1
                        ? "Continuar como invitado"
                        : "Siguiente",
                    onPressed: currentPage == pages.length - 1
                        ? () {
                            completeOnboarding();
                            context.go('/home');
                          }
                        : nextPage,
                    isSecondary: currentPage == pages.length - 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
