import 'dart:developer';
import 'dart:io';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/DataModel/CategoryModel.dart';
import 'package:assessmentportal/DataModel/QuestionModel.dart';
import 'package:assessmentportal/DataModel/QuizModel.dart';
import 'package:assessmentportal/DataModel/UserModel.dart';
import 'package:dio/dio.dart';

class API {
  final sendEmailOTPUrl =
      "${domain}/assessmentportal/authenticate/verifyemail/sendotp";
  final verifyEmailOTPUrl =
      "${domain}/assessmentportal/authenticate/verifyemail/verify-otp";
  final registerNormalUserUrl =
      "${domain}/assessmentportal/authenticate/register/normal";
  final registerAdminUserUrl =
      "$domain/assessmentportal/authenticate/register/admin?key=adminKey";
  final forgetPasswordSendOTPUrl =
      "$domain/assessmentportal/authenticate/verifyemail/reset-password-otp";
  final verifyForgetPasswordSendOTPUrl =
      "$domain/assessmentportal/authenticate/verifyemail/reset-password";
  final loginUserUrl = "$domain/assessmentportal/authenticate/login";
  final loadUserByEmailUrl = "$domain/assessmentportal/users/";
  final updateUserUrl = "$domain/assessmentportal/users/update";
  final getAllCategoriesUrl = "$domain/assessmentportal/category/all";
  final getQuizzesForCategoryUrl =
      "$domain/assessmentportal/quiz/getByCategory";
  final getQuizzesForCategoryandActiveUrl =
      "$domain/assessmentportal/quiz/active";
  final addNewCategoryUrl = "$domain/assessmentportal/category/create";
  final loadQuizzesAdminUrl = "$domain/assessmentportal/quiz/getByAdmin/";
  final addNewQuizUrl = "$domain/assessmentportal/quiz/create";
  final deleteQuizUrl = "$domain/assessmentportal/quiz/delete";
  final updateQuizUrl = "$domain/assessmentportal/quiz/update";
  final deleteCategoryUrl = '$domain/assessmentportal/category/delete';
  final updateCategoryUrl = "$domain/assessmentportal/category/update";
  final enrollInCateogryUrl =
      "$domain/assessmentportal/users/enrolledcategories/all/add";
  final getAllEnrolledCategoriesUrl =
      '$domain/assessmentportal/users/enrolledcategories/all';
  final loadQuestionsUrl = '$domain/assessmentportal/question/quiz';
  final addQuestionUrl = '$domain/assessmentportal/question/create';
  final updateQuestionUrl = '$domain/assessmentportal/question/update';
  final deleteQuestionUrl = '$domain/assessmentportal/question/delete';
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> loginUser(
      {required String username, required String password}) async {
    Map<String, dynamic> data = {
      "username": "$username",
      "password": "$password"
    };
    log("Logging in user for: $data $loginUserUrl");
    Response response = await _dio.post(loginUserUrl, data: data);
    log("Logging in response: $response");
    return response.data;
  }

  Future<Map<String, dynamic>> sendEmailVerificationOTP(
      {required String? email}) async {
    Map<String, dynamic> data = {"email": email!};
    Response response = await _dio.post(sendEmailOTPUrl, queryParameters: data);
    log("send email verification otp: Response obtained: $response");
    return response.data;
  }

  Future<Map<String, dynamic>> verifyEmailVerificationOTP(
      {required String? email, required String? otp}) async {
    Map<String, dynamic> data = {"email": email, "otp": int.parse(otp!)};
    log("Sending verify email otp data: $data");
    Response response =
        await _dio.post(verifyEmailOTPUrl, queryParameters: data);
    log("verify email verification otp: Response obtained $response");
    return response.data;
  }

  Future<Map<String, dynamic>> registerNormalUser({required User user}) async {
    Map<String, dynamic> data = {
      "user_name": user.userName,
      "password": user.password,
      "firstName": user.firstName,
      "lastName": user.lastName,
      "email": user.email,
      "enabled": "true",
      "phone": user.phoneNumber,
      "profile": "sample.jpg"
    };
    Response response = await _dio.post(registerNormalUserUrl, data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> registerAdminUser({required User user}) async {
    Map<String, dynamic> data = {
      "user_name": user.userName,
      "password": user.password,
      "firstName": user.firstName,
      "lastName": user.lastName,
      "email": user.email,
      "enabled": "true",
      "phone": user.phoneNumber,
      "profile": "sample.jpg"
    };
    log('Registering  user with data: $data');
    Response response = await _dio.post(registerAdminUserUrl, data: data);
    log('Register admin user response obtained: $response');
    return response.data;
  }

  Future<Map<String, dynamic>> sendForgotPasswordVerificationOTP(
      {required String? email}) async {
    Map<String, dynamic> data = {"email": email!};
    log('Sending forget password otp for: $data');
    Response response =
        await _dio.post(forgetPasswordSendOTPUrl, queryParameters: data);
    log("send forgot password verification otp: Response obtained: $response");
    return response.data;
  }

  Future<Map<String, dynamic>> resetPasswordAndVerifyOTP({
    required String? email,
    required String? password,
    required int? otp,
  }) async {
    Map<String, dynamic> data = {
      "email": email!,
      "otp": otp!,
      "password": password!
    };
    Response response =
        await _dio.post(verifyForgetPasswordSendOTPUrl, queryParameters: data);
    log("send forgot password verification otp: Response obtained: $response");
    return response.data;
  }

  Future<Map<String, dynamic>> loadUserByEmail(
      {required String username, required String token}) async {
    username = username.trim();
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    // options.headers = {
    //   "Authorization": token,
    // };
    log("Loading user for username: $username header: ${options.headers}");
    Response response =
        await _dio.get(loadUserByEmailUrl + username, options: options);
    log("Response obtained for loadUserByUsername $response");
    return response.data;
  }

  Future<Map<String, dynamic>> updateUser(
      {required User user, required String token}) async {
    Map<String, dynamic> data = {
      "user_name": user.userName,
      "password": user.password,
      "firstName": user.firstName,
      "lastName": user.lastName,
      "email": user.email,
      "enabled": "true",
      "phone": user.phoneNumber,
      "profile": user.profile,
    };
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log("API: Updating user for $data");
    Response response = await _dio.put(updateUserUrl + "/${user.userId}",
        data: data, options: options);
    log("API: update user response: $response");
    return response.data;
  }

  Future<Map<String, dynamic>> getAllCategories(
      {required String token, required int userid}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Fetching all category details for $token $userid');
    Response response =
        await _dio.get(getAllCategoriesUrl + "/$userid", options: options);
    log("get all categories response: $response");
    return response.data;
  }

  Future<Map<String, dynamic>> getAllEnrolledCategories(
      {required String token, required int userid}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Fetching all category details for normal user $token $userid');
    Response response = await _dio.get(getAllEnrolledCategoriesUrl + "/$userid",
        options: options);
    log("get all categories response for normal user: $response");
    return response.data;
  }

  //for normal user-load all active/inactive quizzes in a category
  Future<Map<String, dynamic>> getAllQuizzesforCategory(
      {required String token, required int categoryId}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Fetching all quizzes for categoryId: $categoryId and token $token');
    Response response = await _dio
        .get(getQuizzesForCategoryUrl + "/$categoryId", options: options);
    log('Fetched quizzes: $response');
    return response.data;
  }

  //for normal user- load all active quizzes only
  Future<Map<String, dynamic>> getAllQuizzesforCategoryandActive(
      {required String token, required int categoryId}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Fetching all quizzes for categoryId: $categoryId and token $token');
    Response response = await _dio.get(getQuizzesForCategoryandActiveUrl,
        options: options, queryParameters: {"categoryId": categoryId});
    log('Fetched quizzes: $response');
    return response.data;
  }

  //for admin user
  Future<Map<String, dynamic>> addNewCategory(
      {required String title,
      required String descp,
      required String token,
      required String adminId}) async {
    Map<String, dynamic> data = {
      "title": title,
      "description": descp,
      "adminUser": {"userId": adminId}
    };
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Adding new category for details: $data and by admin $adminId');
    Response response = await _dio.post("$addNewCategoryUrl/$adminId",
        data: data, options: options);
    log('Add new category response: $response');
    return response.data;
  }

  //for admin user
  Future<Map<String, dynamic>> getAllQuizzesByAdminAndCategory(
      {required int adminid,
      required int categoryid,
      required String token}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    Map<String, dynamic> data = {
      "adminid": adminid,
      "categoryid": categoryid,
    };
    log("fetching quizzes for admin and by category: $data");
    Response response = await _dio.get(loadQuizzesAdminUrl,
        queryParameters: data, options: options);
    log("Response for quizzes of admin: $response");
    return response.data;
  }

  //admin
  Future<Map<String, dynamic>> deleteCategory(
      {required int categoryId, required String token}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});

    log('deleting category with id $categoryId');
    Response response =
        await _dio.delete(deleteCategoryUrl + "/$categoryId", options: options);
    log('Delete category response: $response');
    return response.data;
  }

  //admin
  Future<Map<String, dynamic>> updateCategory(
      {required CategoryModel category, required String token}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});

    Map<String, dynamic> data = {
      "categoryId": category.categoryId,
      "title": category.categoryTitle,
      "description": category.categoryDescp
    };
    Response response =
        await _dio.put(updateCategoryUrl, options: options, data: data);
    log('update category response: $response');
    return response.data;
  }

  //for admin
  Future<Map<String, dynamic>> addNewQuiz(
      {required QuizModel quiz,
      required String token,
      required int userid}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    Map<String, dynamic> data = {
      "title": quiz.title,
      "description": quiz.description,
      "maxMarks": quiz.maxMarks,
      "numberOfQuestions": quiz.numberOfQuestions.toString(),
      "active": quiz.active,
      "category": {"categoryId": quiz.categoryId},
    };
    Map<String, dynamic> queryParam = {"userid": userid};
    log('Creating quiz for: data: $data and user: $userid');
    Response response = await _dio.post(addNewQuizUrl,
        queryParameters: queryParam, data: data, options: options);
    log('New quiz response: $response');
    return response.data;
  }

  Future<Map<String, dynamic>> deleteQuiz(
      {required int quizid, required String token}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Deleting quiz with id: $quizid');
    Response response =
        await _dio.delete(deleteQuizUrl + "/$quizid", options: options);
    log('Delete quiz response $response');
    return response.data;
  }

  Future<Map<String, dynamic>> updateQuiz(
      {required QuizModel quiz,
      required String token,
      required int userid}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    Map<String, dynamic> data = {
      "quizId": quiz.quizId,
      "title": quiz.title,
      "description": quiz.description,
      "maxMarks": quiz.maxMarks,
      "numberOfQuestions": quiz.numberOfQuestions.toString(),
      "active": quiz.active
    };
    log('Updating quiz to ${data}');

    Response response =
        await _dio.put(updateQuizUrl, data: data, options: options);
    log('Updated quiz response: $response');
    return response.data;
  }

  Future<Map<String, dynamic>> enrollUserInCategory(
      {required int userid,
      required int categoryid,
      required String token}) async {
    Map<String, dynamic> data = {
      'userid': userid,
      'categoryid': categoryid,
    };
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('enroll user with details: $data');
    Response response = await _dio.put(enrollInCateogryUrl,
        queryParameters: data, options: options);
    log('enroll user response: $response');
    return response.data;
  }

  Future<Map<String, dynamic>> loadQuestions(
      {required String quizId, required String token}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});

    log('fetching questions for quiz: $quizId');
    Response response =
        await _dio.get(loadQuestionsUrl + "/$quizId", options: options);
    log('question fetch response $response');
    return response.data;
  }

  Future<Map<String, dynamic>> addQuestionToQuiz(
      {required QuestionModel questionModel, required String token}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    Map<String, dynamic> data = {
      "content": questionModel.content,
      "image": questionModel.image ?? 'example.jpeg',
      "option1": questionModel.option1,
      "option2": questionModel.option2,
      "option3": questionModel.option3,
      "option4": questionModel.option4,
      "answer": questionModel.correctAnswer,
      "quiz": questionModel.quiz,
    };
    log('Adding question: $data');
    Response response = await _dio.post(
      addQuestionUrl,
      data: data,
      options: options,
    );
    log('question fetch response $response');
    return response.data;
  }

  Future<Map<String, dynamic>> updateQuestion(
      {required String token, required QuestionModel question}) async {
    Map<String, dynamic> data = {
      "questionId": question.questionId,
      "content": question.content,
      "image": question.image,
      "option1": question.option1,
      "option2": question.option2,
      "option3": question.option3,
      "option4": question.option4,
      "answer": question.correctAnswer,
      "quiz": {"quizId": question.quiz!['quiz']['quizId']}
    };
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('updating question: $data');
    Response response =
        await _dio.put(updateQuestionUrl, options: options, data: data);
    log('update question response: $response');

    return response.data;
  }

  Future<Map<String, dynamic>> deleteQuestion(
      {required int questionId, required String token}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Deleting question with id: $questionId');
    Response response =
        await _dio.delete(deleteQuestionUrl + "/$questionId", options: options);
    log('Delete question response $response');
    return response.data;
  }
}
