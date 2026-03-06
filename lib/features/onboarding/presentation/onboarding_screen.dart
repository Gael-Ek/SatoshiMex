import 'package:flutter/material.dart';
import 'package:satoshimex/core/widgets/app_scaffold.dart';
import 'package:satoshimex/core/widgets/app_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [CustomButton(text: 'Precinar', onPressed: () {})],
        ),
      ),
    );
  }
}
