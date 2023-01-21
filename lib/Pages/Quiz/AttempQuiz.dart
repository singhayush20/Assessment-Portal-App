import 'dart:developer';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/DataModel/QuestionModel.dart';
import 'package:assessmentportal/DataModel/QuizModel.dart';
import 'package:assessmentportal/Pages/Quiz/StartQuiz.dart';
import 'package:assessmentportal/Service/QuestionService.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizer/sizer.dart';

class AttemptQuiz extends StatefulWidget {
  String token;
  QuizModel quiz;
  AttemptQuiz({required this.quiz, required this.token});

  @override
  State<AttemptQuiz> createState() => _AttemptQuizState();
}

class _AttemptQuizState extends State<AttemptQuiz> {
  QuestionLoadingStatus _areQuestionsLoaded = QuestionLoadingStatus.NOT_STARTED;
  List<QuestionModel> questions = [];
  late SharedPreferences _sharedPreferences;
  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    QuestionService questionService = QuestionService();
    setState(() {
      _areQuestionsLoaded = QuestionLoadingStatus.LOADING;
    });
    _sharedPreferences = await SharedPreferences.getInstance();
    questions = await questionService.loadQuestions(
        quizId: widget.quiz.quizId.toString(), token: widget.token);
    setState(() {
      _areQuestionsLoaded = QuestionLoadingStatus.COMPLETED;
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
        title: Text('Attempt Quiz'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            Container(
              height: height * 0.3,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black, width: 0.5, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Color.fromARGB(255, 207, 131, 45),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      QuizItem(
                        constraints: constraints,
                        text: 'Title: ' + widget.quiz.title.toString(),
                      ),
                      QuizItem(
                        constraints: constraints,
                        text: 'Description: ' +
                            widget.quiz.description.toString(),
                      ),
                      QuizItem(
                        constraints: constraints,
                        text:
                            'Max Questions: ' + widget.quiz.maxMarks.toString(),
                      ),
                      QuizItem(
                        constraints: constraints,
                        text: 'Number of questions: ' +
                            widget.quiz.numberOfQuestions.toString(),
                      ),
                      QuizItem(
                        constraints: constraints,
                        text: 'Duration: ' + widget.quiz.time.toString(),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              height: height * 0.05,
              width: width * 0.5,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StartQuiz(
                          userId: _sharedPreferences.getInt(USER_ID) ?? 0,
                          questions: questions,
                          token: widget.token,
                          quizModel: widget.quiz),
                    ),
                  );
                },
                child: (_areQuestionsLoaded == QuestionLoadingStatus.LOADING ||
                        _areQuestionsLoaded ==
                            QuestionLoadingStatus.NOT_STARTED)
                    ? const LoadingIndicator(indicatorType: Indicator.ballBeat)
                    : Text(
                        'Start Quiz',
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizItem extends StatelessWidget {
  BoxConstraints constraints;
  String text;
  QuizItem({required this.constraints, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: constraints.maxWidth * 0.02,
      ),
      height: constraints.maxHeight * 0.2,
      alignment: Alignment.centerLeft,
      child: Text(
        '$text',
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}
