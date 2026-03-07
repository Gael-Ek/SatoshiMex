class QuestionsModel {
  final String question;
  final List<String>? options;
  final String answer;
  final String? feedback;

  QuestionsModel({
    required this.question,
    required this.answer,
    this.feedback,
    this.options,
  });

  //pasar de json a modelo
  factory QuestionsModel.fromJson(Map<String, dynamic> json) {
    return QuestionsModel(
      question: json['q'],
      answer: json['answer'],
      feedback: json['feedback'],
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
    );
  }
}
