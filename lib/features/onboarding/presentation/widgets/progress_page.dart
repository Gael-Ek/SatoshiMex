import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:satoshimex/features/onboarding/presentation/widgets/timeline_progress.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Sección de Timeline (Contenedor visual)
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            TimelineProgress(
              title: "Conceptos Básicos",
              subtitle: "Completado",
              completed: true,
            ),
            TimelineProgress(
              title: "Bitcoin Avanzado",
              subtitle: "Completado",
              completed: true,
            ),
            TimelineProgress(
              title: "Bóveda Segura",
              subtitle: "Desbloquea con tu cuenta",
              isLast: true,
            ),
          ],
        ),

        const SizedBox(height: 48), // Espacio amplio entre gráfico y texto
        // TÍTULO
        Text(
          'No pierdas tu progreso',
          textAlign: TextAlign.center,
          style: GoogleFonts.lexend(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 16),

        // DESCRIPCIÓN
        Text(
          'Crea una cuenta para sincronizar tu progreso en todos tus dispositivos y proteger tus Sats obtenidos.',
          textAlign: TextAlign.center,
          style: GoogleFonts.lexend(
            fontSize: 16,
            color: Colors.white.withValues(alpha: .7),
            height: 1.5, // Equivale a leading-relaxed
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
