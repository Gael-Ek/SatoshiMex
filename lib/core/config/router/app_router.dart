import 'package:go_router/go_router.dart';
import 'package:satoshimex/features/screens.dart';

final GoRouter approuter = GoRouter(
  initialLocation: '/register',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);
