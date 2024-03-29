import 'dart:developer';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/DataModel/CategoryModel.dart';
import 'package:assessmentportal/Pages/Category/AddCategory.dart';
import 'package:assessmentportal/Pages/Category/CategoryTile.dart';
import 'package:assessmentportal/Pages/Category/EnrollCategorypage.dart';
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

    categories = await _categoryService.getAllCategories(
        _sharedPreferences.getString(BEARER_TOKEN) ?? 'null',
        _sharedPreferences.getInt(USER_ID) ?? 0,
        _sharedPreferences.getString(ROLE) ?? 'NULL');
    //check if thw widget is mounted to ensure that no state is changed if
    //the widget is not in widget tree- when tabs are switched very quickly
    if (mounted) {
      setState(() {
        log('Setting categories loaded to true');
        _areCategoriesLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      floatingActionButton:
          // (userProvider.loadingStatus == LoadingStatus.COMPLETED &&
          //         userProvider.accountType != null &&
          //         userProvider.accountType == AccountType.ADMIN)
          (userProvider.loadingStatus == LoadingStatus.COMPLETED)
              ? FloatingActionButton(
                  // backgroundColor: Colors.red,
                  onPressed: () {
                    if (userProvider.accountType != null &&
                        userProvider.accountType == AccountType.ADMIN) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCategory(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnrollCategorypage(
                              userid: userProvider.user!.userId,
                              token: userProvider.sharedPreferences!
                                      .getString(BEARER_TOKEN) ??
                                  'null'),
                        ),
                      );
                    }
                  },
                  child: Icon(
                    FontAwesomeIcons.plus,
                  ),
                )
              : null,
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadCategories,
        child: LayoutBuilder(
          builder: (context, screenSize) {
            return (userProvider.loadingStatus == LoadingStatus.COMPLETED)
                ? SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: screenSize.maxWidth * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            height: screenSize.maxHeight * 0.1,
                            child: FittedBox(
                              child: (userProvider.accountType ==
                                      AccountType.NORMAL)
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
                            child:
                                (userProvider.accountType == AccountType.NORMAL)
                                    ? const Text(
                                        'Choose a category below and boost your skills',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    : const Text(
                                        'Choose an available category or create a new one',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                          ),
                          (_areCategoriesLoaded == true)
                              ? (categories.length > 0)
                                  ? GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: categories.length,
                                      itemBuilder: (context, index) =>
                                          CategoryTile(
                                        role: _sharedPreferences
                                                .getString(ROLE) ??
                                            'null',
                                        index: index,
                                        category: categories[index],
                                        token: _sharedPreferences
                                                .getString(BEARER_TOKEN) ??
                                            'null',
                                      ),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            screenSize.maxWidth > 700 ? 4 : 2,
                                        // childAspectRatio: 5,
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        'No categories found',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )
                              : Center(
                                  child: Container(
                                    height: screenSize.maxHeight * 0.8,
                                    alignment: Alignment.center,
                                    child: DataLoadingIndicator(),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  )
                : ((userProvider.loadingStatus == LoadingStatus.LOADING)
                    ? Center(
                        child: DataLoadingIndicator(),
                      )
                    : const Text(
                        'No data',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ));
          },
        ),
      ),
    );
  }
}
