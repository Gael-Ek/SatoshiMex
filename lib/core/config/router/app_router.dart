import 'package:go_router/go_router.dart';
import 'package:satoshimex/features/roadmap/presentation/screens/lesson_screen.dart';
import 'package:satoshimex/features/screens.dart';

import '../../../shared/models/models.dart';

final GoRouter approuter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),

    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),

    GoRoute(
      path: '/lesson',
      builder: (context, state) {
        // Recibimos los datos empaquetados en un Map o Record
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return LessonScreen(
          lesson: extra['lesson'] as LessonModel,
          unitId: extra['unitId'] as int,
          roadmap: extra['roadmap'] as RoadmapModel,
        );
      },
    ),

    GoRoute(
      path: '/wallet-intro-1',
      builder: (context, state) => const WalletIntroPageOne(),
    ),
    GoRoute(
      path: '/wallet-intro-2',
      builder: (context, state) => const WalletIntroPageTwo(),
    ),
    GoRoute(
      path: '/wallet-intro-3',
      builder: (context, state) => const WalletIntroPageThree(),
    ),
    GoRoute(
      path: '/wallet-setup-1',
      builder: (context, state) => const WalletSetupPageOne(),
    ),
    GoRoute(
      path: '/wallet-setup-2',
      builder: (context, state) => const WalletSetupPageTwo(),
    ),
    GoRoute(
      path: '/wallet-setup-3',
      builder: (context, state) => const WalletSetupPageThree(),
    ),

    GoRoute(
      path: '/wallet-dashboard',
      builder: (context, state) => const WalletDashboardScreen(),
    ),
    GoRoute(
      path: '/wallet-receive',
      builder: (context, state) => const WalletReceiveScreen(),
    ),

    GoRoute(
      path: '/add-recipient-1',
      builder: (context, state) => const WalletAddRecipientNameScreen(),
    ),
    GoRoute(
      path: '/add-recipient-2',
      builder: (context, state) {
        // Atrapamos el nombre que mandó la pantalla 1
        final name = state.extra as String? ?? 'Desconocido';
        return WalletAddRecipientAddressScreen(recipientName: name);
      },
    ),

    GoRoute(
      path: '/wallet-send-step-1',
      builder: (context, state) => const WalletSendStepOneScreen(),
    ),

    GoRoute(
      path: '/wallet-send-step-2',
      builder: (context, state) {
        // Atrapamos la dirección que nos mandó el Paso 1
        final address = state.extra as String? ?? 'Dirección desconocida';
        return WalletSendStepTwoScreen(recipientAddress: address);
      },
    ),

    GoRoute(
      path: '/wallet-send-step-3',
      builder: (context, state) {
        // Atrapamos la mochila que mandó el Paso 2 (un Mapa con datos)
        final extraData = state.extra as Map<String, dynamic>? ?? {};
        final address = extraData['address'] as String? ?? 'Desconocida';
        final amount = extraData['amount'] as double? ?? 0.0;

        return WalletSendStepThreeScreen(
          recipientAddress: address,
          amountToSend: amount,
        );
      },
    ),

    GoRoute(
      path: '/wallet-send-step-4',
      builder: (context, state) {
        // Atrapamos la mochila completa
        final extraData = state.extra as Map<String, dynamic>? ?? {};

        return WalletSendStepFourScreen(
          address: extraData['address'] as String? ?? '',
          amount: extraData['amount'] as double? ?? 0.0,
          feeSats: extraData['feeSats'] as int? ?? 0,
          totalBtc: extraData['totalBtc'] as double? ?? 0.0,
        );
      },
    ),

    GoRoute(
      path: '/wallet-send-success',
      builder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>? ?? {};
        return WalletSendSuccessScreen(
          recipientName: extraData['recipientName'] as String? ?? 'Desconocido',
          amount: extraData['amount'] as double? ?? 0.0,
          feeSats: extraData['feeSats'] as int? ?? 0,
        );
      },
    ),
  ],
);
