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
  ],
);
