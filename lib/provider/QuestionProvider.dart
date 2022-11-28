import 'dart:developer';

import 'package:assessmentportal/DataModel/QuestionModel.dart';
import 'package:assessmentportal/Service/QuestionService.dart';
import 'package:flutter/material.dart';

class QuestionProvider with ChangeNotifier {
  // late QuestionLoadingStatus areQuestionsLoaded;
  late List<QuestionModel> _questions;
  late QuestionService _questionService;
  QuestionProvider.initialize() {
    // areQuestionsLoaded = QuestionLoadingStatus.NOT_STARTED;
    _questionService = QuestionService();
    _questions = [];
  }

  Future<List<QuestionModel>> loadQuestions(
      {required int quizId, required String token}) async {
    log('QuestionProvider: loading questions for quizId: $quizId');
    // areQuestionsLoaded = QuestionLoadingStatus.LOADING;
    _questions = [];
    _questions =
        await _questionService.loadQuestions(quizId: quizId, token: token);
    log('QuestionProvider: questions loaded successfully for quizId: $quizId');
    return _questions;
  }

  void addQuestion() async {}
  void deleteQuestion({required int questionId, required String token}) async {}
  void updateQuestion() async {}
}
