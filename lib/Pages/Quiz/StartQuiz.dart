import 'dart:developer';

import 'package:assessmentportal/DataModel/QuestionModel.dart';
import 'package:assessmentportal/DataModel/QuizModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';

import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StartQuiz extends StatefulWidget {
  String token;
  QuizModel quizModel;
  List<QuestionModel> questions;

  StartQuiz(
      {required this.questions, required this.quizModel, required this.token});

  @override
  State<StartQuiz> createState() => _StartQuizState();
}

class _StartQuizState extends State<StartQuiz> {
  late String title;
  late int _endTime;
  late CountdownTimerController _controller;
  @override
  void initState() {
    super.initState();
    setState(() {
      title = widget.quizModel.title;
      int quizTimeInMin = widget.quizModel.time;
      log('Time for quiz: $quizTimeInMin');
      _endTime =
          DateTime.now().millisecondsSinceEpoch + quizTimeInMin * 60 * 1000;
    });
    _controller = CountdownTimerController(endTime: _endTime, onEnd: _onEnd);
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
        automaticallyImplyLeading: false,
        title: Text(title),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),
        child: Column(
          children: [
            Container(
              height: height * 0.1,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Max Marks: ${widget.quizModel.maxMarks}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Questions: ${widget.quizModel.numberOfQuestions}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width * 0.5,
                    child: Row(
                      children: [
                        Text(
                          'Time:  ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        CountdownTimer(
                          controller: _controller,
                          widgetBuilder: (_, time) {
                            if (time == null) {
                              return Text(
                                'Ended!',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                            String timeStr;

                            return Text(
                              '${(time.min != null) ? time.min : 0} min ${(time.sec != null) ? time.sec : 0} sec',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: (time.min == null ||
                                        (time.min != null && time.min! <= 1))
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width * 0.3,
                    child: ElevatedButton(
                      onPressed: () async {},
                      child: Text(
                        'Finish',
                        style: TextStyle(
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onEnd() async {}
}
