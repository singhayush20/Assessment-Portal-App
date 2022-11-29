class QuestionModel {
  //  "questionId": 142,
  //           "content": "What is OOPS",
  //           "image": "example2.jpeg",
  //           "option1": "choice1",
  //           "option2": "choice2",
  //           "option3": "choice3",
  //           "option4": "choice4",
  //           "answer": "choice1",
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
