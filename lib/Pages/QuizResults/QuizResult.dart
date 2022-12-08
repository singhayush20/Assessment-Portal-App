import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sizer/sizer.dart';

class QuizResultPage extends StatefulWidget {
  const QuizResultPage({super.key});
  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  //This is temporary for dev
  final Map<String, dynamic> quizHistoryResult = {
    "data": [
      {
        "id": {"userId": 98, "quizId": 74},
        "noOfQuestions": 10,
        "questionsAttempted": 8,
        "correctQuestions": 6,
        "maxMarks": 10,
        "marksObtained": 6
      },
      {
        "id": {"userId": 98, "quizId": 87},
        "noOfQuestions": 10,
        "questionsAttempted": 5,
        "correctQuestions": 4,
        "maxMarks": 10,
        "marksObtained": 4
      }
    ],
    "message": "Success",
    "code": "2000"
  };
  final AppBar appBar = AppBar(
    title: Text('Previous Quizzes'),
  );
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar,
      body: ListView.separated(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        separatorBuilder: (context, index) {
          return Divider(
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
      ),
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
        border: Border.all(
            color: Colors.black, width: 0.5, style: BorderStyle.solid),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Color(0xFF2E2A50),
      ),
      child: ListTile(
        leading: Text(
          '${index + 1}.',
          style: TextStyle(
              color: Color.fromARGB(255, 166, 168, 234),
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
            color: Color(0xFFFD7F92),
          ),
          child: Text(
            'Quiz Name',
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
            color: Color(0xFF1AC3A1),
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
                color: Colors.black,
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
