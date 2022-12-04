import 'dart:developer';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/DataModel/CategoryModel.dart';
import 'package:assessmentportal/DataModel/QuizModel.dart';
import 'package:assessmentportal/NewtworkUtil/API.dart';

class CategoryService {
  API _api = API();
  Future<List<CategoryModel>> getAllCategories(
      String token, int userid, String role) async {
    List<CategoryModel> categories = [];
    Map<String, dynamic> result;
    if (role == ROLE_NORMAL) {
      result =
          await _api.getAllEnrolledCategories(token: token, userid: userid);
    } else {
      result = await _api.getAllCategories(token: token, userid: userid);
    }
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

  //for normal
  Future<List<QuizModel>> getAllQuizzesByCategory(
      String token, int categoryId) async {
    List<QuizModel> quizzes = [];
    Map<String, dynamic> result = await _api.getAllQuizzesforCategoryandActive(
        token: token, categoryId: categoryId);
    log('CategoryService: getAllQuizzes by category and active result: $result');
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
              element['time'],
            ),
          );
        },
      );
    }
    return quizzes;
  }

  //for admin
  Future<List<QuizModel>> getAllQuizzesByAdminAndCategory(
      {required int adminid,
      required int categoryid,
      required String token}) async {
    log("CategoryService: loading quizzes by admin $adminid and category: $categoryid");
    Map<String, dynamic> result = await _api.getAllQuizzesByAdminAndCategory(
        adminid: adminid, categoryid: categoryid, token: token);
    log('CategoryService: getAllQuizzes by category result: $result');
    String code = result['code'];
    List<QuizModel> quizzes = [];
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
              element['time'],
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

  Future<String> deleteCategory(
      {required String token, required int categoryId}) async {
    Map<String, dynamic> result =
        await _api.deleteCategory(categoryId: categoryId, token: token);
    return result['code'];
  }

  Future<String> updateQuiz(
      {required String token,
      required String title,
      required String description,
      required int categoryId}) async {
    CategoryModel categoryModel = CategoryModel(categoryId, title, description);
    Map<String, dynamic> result =
        await _api.updateCategory(category: categoryModel, token: token);
    return result['code'];
  }
}
