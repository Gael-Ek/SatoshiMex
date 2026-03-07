import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:satoshimex/core/providers/providers.dart';
import 'package:satoshimex/core/utils/roadmap/generate_progress.dart';
import 'package:satoshimex/shared/models/models.dart';

import 'states/roadmap_states.dart';

part 'progress_provider.g.dart';

@riverpod
class ProgressNotifier extends _$ProgressNotifier {
  @override
  List<UnitProgress> build(RoadmapModel roadmap) {
    _loadSavedProgress();
    // Si no existe → genera uno vacío (como antes)
    return generateProgressFromRoadmap(roadmap);
  }

  Future<void> _loadSavedProgress() async {
    final prefsService = await ref.read(
      sharedPreferencesServiceProvider.future,
    );
    final saved = prefsService.loadProgress(roadmap.id);

    if (saved != null) {
      state = (saved['units'] as List)
          .map((u) => UnitProgress.fromJson(u))
          .toList();
    }
  }

  // Marca una sección como completada
  void completeSection(int unitId, int lessonId, int sectionIndex) {
    state = [
      for (final unit in state)
        if (unit.unitId == unitId)
          unit.copyWith(
            lessons: [
              for (final lesson in unit.lessons)
                if (lesson.lessonId == lessonId)
                  lesson.copyWith(
                    sections: [
                      for (int i = 0; i < lesson.sections.length; i++)
                        i == sectionIndex ? true : lesson.sections[i],
                    ],
                    completed:
                        lesson.sections.every((s) => s) ||
                        sectionIndex == lesson.sections.length - 1,
                  )
                else
                  lesson,
            ],
          )
        else
          unit,
    ];
    _persist();
  }

  Future<void> _persist() async {
    final prefsService = await ref.read(
      sharedPreferencesServiceProvider.future,
    );
    await prefsService.saveProgress(roadmap.id, {
      'units': state.map((u) => u.toJson()).toList(),
    });
  }

  // Saber si una sección ya está completada
  bool isSectionCompleted(int unitId, int lessonId, int sectionIndex) {
    final unit = state.firstWhere(
      (u) => u.unitId == unitId,
      orElse: () => UnitProgress(unitId: unitId, lessons: []),
    );
    final lesson = unit.lessons.firstWhere(
      (l) => l.lessonId == lessonId,
      orElse: () => LessonProgress(lessonId: lessonId, sectionCount: 0),
    );
    return lesson.sections.length > sectionIndex &&
        lesson.sections[sectionIndex];
  }

  // Saber si una lección está completa
  bool isLessonCompleted(int unitId, int lessonId) {
    final unit = state.firstWhere(
      (u) => u.unitId == unitId,
      orElse: () => UnitProgress(unitId: unitId, lessons: []),
    );
    final lesson = unit.lessons.firstWhere(
      (l) => l.lessonId == lessonId,
      orElse: () => LessonProgress(lessonId: lessonId, sectionCount: 0),
    );
    return lesson.completed;
  }

  // Saber si una unidad está completa
  bool isUnitCompleted(int unitId) {
    // Buscamos la unidad de forma segura
    final units = state.where((u) => u.unitId == unitId);
    if (units.isEmpty) return false;

    final unit = units.first;
    return unit.lessons.isNotEmpty && unit.lessons.every((l) => l.completed);
  }
}
