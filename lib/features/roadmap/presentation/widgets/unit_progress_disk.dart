import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/progress_provider.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/states/roadmap_states.dart';
import 'package:satoshimex/shared/models/models.dart';

class UnitProgressDisk extends ConsumerWidget implements PreferredSizeWidget {
  final RoadmapModel roadmap;
  const UnitProgressDisk({super.key, required this.roadmap});

  @override
  Size get preferredSize => const Size.fromHeight(80); // Altura del panel

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(progressProvider(roadmap));

    // 1. Buscamos la unidad actual (la primera no completada)
    final activeUnit = roadmap.units.firstWhere(
      (u) =>
          !ref.read(progressProvider(roadmap).notifier).isUnitCompleted(u.id),
      orElse: () => roadmap.units.first,
    );

    // 2. Calculamos lecciones completadas de ESA unidad
    final unitProgress = progressState.firstWhere(
      (p) => p.unitId == activeUnit.id,
      orElse: () => UnitProgress(unitId: activeUnit.id, lessons: []),
    );

    final completed = unitProgress.lessons.where((l) => l.completed).length;
    final total = activeUnit.lessons.length;
    final percent = total > 0 ? completed / total : 0.0;
    final unitIndex = roadmap.units.indexOf(activeUnit) + 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "UNIDAD $unitIndex",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                '$completed / $total LECCIONES',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryAmber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: .1),
              color: AppColors.primaryAmber,
            ),
          ),
        ],
      ),
    );
  }
}
