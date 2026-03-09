import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/roadmap_providers.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/streak_provider.dart';
import 'package:satoshimex/features/roadmap/presentation/widgets/roadmap_body.dart';
import 'package:satoshimex/features/roadmap/presentation/widgets/unit_progress_disk.dart';

class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadmapAsync = ref.watch(getRoadmapProvider);
    final streak = ref.watch(streakProvider);

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
        appBar: AppBar(
          title: Text(
            'Aprende Bitcoin',
            style: GoogleFonts.lexend(color: Colors.white),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: UnitProgressDisk(roadmap: roadmap, streak: streak.current),
            ),
          ),
        ),
        body: RoadmapBody(roadmap: roadmap),
      ),
    );
  }
}
