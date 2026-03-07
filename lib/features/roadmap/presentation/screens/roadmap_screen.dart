import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/roadmap_providers.dart';
import 'package:satoshimex/features/roadmap/presentation/widgets/roadmap_body.dart';
import 'package:satoshimex/features/roadmap/presentation/widgets/unit_progress_disk.dart';

class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadmapAsync = ref.watch(getRoadmapProvider);

    // Unificamos el estado de carga para toda la pantalla
    return roadmapAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryAmber),
        ),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text(
            'Hubo un problema: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      data: (roadmap) => Scaffold(
        // Ahora el AppBar y el Body tienen acceso directo a 'roadmap'
        appBar: AppBar(
          // Quitamos el title por defecto si UnitProgressDisk ya ocupa el espacio
          title: UnitProgressDisk(roadmap: roadmap),
          centerTitle: true,
        ),
        body: RoadmapBody(roadmap: roadmap),
      ),
    );
  }
}
