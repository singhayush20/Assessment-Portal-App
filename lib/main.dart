import 'dart:developer';

import 'package:assessmentportal/AppConstants/Themes.dart';
import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/Navigation/BottomNavigation.dart';
import 'package:assessmentportal/Navigation/BottomNavigationProvider.dart';

import 'package:assessmentportal/Register%20and%20Login/LoginPage.dart';
import 'package:assessmentportal/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

late SharedPreferences _sharedPreferences;
bool isLoggedIn = false;
Future<void> initializePrefs() async {
  log("Loading Shared Preferences");
  _sharedPreferences = await SharedPreferences.getInstance();
  log('Shared Preferences loaded');
  isLoggedIn = _sharedPreferences.getBool(IS_LOGGED_IN) ?? false;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await initializePrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    log('is Logged In: $isLoggedIn');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider.initialze(_sharedPreferences),
        ),
      ],
      child: Sizer(
        builder: ((context, orientation, deviceType) {
          return MaterialApp(
            theme: lightThemeData,
            debugShowCheckedModeBanner: false,
            home: (isLoggedIn) ? BottomNavigation() : LoginPage(),
          );
        }),
      ),
    );
  }
}
