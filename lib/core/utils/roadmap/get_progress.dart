import '../../../shared/models/models.dart';
import '../../../features/roadmap/presentation/providers/states/roadmap_states.dart';

class GetProgress {
  /// total y completadas
  static ({int completed, int total}) lessonStats(List<UnitProgress> progress) {
    int completed = 0;
    int total = 0;

    for (final unit in progress) {
      for (final lesson in unit.lessons) {
        total++;

        if (lesson.completed) {
          completed++;
        }
      }
    }

    return (completed: completed, total: total);
  }

  /// unidad actual
  static UnitModel getCurrentUnit(
    RoadmapModel roadmap,
    List<UnitProgress> progress,
  ) {
    for (final unit in roadmap.units) {
      final unitProgress = progress.firstWhere(
        (u) => u.unitId == unit.id,
        orElse: () => UnitProgress(unitId: unit.id, lessons: []),
      );

      final completed =
          unitProgress.lessons.isNotEmpty &&
          unitProgress.lessons.every((l) => l.completed);

      if (!completed) return unit;
    }

    return roadmap.units.last;
  }

  /// siguiente lección
  static ({LessonModel lesson, int unitId})? getNextLesson(
    RoadmapModel roadmap,
    List<UnitProgress> progress,
  ) {
    for (final unit in roadmap.units) {
      final unitProgress = progress.firstWhere(
        (u) => u.unitId == unit.id,
        orElse: () => UnitProgress(unitId: unit.id, lessons: []),
      );

      for (final lesson in unit.lessons) {
        final lessonProgress = unitProgress.lessons.firstWhere(
          (l) => l.lessonId == lesson.id,
          orElse: () => LessonProgress(lessonId: lesson.id, sectionCount: 0),
        );

        if (!lessonProgress.completed) {
          return (lesson: lesson, unitId: unit.id);
        }
      }
    }

    return null;
  }
}
