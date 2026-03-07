import 'package:satoshimex/shared/models/models.dart';

class UnitModel {
  final int id;
  final String title;
  final String? image;
  final List<LessonModel> lessons;

  UnitModel({
    required this.id,
    required this.title,
    required this.lessons,
    this.image,
  });

  //pasar de json a modelo
  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'],
      title: json['title'],
      image: json['image_unit_url'],
      lessons: List<LessonModel>.from(
        json['lessons'].map((lesson) => LessonModel.fromJson(lesson)),
      ),
    );
  }
}
