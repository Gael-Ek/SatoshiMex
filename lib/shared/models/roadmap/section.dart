import 'package:satoshimex/shared/models/models.dart';

enum SectionType { explanation, example, quiz }

class SectionModel {
  final SectionType type;
  final String? content;
  final List<QuestionsModel>? questions;

  SectionModel({required this.type, this.content, this.questions});

  //pasar de json a modelo
  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      type: SectionType.values.byName(json['type']),
      content: json['content'],
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
