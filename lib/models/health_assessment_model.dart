class AssessmentQuestionModel {
  final int id;
  final String question;
  final List<String> options;

  AssessmentQuestionModel({
    required this.id,
    required this.question,
    required this.options,
  });

  factory AssessmentQuestionModel.fromJson(Map<String, dynamic> json) {
    return AssessmentQuestionModel(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
    };
  }
}
