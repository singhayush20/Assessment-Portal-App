import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightThemeData = ThemeData(
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
);
