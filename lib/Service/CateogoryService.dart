import 'dart:developer';

import 'package:assessmentportal/DataModel/CategoryModel.dart';
import 'package:assessmentportal/DataModel/QuizModel.dart';
import 'package:assessmentportal/NewtworkUtil/API.dart';

class CategoryService {
  API _api = API();
  Future<List<CategoryModel>> getAllCategories(String token) async {
    List<CategoryModel> categories = [];
    Map<String, dynamic> result = await _api.getAllCategories(token: token);
    log('CategoryService: getAllCategories result: $result');
    String code = result['code'];
    if (code == '2000') {
      List<dynamic> categoryList = result['data'];
      categoryList.forEach(
        (element) {
          categories.add(
            CategoryModel(
              element['categoryId'],
              element['title'],
              element['description'],
            ),
          );
        },
      );
    }
    return categories;
  }

  Future<List<QuizModel>> getAllQuizzesByCategory(
      String token, int categoryId) async {
    List<QuizModel> quizzes = [];
    Map<String, dynamic> result = await _api.getAllQuizzesforCategory(
        token: token, categoryId: categoryId);
    log('CategoryService: getAllQuizzes by category result: $result');
    String code = result['code'];
    if (code == '2000') {
      List<dynamic> categoryList = result['data'];
      categoryList.forEach(
        (element) {
          quizzes.add(
            QuizModel.saveQuiz(
              element['quizId'],
              element['title'],
              element['description'],
              element['maxMarks'],
              element['active'],
              element['category']['categoryId'],
              int.parse(element['numberOfQuestions']),
            ),
          );
        },
      );
    }
    return quizzes;
  }

  Future<String> addNewCategory(
      {required String title,
      required String descp,
      required String token,
      required String adminId}) async {
    Map<String, dynamic> result = await _api.addNewCategory(
        title: title, descp: descp, token: token, adminId: adminId);
    return result['code'];
  }
}
