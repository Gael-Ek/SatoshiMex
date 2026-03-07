import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:satoshimex/core/utils/roadmap/get_progress.dart';
import 'package:satoshimex/features/roadmap/presentation/providers/progress_provider.dart';
import 'package:satoshimex/shared/models/models.dart';

part 'roadmap_summary_provider.g.dart';

class RoadmapSummary {
  final int completedLessons;
  final int totalLessons;
  final UnitModel currentUnit;
  final LessonModel? nextLesson;
  final int? nextUnitId;

  RoadmapSummary({
    required this.completedLessons,
    required this.totalLessons,
    required this.currentUnit,
    required this.nextLesson,
    required this.nextUnitId,
  });
}

@riverpod
RoadmapSummary roadmapSummary(Ref ref, RoadmapModel roadmap) {
  final progress = ref.watch(progressProvider(roadmap));

  final stats = GetProgress.lessonStats(progress);

  final currentUnit = GetProgress.getCurrentUnit(roadmap, progress);

  final nextLessonData = GetProgress.getNextLesson(roadmap, progress);

  return RoadmapSummary(
    completedLessons: stats.completed,
    totalLessons: stats.total,
    currentUnit: currentUnit,
    nextLesson: nextLessonData?.lesson,
    nextUnitId: nextLessonData?.unitId,
  );
}
