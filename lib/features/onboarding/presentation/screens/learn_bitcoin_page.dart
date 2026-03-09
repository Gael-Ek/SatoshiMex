import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:satoshimex/features/onboarding/presentation/widgets/bitcoin_logo.dart';

class LearnBitcoinPage extends StatelessWidget {
  const LearnBitcoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BitcoinLogo(),

        const SizedBox(height: 48),

        Text(
          "Aprende sobre Bitcoin paso a paso",
          textAlign: TextAlign.center,
          style: GoogleFonts.lexend(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: 280,
          child: Text(
            "Completa lecciones, gana sats y domina el oro digital.",
            textAlign: TextAlign.center,
            style: GoogleFonts.lexend(
              fontSize: 16,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ),

        SizedBox(height: 32),
      ],
    );
  }
}
