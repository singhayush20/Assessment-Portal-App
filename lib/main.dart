import 'dart:developer';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/Navigation/BottomNavigation.dart';
import 'package:assessmentportal/Navigation/BottomNavigationProvider.dart';
import 'package:assessmentportal/Register%20and%20Login/LoginPage.dart';
import 'package:assessmentportal/provider/QuestionProvider.dart';
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
        ChangeNotifierProvider(
          create: (context) => QuestionProvider.initialize(),
        ),
      ],
      child: Sizer(
        builder: ((context, orientation, deviceType) {
          return MaterialApp(
            theme: ThemeData(
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color(Colors.red[600]!.value),
                  ),
                ),
              ),
              //====APP BAR Theme
              appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                ),
                elevation: 0,
                shadowColor: Colors.white,
                color: Colors.white,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                  systemStatusBarContrastEnforced: true,
                ),
              ),
              //==Scaffold==
              scaffoldBackgroundColor: Colors.white,
              //====BOTTOM NAVIGATION Theme
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.red,
                unselectedItemColor: Colors.black,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: (isLoggedIn) ? BottomNavigation() : LoginPage(),
            // home: RegisterDetails(
            //   email: "ayush20apr@gmail.com",
            // ),
          );
        }),
      ),
    );
  }
}
