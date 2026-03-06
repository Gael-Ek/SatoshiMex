class QuestionsModel {
  final String question;
  final List<String>? options;
  final String answer;

  QuestionsModel({required this.question, required this.answer, this.options});

  //pasar de json a modelo
  factory QuestionsModel.fromJson(Map<String, dynamic> json) {
    return QuestionsModel(
      question: json['q'],
      answer: json['answer'],
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
    );
  }
}
