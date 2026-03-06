import 'package:go_router/go_router.dart';
import 'package:satoshimex/features/screens.dart';

final GoRouter approuter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
);
