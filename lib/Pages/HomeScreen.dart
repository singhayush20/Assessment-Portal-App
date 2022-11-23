import 'dart:developer';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/DataModel/CategoryModel.dart';
import 'package:assessmentportal/Pages/AddCategory.dart';
import 'package:assessmentportal/Pages/CategoryTile.dart';
import 'package:assessmentportal/Service/CateogoryService.dart';
import 'package:assessmentportal/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserProvider userProvider;
  late CategoryService _categoryService;
  late SharedPreferences _sharedPreferences;
  late bool _areCategoriesLoaded;
  List<CategoryModel> categories = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    setState(() {
      _areCategoriesLoaded = false;
    });
    _sharedPreferences = await SharedPreferences.getInstance();
    _categoryService = CategoryService();
    await _loadCategories();
  }

  Future<void> _loadCategories() async {
    if (_areCategoriesLoaded == true) {
      //this is when user refreshes manually
      setState(() {
        _areCategoriesLoaded = false;
      });
    }
    categories = await _categoryService
        .getAllCategories(_sharedPreferences.getString(BEARER_TOKEN) ?? 'null');
    setState(() {
      log('Setting categories loaded to true');
      _areCategoriesLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      floatingActionButton:
          (userProvider.loadingStatus == LoadingStatus.COMPLETED &&
                  userProvider.accountType != null &&
                  userProvider.accountType == AccountType.ADMIN)
              ? FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCategory(),
                      ),
                    );
                  },
                  child: Icon(
                    FontAwesomeIcons.plus,
                  ),
                )
              : null,
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, screenSize) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.maxWidth * 0.05,
              ),
              child: (userProvider.loadingStatus == LoadingStatus.COMPLETED)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          height: screenSize.maxHeight * 0.1,
                          child: FittedBox(
                            child:
                                (userProvider.accountType == AccountType.NORMAL)
                                    ? Text(
                                        'Hello ${userProvider.user!.userName}, \nWhat would you like to learn today?',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : Text(
                                        'Hello ${userProvider.user!.userName}, \nFollowing categories are available with us:',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: screenSize.maxHeight * 0.1,
                          child: Text(
                            'Choose a category below and boost your skills',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        (_areCategoriesLoaded == true)
                            ? Container(
                                height: screenSize.maxHeight * 0.8,
                                color: Colors.white,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return RefreshIndicator(
                                      onRefresh: _loadCategories,
                                      child: GridView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount: categories.length,
                                        itemBuilder: (context, index) =>
                                            CategoryTile(
                                                index: index,
                                                category: categories[index]),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              constraints.maxWidth > 700
                                                  ? 4
                                                  : 2,
                                          // childAspectRatio: 5,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Container(
                                  color: Colors.white,
                                  height: screenSize.maxHeight * 0.8,
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    child: LoadingIndicator(
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
                              ),
                      ],
                    )
                  : ((userProvider.loadingStatus == LoadingStatus.LOADING)
                      ? Center(
                          child: Container(
                            color: Colors.white,
                            height: 100,
                            width: 100,
                            child: LoadingIndicator(
                                indicatorType: Indicator.ballPulse,
                                colors: [Colors.red, Colors.blue, Colors.green],

                                /// Optional, The color collections
                                strokeWidth: 1,

                                /// Optional, The stroke of the line, only applicable to widget which contains line
                                backgroundColor: Colors.white,

                                /// Optional, Background of the widget
                                pathBackgroundColor: Colors.white

                                /// Optional, the stroke backgroundColor

                                ),
                          ),
                        )
                      : const Text(
                          'No data',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
            ),
          );
        },
      ),
    );
  }
}
