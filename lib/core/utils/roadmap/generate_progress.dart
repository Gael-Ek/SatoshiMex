import '../../../features/roadmap/presentation/providers/states/roadmap_states.dart';
import '../../../shared/models/models.dart';

List<UnitProgress> generateProgressFromRoadmap(RoadmapModel roadmap) {
  return roadmap.units.map((unit) {
    return UnitProgress(
      unitId: unit.id,
      lessons: unit.lessons.map((lesson) {
        return LessonProgress(
          lessonId: lesson.id,
          sectionCount: lesson.sections.length,
        );
      }).toList(),
    );
  }).toList();
}
