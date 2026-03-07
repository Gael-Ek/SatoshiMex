class LessonProgress {
  final int lessonId;
  final bool completed;
  final List<bool> sections; // true = sección completada

  LessonProgress({
    required this.lessonId,
    required int sectionCount,
    this.completed = false,
  }) : sections = List.filled(sectionCount, false);

  LessonProgress copyWith({bool? completed, List<bool>? sections}) {
    return LessonProgress._internal(
      lessonId: lessonId,
      completed: completed ?? this.completed,
      sections: sections ?? List.from(this.sections),
    );
  }

  // Constructor interno para usar cuando ya tienes la lista de secciones
  LessonProgress._internal({
    required this.lessonId,
    required this.completed,
    required this.sections,
  });

  Map<String, dynamic> toJson() => {
    'lessonId': lessonId,
    'completed': completed,
    'sections': sections,
  };

  factory LessonProgress.fromJson(Map<String, dynamic> json) =>
      LessonProgress._internal(
        lessonId: json['lessonId'] as int,
        completed: json['completed'] as bool,
        sections: List<bool>.from(json['sections']),
      );
}
