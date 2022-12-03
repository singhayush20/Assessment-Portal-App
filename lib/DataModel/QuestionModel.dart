class QuestionModel {
  int? questionId;
  Map<String, dynamic>? quiz;
  String content;
  String option1;
  String option2;
  String? option3;
  String? option4;
  String correctAnswer;
  String? image;

  QuestionModel(
      {this.questionId,
      required this.content,
      required this.option1,
      required this.option2,
      this.option3,
      this.option4,
      required this.correctAnswer,
      this.image,
      required this.quiz});
}
