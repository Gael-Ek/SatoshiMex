import 'package:satoshimex/shared/models/models.dart';

class LessonModel {
  final int id;
  final String title;
  final List<SectionModel> sections;

  LessonModel({required this.id, required this.title, required this.sections});

  //pasar de json a modelo
  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'],
      title: json['title'],
      sections: List<SectionModel>.from(
        json['sections'].map((section) => SectionModel.fromJson(section)),
      ),
    );
  }
}
