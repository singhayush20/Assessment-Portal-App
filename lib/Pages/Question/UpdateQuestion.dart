import 'dart:developer';

import 'package:assessmentportal/DataModel/QuestionModel.dart';
import 'package:assessmentportal/Service/QuestionService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UpdateQuestionPage extends StatefulWidget {
  String token;
  QuestionModel question;
  UpdateQuestionPage({required this.token, required this.question});

  @override
  State<UpdateQuestionPage> createState() => _UpdateQuestionPageState();
}

class _UpdateQuestionPageState extends State<UpdateQuestionPage> {
  final QuestionService questionService = QuestionService();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _contentController = TextEditingController();
  TextEditingController _option1Controller = TextEditingController();
  TextEditingController _option2Controller = TextEditingController();
  TextEditingController _option3Controller = TextEditingController();
  TextEditingController _option4Controller = TextEditingController();
  TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.question.content;
    _option1Controller.text = widget.question.option1;
    _option2Controller.text = widget.question.option2;
    _option3Controller.text = widget.question.option3 ?? '';
    _option4Controller.text = widget.question.option4 ?? '';
    _answerController.text = widget.question.correctAnswer;
  }

  @override
  Widget build(BuildContext context) {
    log('current question: ${widget.question.quiz}');

    final height = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Question',
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),
        height: height,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: height * 0.1,
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Edit the details and click update,\n* marked fields are compulsory',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              Container(
                height: height * 0.5,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                      style: BorderStyle.solid),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: const Color.fromARGB(255, 244, 223, 223),
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
                        ),

                        Container(
                          alignment: Alignment.center,
                          height: constraints.maxHeight * 0.15,
                          child: TextFormField(
                            maxLines: 2,
                            controller: _contentController,
                            obscureText: false,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Question cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "Question*",
                              prefixIcon: Icon(
                                FontAwesomeIcons.circleInfo,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        //====OPTION 1====
                        Container(
                          alignment: Alignment.center,
                          height: constraints.maxHeight * 0.15,
                          child: TextFormField(
                            maxLines: 1,
                            controller: _option1Controller,
                            obscureText: false,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Option 1 cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "Option 1*",
                              prefixIcon: Icon(
                                FontAwesomeIcons.circleInfo,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        //==== OPTION 2====
                        Container(
                          alignment: Alignment.center,
                          height: constraints.maxHeight * 0.15,
                          child: TextFormField(
                            maxLines: 2,
                            controller: _option2Controller,
                            obscureText: false,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Option 2 cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "Option 2*",
                              prefixIcon: Icon(
                                FontAwesomeIcons.circleInfo,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        //====Option 3====
                        Container(
                          alignment: Alignment.center,
                          height: constraints.maxHeight * 0.15,
                          child: TextFormField(
                            maxLines: 1,
                            controller: _option3Controller,
                            obscureText: false,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            validator: (value) {},
                            decoration: const InputDecoration(
                              hintText: "Option 3",
                              prefixIcon: Icon(
                                FontAwesomeIcons.circleInfo,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        //====Option 4====
                        Container(
                          alignment: Alignment.center,
                          height: constraints.maxHeight * 0.15,
                          child: TextFormField(
                            maxLines: 1,
                            controller: _option4Controller,
                            obscureText: false,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            validator: (value) {},
                            decoration: const InputDecoration(
                              hintText: "Option 4",
                              prefixIcon: Icon(
                                FontAwesomeIcons.circleInfo,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        //====ANSWER====
                        Container(
                          alignment: Alignment.center,
                          height: constraints.maxHeight * 0.15,
                          child: TextFormField(
                            maxLines: 1,
                            controller: _answerController,
                            obscureText: false,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Answer cannot be empty';
                              } else if (!(value == _option1Controller.text ||
                                  value == _option2Controller.text ||
                                  value == _option3Controller.text ||
                                  value == _option4Controller.text)) {
                                return "Answer should match one or more options";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: "Answer*",
                              prefixIcon: Icon(
                                FontAwesomeIcons.circleInfo,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
                        ),
                      ],
                    ),
                  );
                }),
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
                      String code = await questionService.updateQuestion(
                          questionId: widget.question.questionId ?? 0,
                          content: _contentController.text,
                          option1: _option1Controller.text,
                          option2: _option2Controller.text,
                          answer: _answerController.text,
                          token: widget.token,
                          quizId: widget.question.quiz!['quizId'].toString(),
                          option3: _option3Controller.text,
                          option4: _option4Controller.text);
                      if (code == '2000') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Question updated successfully'),
                          ),
                        );

                        Navigator.pop(context);
                      } else {
                        String code = await questionService.deleteQuestion(
                            questionId: widget.question.questionId ?? 0,
                            token: widget.token);
                        if (code == '2000') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Question not updated'),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: const FittedBox(
                    child: Text(
                      'Add Question',
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
