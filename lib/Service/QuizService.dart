import 'package:assessmentportal/DataModel/QuizModel.dart';
import 'package:assessmentportal/NewtworkUtil/API.dart';

class QuizService {
  API _api = new API();
  Future<String> addNewQuiz(
      {required String title,
      required String description,
      required int noOfQues,
      required int maxMarks,
      required bool isActive,
      required int categoryId,
      required int userId,
      required String token}) async {
    QuizModel quiz = QuizModel(title, description, maxMarks.toString(),
        isActive, categoryId, noOfQues);

    Map<String, dynamic> result =
        await _api.addNewQuiz(quiz: quiz, token: token, userid: userId);
    return result['code'];
  }

  Future<String> deleteQuiz(
      {required int quizid, required String token}) async {
    Map<String, dynamic> result =
        await _api.deleteQuiz(quizid: quizid, token: token);
    return result['code'];
  }

  Future<String> updateQuiz(
      {required int quizid,
      required String title,
      required String description,
      required String maxMarks,
      required String numberOfQuestions,
      required bool active,
      required int categoryId,
      required int userid,
      required String token}) async {
    QuizModel quiz = QuizModel.saveQuiz(quizid, title, description, maxMarks,
        active, categoryId, int.parse(numberOfQuestions));
    Map<String, dynamic> result =
        await _api.updateQuiz(quiz: quiz, token: token, userid: userid);
    return result['code'];
  }
}
