import 'package:satoshimex/features/roadmap/presentation/providers/states/roadmap_states.dart';

class UnitProgress {
  final int unitId;
  final List<LessonProgress> lessons;

  UnitProgress({required this.unitId, required this.lessons});

  UnitProgress copyWith({List<LessonProgress>? lessons}) {
    return UnitProgress(unitId: unitId, lessons: lessons ?? this.lessons);
  }

  Map<String, dynamic> toJson() => {
    'unitId': unitId,
    'lessons': lessons.map((l) => l.toJson()).toList(),
  };

  factory UnitProgress.fromJson(Map<String, dynamic> json) => UnitProgress(
    unitId: json['unitId'] as int,
    lessons: (json['lessons'] as List)
        .map((l) => LessonProgress.fromJson(l))
        .toList(),
  );
}
