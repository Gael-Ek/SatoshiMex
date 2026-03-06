import 'package:flutter/material.dart';

class ActivitedScreen extends StatelessWidget {
  const ActivitedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activited Screen')),
      body: const Center(child: Text('This is the Activited Screen')),
    );
  }
}
