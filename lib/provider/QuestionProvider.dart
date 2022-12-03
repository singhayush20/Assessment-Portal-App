import 'dart:developer';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/DataModel/QuestionModel.dart';
import 'package:assessmentportal/Service/QuestionService.dart';
import 'package:flutter/material.dart';

class QuestionProvider with ChangeNotifier {
  late QuestionLoadingStatus areQuestionsLoaded;
  late List<QuestionModel> questions;
  late QuestionService _questionService;
  QuestionProvider.initialize() {
    areQuestionsLoaded = QuestionLoadingStatus.NOT_STARTED;
    _questionService = QuestionService();
    questions = [];
  }

  Future<void> loadQuestions(
      {required String quizId, required String token}) async {
    log('QuestionProvider: loading questions for quizId: $quizId');
    areQuestionsLoaded = QuestionLoadingStatus.LOADING;
    questions = [];
    questions =
        await _questionService.loadQuestions(quizId: quizId, token: token);
    log('QuestionProvider: questions loaded successfully for quizId: $quizId');
    areQuestionsLoaded = QuestionLoadingStatus.COMPLETED;
    notifyListeners();
    // return _questions;
  }

  void addQuestion() async {}
  void deleteQuestion({required int questionId, required String token}) async {}
  void updateQuestion() async {}
}
