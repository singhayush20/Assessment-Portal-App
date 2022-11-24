import 'dart:developer';
import 'dart:io';

import 'package:assessmentportal/AppConstants/constants.dart';
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
  final getAllCategoriesUrl = "$domain/assessmentportal/category/";
  final getQuizzesForCategoryUrl =
      "$domain/assessmentportal/quiz/getByCategory";
  final addNewCategoryUrl = "$domain/assessmentportal/category/create";
  final loadQuizzesAdminUrl = "$domain/assessmentportal/quiz/getByAdmin/";
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

  Future<Map<String, dynamic>> getAllCategories({required String token}) async {
    Options options = Options(
        validateStatus: (_) => true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {HttpHeaders.authorizationHeader: token});
    log('Fetching all category details for $token');
    Response response = await _dio.get(getAllCategoriesUrl, options: options);
    log("get all categories response: $response");
    return response.data;
  }

  //for normal user
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

  //for admin user
  Future<Map<String, dynamic>> addNewCategory(
      {required String title,
      required String descp,
      required String token,
      required String adminId}) async {
    Map<String, dynamic> data = {
      "title": title,
      "description": descp,
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
}
