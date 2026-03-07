import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/roadmap_providers.dart';
import 'package:satoshimex/features/roadmap/presentation/widgets/roadmap_body.dart';

class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadmapAsync = ref.watch(getRoadmapProvider);

    return Scaffold(
      body: roadmapAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryAmber),
        ),
        error: (err, _) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        data: (roadmap) => RoadmapBody(roadmap: roadmap),
      ),
    );
  }
}
