import 'dart:developer';

import 'package:assessmentportal/DataModel/QuestionModel.dart';
import 'package:assessmentportal/NewtworkUtil/API.dart';

class QuestionService {
  final API _api = API();
  Future<List<QuestionModel>> loadQuestions(
      {required String quizId, required String token}) async {
    List<QuestionModel> questions = [];
    log('loading questions\n\n');
    Map<String, dynamic> result =
        await _api.loadQuestions(quizId: quizId, token: token);
    log('result: $result');
    if (result['code'] == '2000') {
      log('code is 2000, data= ${result['data']}');
      List<dynamic> data = result['data'];
      log('data: $data');
      data.forEach((element) {
        log('for element: $element');
        questions.add(QuestionModel(
            questionId: element['questionId'],
            content: element['content'],
            option1: element['option1'],
            option2: element['option2'],
            correctAnswer: element['answer'],
            option3:
                (element.containsKey('option3')) ? element['option3'] : null,
            option4:
                (element.containsKey('option4')) ? element['option4'] : null,
            quiz: element['quiz'],
            image: element['image']));
      });
    }
    log('questions: $questions');
    return questions;
  }

  Future<String> addQuestion(
      {required String content,
      required String option1,
      required String option2,
      String? option3,
      String? option4,
      required String answer,
      required int quizId,
      required String token}) async {
    QuestionModel questionModel = QuestionModel(
        content: content,
        option1: option1,
        option2: option2,
        option3: option3,
        option4: option4,
        correctAnswer: answer,
        quiz: {"quizId": "$quizId"},
        image: "example.jpeg");

    Map<String, dynamic> result = await _api.addQuestionToQuiz(
        questionModel: questionModel, token: token);
    return result['code'];
  }

  Future<String> updateQuestion(
      {required int questionId,
      required String content,
      String? image,
      required String option1,
      required String option2,
      String? option3,
      String? option4,
      required String answer,
      required String token,
      required String quizId}) async {
    QuestionModel questionModel = QuestionModel(
      content: content,
      option1: option1,
      option2: option2,
      correctAnswer: answer,
      option3: option3,
      option4: option4,
      image: image,
      questionId: questionId,
      quiz: {
        "quiz": {"quizId": quizId}
      },
    );
    Map<String, dynamic> result =
        await _api.updateQuestion(question: questionModel, token: token);
    return result['code'];
  }

  Future<String> deleteQuestion(
      {required String token, required int questionId}) async {
    Map<String, dynamic> result =
        await _api.deleteQuestion(questionId: questionId, token: token);
    return result['code'];
  }
}
