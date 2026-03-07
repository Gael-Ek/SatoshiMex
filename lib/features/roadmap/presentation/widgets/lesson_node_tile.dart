import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/roadmap/data/models/lesson_node.dart';
import 'package:satoshimex/features/roadmap/presentation/widgets/pulsing_node.dart';
import 'package:satoshimex/features/roadmap/presentation/widgets/static_node.dart';

import '../../../../shared/models/models.dart';

class LessonNodeTile extends ConsumerWidget {
  final LessonNode node;
  final double xFactor;
  final bool isActive;
  final RoadmapModel roadmap;

  const LessonNodeTile({
    super.key,
    required this.node,
    required this.xFactor,
    required this.isActive,
    required this.roadmap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final nodeSize = isActive ? 88.0 : 72.0;
    final left = ((screenWidth * xFactor) - nodeSize / 2).clamp(
      16.0,
      screenWidth - nodeSize - 16,
    );

    final Color color;
    final Widget icon;

    if (node.isCompleted) {
      color = AppColors.primaryAmber;
      icon = const Icon(
        Icons.check_rounded,
        color: Color(0xFF0E0B0B),
        size: 32,
      );
    } else if (node.isLocked) {
      color = const Color(0xFF3A3A3A);
      icon = const Icon(Icons.lock_rounded, color: Colors.white38, size: 28);
    } else if (isActive) {
      color = AppColors.primaryAmber;
      icon = const Icon(
        Icons.play_arrow_rounded,
        color: Color(0xFF0E0B0B),
        size: 36,
      );
    } else {
      color = AppColors.primaryAmber.withValues(alpha: .7);
      icon = const Icon(Icons.star_rounded, color: Color(0xFF0E0B0B), size: 28);
    }

    return SizedBox(
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: left,
            top: 16,
            child: GestureDetector(
              onTap: node.isLocked
                  ? () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Completa la unidad anterior primero'),
                        backgroundColor: Color(0xFF1a1a1a),
                      ),
                    )
                  : () => context.push(
                      '/lesson',
                      extra: {
                        'lesson': node.lesson,
                        'unitId': node.unit!.id,
                        'roadmap': roadmap,
                      },
                    ),
              child: Column(
                children: [
                  if (isActive)
                    PulsingNode(size: nodeSize, color: color, child: icon)
                  else
                    StaticNode(
                      size: nodeSize,
                      color: color,
                      opacity: node.isLocked ? 0.5 : 1.0,
                      child: icon,
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        Text(
                          node.lesson!.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: node.isLocked
                                ? Colors.white30
                                : Colors.white,
                          ),
                        ),
                        if (node.isCompleted)
                          const Text(
                            'COMPLETADO',
                            style: TextStyle(
                              fontSize: 9,
                              color: AppColors.primaryAmber,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        if (isActive)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryAmber,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'INICIAR',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0E0B0B),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
