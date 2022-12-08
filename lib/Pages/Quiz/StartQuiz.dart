import 'dart:developer';

import 'package:assessmentportal/DataModel/QuestionModel.dart';
import 'package:assessmentportal/DataModel/QuizModel.dart';
import 'package:assessmentportal/Service/QuizService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';

import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_indicator/loading_indicator.dart';
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
  bool _isquizEvaluated = false;
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
      _endTime = DateTime.now().millisecondsSinceEpoch + 1 * 60 * 1000;
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
    return WillPopScope(
      onWillPop: () async {
        if (_isquizEvaluated == false) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(title),
        ),
        body: LoaderOverlay(
          overlayWholeScreen: false,
          overlayHeight: height,
          overlayWidth: width,
          overlayColor: Colors.white,
          useDefaultLoading: false,
          overlayWidget: Center(
            child: SizedBox(
              height: height * 0.1,
              width: width * 0.15,
              child: LoadingIndicator(
                  indicatorType: Indicator.lineScale,
                  colors: const [
                    Colors.purple,
                    Colors.indigo,
                    Colors.blue,
                    Colors.green,
                    Colors.red,
                  ],

                  /// Optional, The color collections
                  strokeWidth: 1,

                  /// Optional, The stroke of the line, only applicable to widget which contains line
                  backgroundColor: Colors.white.withOpacity(1.0),

                  /// Optional, Background of the widget
                  pathBackgroundColor: Colors.white

                  /// Optional, the stroke backgroundColor

                  ),
            ),
          ),
          child: Container(
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
                                            (time.min != null &&
                                                time.min! <= 1))
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
                          style: Theme.of(context)
                              .elevatedButtonTheme
                              .style!
                              .copyWith(
                                backgroundColor: (_isquizEvaluated == false)
                                    ? MaterialStateProperty.all<Color>(
                                        Color(Colors.red[600]!.value),
                                      )
                                    : MaterialStateProperty.all<Color>(
                                        Color(Color.fromARGB(255, 181, 175, 175)
                                            .value),
                                      ),
                              ),
                          onPressed: (_isquizEvaluated == false)
                              ? () {
                                  _onEnd();
                                }
                              : null,
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
                              groupValue:
                                  widget.questions[index].submittedAnswer,
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
                              groupValue:
                                  widget.questions[index].submittedAnswer,
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
                              groupValue:
                                  widget.questions[index].submittedAnswer,
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
                              groupValue:
                                  widget.questions[index].submittedAnswer,
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
        ),
      ),
    );
  }

  Future<void> _onEnd() async {
    setState(() {
      _evaluatingQuiz = true;
      context.loaderOverlay.show();
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
      context.loaderOverlay.hide();
      _isquizEvaluated = true;
    });
    if (result['code'] == '2000') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quiz evaluated successfully'),
        ),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Color.fromARGB(255, 234, 234, 234),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              height: 500,
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: constraints.maxHeight * 0.5,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //Max marks
                              InfoItem(
                                  constraints: constraints,
                                  title: "Max Mark:",
                                  descp: widget.quizModel.maxMarks),
                              //Marks obtained
                              InfoItem(
                                  constraints: constraints,
                                  title: "Marks obtained:  ",
                                  descp: '${result['data']['marks obtained']}'),
                              //Questions attempted
                              InfoItem(
                                  constraints: constraints,
                                  title: "Questions attempted:  ",
                                  descp:
                                      '${result['data']['attempted']}/${widget.quizModel.numberOfQuestions}'),

                              //Correct answers
                              InfoItem(
                                  constraints: constraints,
                                  title: "Correct Answers:  ",
                                  descp:
                                      '${result['data']['correct answers']}'),
                            ],
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: Text("Close"),
                    ),
                  ],
                );
              }),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Quiz evaluation error')));
    }
  }
}

class InfoItem extends StatelessWidget {
  BoxConstraints constraints;
  String title, descp;
  InfoItem(
      {required this.constraints, required this.descp, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: constraints.maxHeight * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: constraints.maxWidth * 0.2,
          ),
          Container(
            width: constraints.maxWidth * 0.4,
            child: Text(
              '$title',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ),
          Container(
              width: constraints.maxWidth * 0.4,
              child: Text(
                '$descp',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                ),
              ))
        ],
      ),
    );
  }
}
