import 'package:flutter/material.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [CustomButton(text: 'Precinar', onPressed: () {})],
        ),
      ),
    );
  }
}
