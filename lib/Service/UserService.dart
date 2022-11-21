import 'dart:developer';

import 'package:assessmentportal/DataModel/UserModel.dart';
import 'package:assessmentportal/NewtworkUtil/API.dart';

class UserService {
  final API api = API();
  Future<Map<String, dynamic>> saveUser(
      String firstName,
      String lastName,
      String email,
      String password,
      String phone,
      String username,
      String userRole) async {
    final User user =
        User(username, firstName, lastName, password, email, phone);
    if (userRole == 'STUDENT') {
      Map<String, dynamic> result = await api.registerNormalUser(user: user);
      return result;
    } else {
      Map<String, dynamic> result = await api.registerAdminUser(user: user);
      return result;
    }
  }

  Future<Map<String, dynamic>> loadUserByUsername(
      {required String email, required String token}) async {
    log("Loading user for email: $email");
    Map<String, dynamic> userDetails =
        await api.loadUserByEmail(username: email, token: token);
    return userDetails;
  }

  Future<Map<String, dynamic>> updateUser(
      // String userId,
      // String firstName,
      // String lastName,
      // String email,
      // String password,
      // String phone,
      // String username,
      // String profile,
      // List<dynamic> userRole
      User user,
      String token) async {
    Map<String, dynamic> userDetails =
        await api.updateUser(user: user, token: token);
    return userDetails;
  }
}
