import 'dart:developer';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/DataModel/CategoryModel.dart';
import 'package:assessmentportal/DataModel/QuizModel.dart';
import 'package:assessmentportal/NewtworkUtil/API.dart';
import 'package:assessmentportal/Pages/Quiz/AddQuizPage.dart';
import 'package:assessmentportal/Pages/Question/QuizQuestionsPage.dart';
import 'package:assessmentportal/Pages/Quiz/AttempQuiz.dart';
import 'package:assessmentportal/Pages/Quiz/UpdateQuiz.dart';
import 'package:assessmentportal/Pages/QuizResults/UserHistory.dart';
import 'package:assessmentportal/Service/CateogoryService.dart';
import 'package:assessmentportal/Service/QuizService.dart';
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
  SharedPreferences? _sharedPreferences;
  List<QuizModel> quizzes = [];
  late CategoryService _categoryService;
  bool _areQuizzesLoaded = false;
  final API api = API();
  @override
  void initState() {
    super.initState();

    _initializeData();
  }

  void _initializeData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _categoryService = CategoryService();

    await _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    setState(() {
      _areQuizzesLoaded = false;
    });
    if (_sharedPreferences != null &&
        _sharedPreferences!.getString(ROLE) == ROLE_NORMAL) {
      quizzes = await _categoryService.getAllQuizzesByCategory(
          _sharedPreferences!.getString(BEARER_TOKEN) ?? 'null',
          widget.category.categoryId);
    } else {
      quizzes = await _categoryService.getAllQuizzesByAdminAndCategory(
        adminid: _sharedPreferences!.getInt(USER_ID) ?? 0,
        categoryid: widget.category.categoryId,
        token: _sharedPreferences!.getString(BEARER_TOKEN) ?? 'null',
      );
    }
    setState(() {
      log('Setting loaded to true');
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
        title: FittedBox(child: Text(widget.category.categoryTitle)),
        actions: (_sharedPreferences != null &&
                _sharedPreferences!.getString(ROLE) != ROLE_NORMAL)
            ? [
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    right: 10,
                    left: 5,
                    bottom: 5,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddQuizPage(
                            userid: _sharedPreferences!.getInt(USER_ID) ?? 0,
                            categoryid: widget.category.categoryId,
                            token:
                                _sharedPreferences!.getString(BEARER_TOKEN) ??
                                    'null',
                          ),
                        ),
                      );
                    },
                    child: const Text('Add Quiz'),
                  ),
                ),
              ]
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: _loadQuizzes,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  height: height * 0.1,
                  child: Text(
                    widget.category.categoryDescp,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                (_areQuizzesLoaded == true)
                    ? ((quizzes.length > 0)
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: quizzes.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.only(
                                  bottom: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black,
                                      width: 0.5,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Color(0xFFBDDBF2),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    if (_sharedPreferences!.getString(ROLE) !=
                                        ROLE_NORMAL) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              QuizQuestionsPage(
                                                  token: _sharedPreferences!
                                                          .getString(
                                                              BEARER_TOKEN) ??
                                                      'null',
                                                  role: _sharedPreferences!
                                                          .getString(ROLE) ??
                                                      'null',
                                                  quiz: quizzes[index]),
                                        ),
                                      );
                                    }
                                  },
                                  leading: Container(
                                    height: double.infinity,
                                    child: const Icon(
                                      FontAwesomeIcons.paperclip,
                                    ),
                                  ),
                                  trailing: (_sharedPreferences!
                                              .getString(ROLE) ==
                                          ROLE_NORMAL)
                                      ? Container(
                                          height: double.infinity,
                                          child: TextButton(
                                            onPressed: () async {
                                              //go to attempt quiz page if the user has not already attempted the quiz
                                              Map<String, dynamic> result =
                                                  await api.checkQuizAttempt(
                                                      token: _sharedPreferences!
                                                              .getString(
                                                                  BEARER_TOKEN) ??
                                                          'null',
                                                      userId: _sharedPreferences!
                                                              .getInt(
                                                                  USER_ID) ??
                                                          0,
                                                      quizId: quizzes[index]
                                                          .quizId);
                                              if (result['status'] == 'false' ||
                                                  result['status'] == false) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AttemptQuiz(
                                                      quiz: quizzes[index],
                                                      token: _sharedPreferences!
                                                              .getString(
                                                                  BEARER_TOKEN) ??
                                                          'null',
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'You have already attempted this quiz!'),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text('Attempt'),
                                          ),
                                        )
                                      : PopupMenuButton(
                                          // add icon, by default "3 dot" icon
                                          // icon: Icon(Icons.book)
                                          itemBuilder: (context) {
                                            return [
                                              const PopupMenuItem<int>(
                                                value: 0,
                                                child: Text("Delete"),
                                              ),
                                              const PopupMenuItem<int>(
                                                value: 1,
                                                child: Text("Update"),
                                              ),
                                              const PopupMenuItem<int>(
                                                value: 2,
                                                child: Text("Attempts"),
                                              ),
                                            ];
                                          },
                                          onSelected: (value) async {
                                            QuizService quizService =
                                                QuizService();
                                            if (value == 0) {
                                              log('Delete option chosen on quiz: ${quizzes[index].quizId}');
                                              String code =
                                                  await quizService.deleteQuiz(
                                                      quizid:
                                                          quizzes[index].quizId,
                                                      token: _sharedPreferences!
                                                              .getString(
                                                                  BEARER_TOKEN) ??
                                                          'null');
                                              if (code == '2000') {
                                                log('Quiz is deleted');
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      'Quiz deleted Successfully!'),
                                                ));
                                                setState(() {
                                                  quizzes.removeAt(index);
                                                });
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content:
                                                      Text('Quiz not deleted!'),
                                                ));
                                              }
                                            } else if (value == 1) {
                                              print(
                                                  "Update quiz selected on ${quizzes[index].quizId}");
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => UpdateQuizPage(
                                                      userid: _sharedPreferences!
                                                              .getInt(
                                                                  USER_ID) ??
                                                          0,
                                                      categoryid: widget
                                                          .category.categoryId,
                                                      token: _sharedPreferences!
                                                              .getString(
                                                                  BEARER_TOKEN) ??
                                                          'null',
                                                      quiz: quizzes[index]),
                                                ),
                                              );
                                            } else if (value == 2) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserHistory(
                                                    token: _sharedPreferences!
                                                            .getString(
                                                                BEARER_TOKEN) ??
                                                        'null',
                                                    quizId:
                                                        quizzes[index].quizId,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                  title: Text("Title: ${quizzes[index].title}"),
                                  subtitle: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "About: ${quizzes[index].description}"),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                                "Questions: ${quizzes[index].numberOfQuestions}"),
                                          ),
                                          Expanded(
                                            child: Text(
                                                "Marks: ${quizzes[index].numberOfQuestions}"),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              "Duration: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${quizzes[index].time}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              "Status: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Expanded(
                                            child: (quizzes[index].active)
                                                ? const Text(
                                                    "Active",
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )
                                                : Text(
                                                    "Inactive",
                                                    style: TextStyle(
                                                      color: Color(Colors
                                                          .red[900]!.value),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
                          height: height * 0.8,
                          alignment: Alignment.center,
                          child: DataLoadingIndicator(),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
