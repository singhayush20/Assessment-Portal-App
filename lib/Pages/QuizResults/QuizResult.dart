import 'dart:developer';

import 'package:assessmentportal/AppConstants/Themes.dart';
import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/NewtworkUtil/API.dart';
import 'package:assessmentportal/Pages/Category/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizer/sizer.dart';

class QuizResultPage extends StatefulWidget {
  const QuizResultPage({super.key});
  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  //This is temporary for dev
  late Map<String, dynamic> quizHistoryResult;

  late SharedPreferences _sharedPreferences;

  Future<Map<String, dynamic>> _loadHistory() async {
    await _initializePrefs();
    ;
    final API api = API();
    return await api.getAllQuizzesForUser(
        token: _sharedPreferences.getString(BEARER_TOKEN) ?? 'null',
        userId: _sharedPreferences.getInt(USER_ID) ?? 0);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initializePrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: FutureBuilder(
          future: _loadHistory(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              quizHistoryResult = snapshot.data as Map<String, dynamic>;
              if (quizHistoryResult['data'].length > 0) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return const Divider(
                      indent: 100,
                      endIndent: 100,
                      color: Color(0xFF5155E3),
                      thickness: 4,
                    );
                  },
                  itemCount: quizHistoryResult['data'].length,
                  itemBuilder: (context, index) {
                    return CustomListTile(
                        quiz: quizHistoryResult['data'][index], index: index);
                  },
                );
              } else {
                return Center(
                  child: Text(
                    'No records found!',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: Container(
                  height: height * 0.8,
                  alignment: Alignment.center,
                  child: DataLoadingIndicator(),
                ),
              );
            }
          }),
    );
  }
}

class CustomListTile extends StatelessWidget {
  Map<String, dynamic> quiz;
  int index;

  CustomListTile({required this.quiz, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 2,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: scaffoldColor,
      ),
      child: ListTile(
        leading: Text(
          '${index + 1}.',
          style: TextStyle(
              color: Colors.purple,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900),
        ),
        title: Container(
          margin: EdgeInsets.symmetric(
            vertical: 10,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black, width: 0.5, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: Color.fromARGB(255, 240, 120, 45),
          ),
          child: Text(
            '${quiz['quiz']['title']}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 15.sp,
            ),
          ),
        ),
        subtitle: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black, width: 0.5, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: Color.fromARGB(255, 114, 38, 219),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomQuizHistorySubtitleItem(
                  title: 'Number of Questions: ',
                  value: '${quiz['noOfQuestions']}'),
              CustomQuizHistorySubtitleItem(
                  title: 'Attempted: ', value: '${quiz['questionsAttempted']}'),
              CustomQuizHistorySubtitleItem(
                  title: 'Correct: ', value: '${quiz['correctQuestions']}'),
              CustomQuizHistorySubtitleItem(
                title: 'Max Marks: ',
                value: '${quiz['maxMarks']}',
              ),
              CustomQuizHistorySubtitleItem(
                  title: 'Marks obtained: ', value: '${quiz['marksObtained']}'),
              //       "noOfQuestions": 10,
            ],
          ),
        ),
      ),
    );
  }
}

class CustomQuizHistorySubtitleItem extends StatelessWidget {
  String title, value;
  CustomQuizHistorySubtitleItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: [
          Container(
            width: constraints.maxWidth * 0.6,
            child: Text(
              title,
              style: TextStyle(
                // color: Color.fromARGB(255, 218, 234, 229),
                color: Color.fromARGB(255, 216, 212, 212),
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: constraints.maxWidth * 0.4,
            child: Text(
              value,
              style: TextStyle(color: Color(0xFFF6FFFD), fontSize: 12.sp),
            ),
          ),
        ],
      );
    });
  }
}
