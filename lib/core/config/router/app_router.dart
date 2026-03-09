import 'package:go_router/go_router.dart';
import 'package:satoshimex/features/roadmap/presentation/screens/lesson_screen.dart';
import 'package:satoshimex/features/screens.dart';
import 'package:satoshimex/features/wallet/presentation/screens/carousel_add_recipient.dart';
import 'package:satoshimex/features/wallet/presentation/screens/carruse_send_step.dart';
import 'package:satoshimex/features/wallet/presentation/screens/onboarding_wallet.dart';
import 'package:satoshimex/features/wallet/presentation/screens/wallet_create.dart';

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
      path: '/onboarding_wallet',
      builder: (context, state) => const OnboardingWallet(),
    ),

    GoRoute(
      path: '/create_wallet',
      builder: (context, state) => const WalletCreate(),
    ),

    GoRoute(
      path: '/wallet_dashboard',
      builder: (context, state) => const WalletDashboardScreen(),
    ),

    GoRoute(
      path: '/add-recipient',
      builder: (context, state) => const CarouselAddRecipient(),
    ),

    GoRoute(
      path: '/wallet-send',
      builder: (context, state) => const CarruseSendStep(),
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

    GoRoute(
      path: '/wallet-receive',
      builder: (context, state) => const WalletReceiveScreen(),
    ),
  ],
);
