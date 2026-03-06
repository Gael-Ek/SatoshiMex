import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// Importamos el archivo de barril para tener acceso a tus nuevos widgets
import 'package:satoshimex/core/widgets/app_widgets.dart';
import 'package:satoshimex/features/onboarding/presentation/providers/onboarding_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    await Future.delayed(const Duration(seconds: 3));

    final onboardingCompleted = await ref.read(onboardginShowProvider.future);

    if (!mounted) return;

    if (onboardingCompleted) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // El fondo oscuro ya viene aplicado desde el app_theme.dart
      body: SafeArea(
        child: Column(
          children: [
            Spacer(flex: 2),

            // Usamos tu widget del logo y nombre
            SatoshiLogo(),

            Spacer(flex: 3),

            // Usamos tu widget de la barra de carga y eslogan
            SatoshiLoader(),

            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
