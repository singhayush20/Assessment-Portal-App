import 'dart:developer';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/DataModel/CategoryModel.dart';
import 'package:assessmentportal/DataModel/QuizModel.dart';
import 'package:assessmentportal/Service/CateogoryService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizListPage extends StatefulWidget {
  CategoryModel category;

  QuizListPage({required this.category});

  @override
  State<QuizListPage> createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  late SharedPreferences _sharedPreferences;
  List<QuizModel> quizzes = [];
  late CategoryService _categoryService;
  bool _areQuizzesLoaded = false;
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    setState(() {
      _areQuizzesLoaded = false;
    });
    _sharedPreferences = await SharedPreferences.getInstance();
    _categoryService = CategoryService();
    await _loadCategories();
  }

  Future<void> _loadCategories() async {
    quizzes = await _categoryService.getAllQuizzesByCategory(
        _sharedPreferences.getString(BEARER_TOKEN) ?? 'null',
        widget.category.categoryId);
    setState(() {
      log('Setting loaded loaded to true');
      _areQuizzesLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.categoryTitle),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: height * 0.1,
                child: Text(
                  widget.category.categoryDescp,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              (_areQuizzesLoaded == true)
                  ? ((quizzes.length > 0)
                      ? Container(
                          height: height * 0.85,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: quizzes.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListItem(quiz: quizzes[index]);
                            },
                          ),
                        )
                      : Container(
                          height: height * 0.85,
                          alignment: Alignment.center,
                          child: const Text(
                            'No Quiz Found',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ))
                  : Center(
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
            ],
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  QuizModel quiz;

  ListItem({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.black, width: 0.5, style: BorderStyle.solid),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Color(0xFFBDDBF2),
      ),
      child: ListTile(
        leading: Container(
          height: double.infinity,
          child: const Icon(
            FontAwesomeIcons.paperclip,
          ),
        ),
        trailing: Container(
          height: double.infinity,
          child: TextButton(
            onPressed: () {},
            child: Text('Attempt'),
          ),
        ),
        title: Text("Title: ${quiz.title}"),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Questions: ${quiz.numberOfQuestions}"),
            Text("About: ${quiz.description}"),
            Text("Marks: ${quiz.numberOfQuestions}"),
          ],
        ),
      ),
    );
  }
}
