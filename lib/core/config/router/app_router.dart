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
  ],
);
