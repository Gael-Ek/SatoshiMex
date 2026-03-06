import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;

  const AppScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF04233b), Color(0xFF65717e)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(backgroundColor: Colors.transparent, body: body),
    );
  }
}
