import 'dart:developer';

import 'package:assessmentportal/DataModel/QuestionModel.dart';
import 'package:assessmentportal/DataModel/QuizModel.dart';
import 'package:assessmentportal/Service/QuizService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';

import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:sizer/sizer.dart';

class StartQuiz extends StatefulWidget {
  String token;
  QuizModel quizModel;
  List<QuestionModel> questions;
  int userId;
  StartQuiz(
      {required this.userId,
      required this.questions,
      required this.quizModel,
      required this.token});

  @override
  State<StartQuiz> createState() => _StartQuizState();
}

class _StartQuizState extends State<StartQuiz> {
  bool _evaluatingQuiz = false;
  late String title;
  late int _endTime;
  late CountdownTimerController _controller;
  late QuizService _quizService;
  @override
  void initState() {
    super.initState();
    _quizService = QuizService();
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
                      onPressed: () {
                        _onEnd();
                      },
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
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              height: height * 0.80,
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 2,
                  );
                },
                itemCount: widget.questions.length,
                itemBuilder: (context, index) {
                  QuestionModel question = widget.questions[index];
                  return ListTile(
                    tileColor: Color(0xFFF9F9F9),
                    leading: Text(
                      '${index + 1}.',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    title: Text(
                      '${question.content}',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Column(
                      children: [
                        RadioListTile(
                          title: Text("${question.option1}"),
                          value: "${question.option1}",
                          groupValue: widget.questions[index].submittedAnswer,
                          onChanged: (value) {
                            setState(() {
                              widget.questions[index].submittedAnswer =
                                  value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text("${question.option2}"),
                          value: "${question.option2}",
                          groupValue: widget.questions[index].submittedAnswer,
                          onChanged: (value) {
                            setState(() {
                              widget.questions[index].submittedAnswer =
                                  value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text("${question.option3}"),
                          value: "${question.option3}",
                          groupValue: widget.questions[index].submittedAnswer,
                          onChanged: (value) {
                            setState(() {
                              widget.questions[index].submittedAnswer =
                                  value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text("${question.option4}"),
                          value: "${question.option4}",
                          groupValue: widget.questions[index].submittedAnswer,
                          onChanged: (value) {
                            setState(() {
                              widget.questions[index].submittedAnswer =
                                  value.toString();
                            });
                          },
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onEnd() async {
    setState(() {
      _evaluatingQuiz = true;
      _controller.disposeTimer();
    });
    Map<String, dynamic> result = await _quizService.evaluateQuiz(
        token: widget.token,
        quizId: widget.quizModel.quizId,
        userId: widget.userId,
        maxMarks: int.parse(widget.quizModel.maxMarks),
        questions: widget.questions);
    setState(() {
      _evaluatingQuiz = false;
    });
    if (result['code'] == '2000') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Quiz evaluated successfully')));
    }
  }
}
