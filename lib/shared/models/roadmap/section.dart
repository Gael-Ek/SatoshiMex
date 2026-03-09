import 'package:satoshimex/shared/models/models.dart';

enum SectionType { explanation, example, quiz }

class SectionModel {
  final SectionType type;
  final String? title;
  final String? subtitle;
  final String? content;
  final String? imageUrl;
  final List<QuestionsModel>? questions;

  SectionModel({
    required this.type,
    this.title,
    this.subtitle,
    this.content,
    this.imageUrl,
    this.questions,
  });

  //pasar de json a modelo
  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      type: SectionType.values.byName(json['type']),
      title: json['title'],
      subtitle: json['subtitle'],
      content: json['content'],
      imageUrl: json['image_url'],
      questions: json['questions'] != null
          ? List<QuestionsModel>.from(
              json['questions'].map(
                (question) => QuestionsModel.fromJson(question),
              ),
            )
          : null,
    );
  }
}
