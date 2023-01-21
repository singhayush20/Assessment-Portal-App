import 'dart:developer';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/DataModel/QuizModel.dart';
import 'package:assessmentportal/Service/QuizService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UpdateQuizPage extends StatefulWidget {
  String token;
  int userid;
  int categoryid;
  QuizModel quiz;
  UpdateQuizPage(
      {required this.userid,
      required this.categoryid,
      required this.token,
      required this.quiz});

  @override
  State<UpdateQuizPage> createState() => _UpdateQuizPageState();
}

class _UpdateQuizPageState extends State<UpdateQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descpController = TextEditingController();
  final _maxMarksController = TextEditingController();
  final _noOfQuestionsController = TextEditingController();
  final _timeController = TextEditingController();
  late bool _isQuizActive;
  @override
  void initState() {
    setState(() {
      _isQuizActive = widget.quiz.active;
      _titleController.text = widget.quiz.title;
      _descpController.text = widget.quiz.description;
      _maxMarksController.text = widget.quiz.maxMarks;
      _noOfQuestionsController.text = widget.quiz.numberOfQuestions.toString();
      _timeController.text = widget.quiz.time.toString();
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Update Quiz',
        ),
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
            child: DataLoadingIndicator(),
          ),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                height: height * 0.05,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Edit the details and click update',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                height: height * 0.5,
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0EAE5),
                  border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                      style: BorderStyle.solid),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: constraints.maxHeight * 0.2,
                            child: TextFormField(
                              controller: _titleController,
                              obscureText: false,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Title cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: "Title",
                                prefixIcon: Icon(
                                  FontAwesomeIcons.heading,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: constraints.maxHeight * 0.2,
                            child: TextFormField(
                              controller: _descpController,
                              obscureText: false,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Description cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: "Description",
                                prefixIcon: Icon(
                                  FontAwesomeIcons.circleInfo,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: constraints.maxHeight * 0.2,
                            child: TextFormField(
                              controller: _noOfQuestionsController,
                              obscureText: false,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'No. of questions cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: "No. of Questions",
                                prefixIcon: Icon(
                                  FontAwesomeIcons.question,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width * 0.4,
                                height: constraints.maxHeight * 0.2,
                                alignment: Alignment.center,
                                child: TextFormField(
                                  controller: _maxMarksController,
                                  obscureText: false,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Maximum marks cannot be empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Max. Marks",
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.chevronRight,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: width * 0.5,
                                height: constraints.maxHeight * 0.2,
                                alignment: Alignment.center,
                                child: TextFormField(
                                  controller: _timeController,
                                  obscureText: false,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Time cannot be empty';
                                    } else if (int.parse(value) <= 0) {
                                      return 'Invalid time';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Time (in min.)",
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.clock,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  height: constraints.maxHeight * 0.2,
                                  child: const Text(
                                    'Active',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: constraints.maxHeight * 0.2,
                                  child: Switch.adaptive(
                                      activeColor: Colors.blueGrey.shade600,
                                      activeTrackColor: Colors.grey.shade400,
                                      inactiveThumbColor:
                                          Colors.blueGrey.shade600,
                                      inactiveTrackColor: Colors.grey.shade400,
                                      splashRadius: 50.0,
                                      value: _isQuizActive,
                                      onChanged: (value) {
                                        setState(() {
                                          _isQuizActive = value;
                                          log('_isQuizActive: $_isQuizActive');
                                        });
                                      }),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
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
                    if (_formKey.currentState!.validate()) {
                      context.loaderOverlay.show();

                      QuizService quizService = QuizService();
                      log('Updating quiz, checking _isQuizActive $_isQuizActive');

                      String code = await quizService.updateQuiz(
                        title: _titleController.text.trim(),
                        description: _descpController.text.trim(),
                        numberOfQuestions: _noOfQuestionsController.text.trim(),
                        maxMarks: _maxMarksController.text.trim(),
                        active: _isQuizActive,
                        categoryId: widget.categoryid,
                        userid: widget.userid,
                        time: int.parse(_timeController.text),
                        quizid: widget.quiz.quizId,
                        token: widget.token,
                      );
                      context.loaderOverlay.hide();

                      if (code == "2000") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Quiz updated successfully!'),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Quiz not updated!'),
                          ),
                        );
                        // }
                      }
                    }
                  },
                  child: const FittedBox(
                    child: Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
