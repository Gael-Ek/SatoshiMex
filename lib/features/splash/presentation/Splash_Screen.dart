import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Importamos el archivo de barril para tener acceso a tus nuevos widgets
import 'package:satoshimex/core/widgets/app_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Lógica para saltar automáticamente a la siguiente pantalla
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(
          '/onboarding',
        ); // Usa la ruta que ya tienes en app_router.dart
      }
    });
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
