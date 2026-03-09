import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/roadmap_summary_provider.dart';
import 'package:satoshimex/shared/models/models.dart';

class UnitProgressDisk extends ConsumerWidget {
  final RoadmapModel roadmap;
  final int streak;

  const UnitProgressDisk({
    super.key,
    required this.roadmap,
    required this.streak,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(roadmapSummaryProvider(roadmap));

    final completed = summary.completedLessons;
    final total = summary.totalLessons;

    final percent = total > 0 ? completed / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "UNIDAD ${summary.currentUnit.id}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  "$streak",
                  style: GoogleFonts.lexend(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),

        Text(
          "$completed/$total lecciones",
          style: GoogleFonts.lexend(fontSize: 14, color: Colors.white70),
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
    );
  }
}
