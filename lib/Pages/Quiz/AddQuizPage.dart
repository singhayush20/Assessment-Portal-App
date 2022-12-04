import 'package:assessmentportal/Service/QuizService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddQuizPage extends StatefulWidget {
  String token;
  int userid;
  int categoryid;
  AddQuizPage(
      {required this.userid, required this.categoryid, required this.token});

  @override
  State<AddQuizPage> createState() => _AddQuizPageState();
}

class _AddQuizPageState extends State<AddQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descpController = TextEditingController();
  final _maxMarksController = TextEditingController();
  final _noOfQuestionsController = TextEditingController();
  final _timeController = TextEditingController();

  bool _isQuizActive = false;
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
          'Add new Quiz',
        ),
      ),
      body: Container(
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
                'Fill the details and click submit',
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
                    color: Colors.black, width: 0.5, style: BorderStyle.solid),
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
                        //TITLE
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
                        //Description
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
                        //Number of questions
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
                        //Maximum Marks
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: constraints.maxHeight * 0.2,
                              width: constraints.maxWidth * 0.4,
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
                              height: constraints.maxHeight * 0.2,
                              width: constraints.maxWidth * 0.5,
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
                        //Active Status
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
                    QuizService quizService = QuizService();
                    String code = await quizService.addNewQuiz(
                      title: _titleController.text.trim(),
                      description: _descpController.text.trim(),
                      noOfQues: int.parse(_noOfQuestionsController.text.trim()),
                      maxMarks: int.parse(_maxMarksController.text.trim()),
                      isActive: _isQuizActive,
                      time: int.parse(_timeController.text),
                      categoryId: widget.categoryid,
                      userId: widget.userid,
                      token: widget.token,
                    );
                    if (code == "2000") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Quiz added successfully!'),
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Quiz not added'),
                        ),
                      );
                      // }
                    }
                  }
                },
                child: const FittedBox(
                  child: Text(
                    'Submit',
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
    );
  }
}
