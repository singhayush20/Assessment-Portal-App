import 'dart:developer';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/Navigation/BottomNavigationProvider.dart';
import 'package:assessmentportal/Pages/Profile/ProfilePage.dart';
import 'package:assessmentportal/Pages/QuizResults/QuizResult.dart';
import 'package:assessmentportal/Register%20and%20Login/LoginPage.dart';
import 'package:assessmentportal/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../Pages/Category/HomeScreen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late BottomNavigationProvider bottomNavigationProvider;
  late UserProvider userProvider;

  @override
  void initState() {}

  AppBar appBar = AppBar(
    title: Text(
      'Quizzo',
    ),
  );
  static const List<Widget> _widgetOptionsNormal = <Widget>[
    HomeScreen(),
    QuizResultPage(),
    ProfilePage(),
  ];
  static const List<Widget> _widgetOptionsAdmin = <Widget>[
    HomeScreen(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    log('building BottomNavigation');
    bottomNavigationProvider = Provider.of<BottomNavigationProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    //if data loading hasn't been started, then load the data
    //this is to ensure that data is loaded only once
    log('Login Status of provider: ${userProvider.loadingStatus}');
    if (userProvider.loadingStatus == LoadingStatus.NOT_STARTED) {
      // log('Bottom Navigation: loading user for email: ${userProvider.sharedPreferences!.getString(EMAIL)} ');
      log("Bottom Navigation: saving user details for current user");
      userProvider.saveUserDetails(
          email: userProvider.sharedPreferences!.getString(EMAIL) ?? "null",
          token: userProvider.sharedPreferences!.getString(BEARER_TOKEN) ??
              "NULL");
    }

    final height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return Scaffold(
      drawer: NavigationDrawer(userProvider),
      appBar: appBar,
      bottomNavigationBar:
          (!(userProvider.loadingStatus == LoadingStatus.NOT_STARTED ||
                  userProvider.loadingStatus == LoadingStatus.LOADING))
              ? BottomNavigationBar(
                  items: (userProvider.accountType == AccountType.NORMAL)
                      ? <BottomNavigationBarItem>[
                          const BottomNavigationBarItem(
                            icon: Icon(Icons.home),
                            label: 'Home',
                          ),
                          const BottomNavigationBarItem(
                            icon: Icon(Icons.list),
                            label: 'MyQuizzes',
                          ),
                          const BottomNavigationBarItem(
                            icon: Icon(FontAwesomeIcons.user),
                            label: 'Profile',
                          ),
                        ]
                      : <BottomNavigationBarItem>[
                          const BottomNavigationBarItem(
                            icon: Icon(Icons.home),
                            label: 'Home',
                          ),
                          const BottomNavigationBarItem(
                            icon: Icon(FontAwesomeIcons.user),
                            label: 'Profile',
                          )
                        ],
                  currentIndex: bottomNavigationProvider.selectedIndex,
                  onTap: /*_onTap*/ bottomNavigationProvider
                      .onItemTapped //_onItemTapped,
                  )
              : null,
      body: // _widgetOptions.elementAt(_selectedIndex),
          (userProvider.loadingStatus == LoadingStatus.NOT_STARTED ||
                  userProvider.loadingStatus == LoadingStatus.LOADING)
              ? Center(
                  child: Container(
                    color: Colors.white,
                    height: height * 0.8,
                    alignment: Alignment.center,
                    child: Container(
                      height: 80,
                      width: 80,
                      child: const LoadingIndicator(
                          indicatorType: Indicator.lineScale,
                          colors: [
                            Colors.purple,
                            Colors.indigo,
                            Colors.blue,
                            Colors.green,
                            Colors.red,
                          ],

                          /// Optional, The color collections
                          strokeWidth: 1,

                          /// Optional, The stroke of the line, only applicable to widget which contains line
                          backgroundColor: Colors.white,

                          /// Optional, Background of the widget
                          pathBackgroundColor: Colors.white

                          /// Optional, the stroke backgroundColor

                          ),
                    ),
                  ),
                )
              : Container(
                  height: height,
                  child: (userProvider.accountType == AccountType.NORMAL)
                      ? _widgetOptionsNormal
                          .elementAt(bottomNavigationProvider.selectedIndex)
                      : _widgetOptionsAdmin
                          .elementAt(bottomNavigationProvider.selectedIndex)),
    );
  }
}

class NavigationDrawer extends StatefulWidget {
  UserProvider provider;

  NavigationDrawer(this.provider);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  late SharedPreferences _sharedPreferences;
  initializePrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initializePrefs();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Quizzo',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(
                FontAwesomeIcons.rightFromBracket,
              ),
              onTap: () {
                _sharedPreferences.clear();
                //set it to not started, so that if the user logs out and re-login using
                //some other id without closing the app, again the same flow can be followed
                widget.provider.loadingStatus = LoadingStatus.NOT_STARTED;
                Navigator.popUntil(context, (route) => false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
