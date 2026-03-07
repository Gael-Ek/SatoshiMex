import 'package:satoshimex/shared/models/roadmap/lesson.dart';
import 'package:satoshimex/shared/models/roadmap/unit.dart';

class LessonNode {
  final LessonModel? lesson;
  final UnitModel? unit;
  final bool isCompleted;
  final bool isLocked;
  final bool isHeader;

  const LessonNode._({
    this.lesson,
    this.unit,
    this.isCompleted = false,
    this.isLocked = false,
    this.isHeader = false,
  });

  factory LessonNode.unitHeader(UnitModel unit) =>
      LessonNode._(unit: unit, isHeader: true);

  factory LessonNode.lesson({
    required LessonModel lesson,
    required UnitModel unit,
    required bool isCompleted,
    required bool isLocked,
  }) => LessonNode._(
    lesson: lesson,
    unit: unit,
    isCompleted: isCompleted,
    isLocked: isLocked,
  );
}
