import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:satoshimex/features/onboarding/presentation/widgets/robot_ilustration.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RobotIllustration(),
        const SizedBox(height: 48),
        Text(
          'Tu guia personal de IA',
          textAlign: TextAlign.center,
          style: GoogleFonts.lexend(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 16.0),

        Text(
          "Pregunta lo que quieras sobre blockchain, minería o billeteras en cualquier momento.",
          textAlign: TextAlign.center,
          style: GoogleFonts.lexend(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            height: 1.5, // leading-relaxed
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
