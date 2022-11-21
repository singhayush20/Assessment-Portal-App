import 'package:flutter/material.dart';

class BottomNavigationProvider with ChangeNotifier {
  int selectedIndex = 0;
  void onItemTapped(int index) async {
    print('Selected Index=$index');

    selectedIndex = index;
    notifyListeners();
  }
}
