import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satoshimex/features/roadmap/data/models/lesson_node.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/progress_provider.dart';
import 'package:satoshimex/features/roadmap/presentation/widgets/lesson_node_tile.dart';
import 'package:satoshimex/features/roadmap/presentation/widgets/unit_header_tile.dart';

import '../../../../shared/models/models.dart';

class RoadmapBody extends ConsumerWidget {
  final RoadmapModel roadmap;
  const RoadmapBody({super.key, required this.roadmap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(progressProvider(roadmap));

    // Aplana unidades + lecciones en una lista con headers intercalados
    final List<LessonNode> nodes = [];
    for (final unit in roadmap.units) {
      nodes.add(LessonNode.unitHeader(unit));
      for (final lesson in unit.lessons) {
        final unitProgress = progressState.where((u) => u.unitId == unit.id);
        bool isCompleted = false;
        if (unitProgress.isNotEmpty) {
          final lp = unitProgress.first.lessons.where(
            (l) => l.lessonId == lesson.id,
          );
          if (lp.isNotEmpty) isCompleted = lp.first.completed;
        }
        bool isLocked = unit.id > 1
            ? !ref
                  .read(progressProvider(roadmap).notifier)
                  .isUnitCompleted(unit.id - 1)
            : false;

        nodes.add(
          LessonNode.lesson(
            lesson: lesson,
            unit: unit,
            isCompleted: isCompleted,
            isLocked: isLocked,
          ),
        );
      }
    }

    // Primer nodo disponible = activo
    final activeIndex = nodes.indexWhere(
      (n) => !n.isHeader && !n.isCompleted && !n.isLocked,
    );

    return Stack(
      children: [
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 4,
          top: 0,
          bottom: 0,
          width: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final node = nodes[index];
                  if (node.isHeader) return UnitHeaderTile(unit: node.unit!);

                  final lessonIndex =
                      nodes.take(index + 1).where((n) => !n.isHeader).length -
                      1;
                  const zigzag = [0.65, 0.35, 0.5, 0.2, 0.8];

                  return LessonNodeTile(
                    node: node,
                    xFactor: zigzag[lessonIndex % zigzag.length],
                    isActive: index == activeIndex,
                    roadmap: roadmap,
                  );
                }, childCount: nodes.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ],
    );
  }
}
