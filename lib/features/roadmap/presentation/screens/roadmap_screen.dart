import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/roadmap_providers.dart';

class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadmap = ref.watch(getRoadmapProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: roadmap.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text(
              'Error al cargar el roadmap $error',
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
            data: (data) => ListView.builder(
              itemCount: data.units.length,
              itemBuilder: (context, index) {
                final unit = data.units[index];
                return ListTile(
                  title: Text(unit.title),
                  subtitle: Text(
                    unit.lessons.map((lesson) => lesson.title).join(', '),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
