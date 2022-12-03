import 'dart:developer';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/DataModel/QuestionModel.dart';
import 'package:assessmentportal/DataModel/QuizModel.dart';
import 'package:assessmentportal/Pages/Question/AddQuestionPage.dart';
import 'package:assessmentportal/Pages/Question/UpdateQuestion.dart';
import 'package:assessmentportal/Service/QuestionService.dart';
import 'package:assessmentportal/provider/QuestionProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class QuizQuestionsPage extends StatefulWidget {
  String token, role;
  QuizModel quiz;
  QuizQuestionsPage(
      {required this.token, required this.role, required this.quiz});

  @override
  State<QuizQuestionsPage> createState() => _QuizQuestionsPageState();
}

class _QuizQuestionsPageState extends State<QuizQuestionsPage> {
  @override
  void initState() {
    // _loadQuestions();
  }

  // final QuestionService _questionService = QuestionService();
  // Future<List<QuestionModel>> _loadQuestions() async {
  //   return await _questionService.loadQuestions(
  //       quizId: widget.quiz.quizId.toString(), token: widget.token);
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final QuestionProvider _questionProvider =
        Provider.of<QuestionProvider>(context);
    if (_questionProvider.areQuestionsLoaded ==
        QuestionLoadingStatus.NOT_STARTED) {
      _questionProvider.loadQuestions(
          quizId: widget.quiz.quizId.toString(), token: widget.token);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Questions'),
          actions: (widget.role != ROLE_NORMAL)
              ? [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddQuestionPage(
                              quiz: widget.quiz, token: widget.token),
                        ),
                      );
                    },
                    icon: const Icon(
                      FontAwesomeIcons.plus,
                    ),
                  ),
                ]
              : null,
        ),
        body: (_questionProvider.areQuestionsLoaded ==
                QuestionLoadingStatus.COMPLETED)
            ? (_questionProvider.questions.isNotEmpty)
                ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _questionProvider.questions.length,
                    itemBuilder: (context, index) {
                      return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: 0.5,
                                style: BorderStyle.solid),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Color.fromARGB(255, 244, 223, 223),
                          ),
                          margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                          height: height * 0.2,
                          child: CustomListTile(
                            question: _questionProvider.questions[index],
                            index: index,
                            token: widget.token,
                            questionProvider: _questionProvider,
                          ));
                    })
                : Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'No Questions in this Quiz',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
            : Center(
                child: Container(
                  color: Colors.white,
                  height: height * 0.8,
                  alignment: Alignment.center,
                  child: Container(
                    height: 80,
                    width: 80,
                    child: const LoadingIndicator(
                        indicatorType: Indicator.lineScale,
                        colors: [
                          Colors.purple,
                          Colors.indigo,
                          Colors.blue,
                          Colors.green,
                          Colors.red,
                        ],

                        /// Optional, The color collections
                        strokeWidth: 1,

                        /// Optional, The stroke of the line, only applicable to widget which contains line
                        backgroundColor: Colors.white,

                        /// Optional, Background of the widget
                        pathBackgroundColor: Colors.white

                        /// Optional, the stroke backgroundColor

                        ),
                  ),
                ),
              )
        // body: FutureBuilder<List<QuestionModel>>(
        // future: _loadQuestions(),
        // future: _questionProvider.loadQuestions(
        // quizId: widget.quiz.quizId.toString(), token: widget.token),
        // builder: (context, snapshot) {
        //   log('data in snapshot: ${snapshot.data}');
        //   if (!snapshot.hasData) {
        //     return Center(
        //       child: Container(
        //         color: Colors.white,
        //         height: height * 0.8,
        //         alignment: Alignment.center,
        //         child: Container(
        //           height: 80,
        //           width: 80,
        //           child: const LoadingIndicator(
        //               indicatorType: Indicator.lineScale,
        //               colors: [
        //                 Colors.purple,
        //                 Colors.indigo,
        //                 Colors.blue,
        //                 Colors.green,
        //                 Colors.red,
        //               ],

        //               /// Optional, The color collections
        //               strokeWidth: 1,

        //               /// Optional, The stroke of the line, only applicable to widget which contains line
        //               backgroundColor: Colors.white,

        //               /// Optional, Background of the widget
        //               pathBackgroundColor: Colors.white

        //               /// Optional, the stroke backgroundColor

        //               ),
        //         ),
        //       ),
        //     );
        //   } else {
        //     List<QuestionModel> questions = snapshot.data ?? [];
        //     return (questions.length > 0)
        //         ? ListView.builder(
        //             physics: NeverScrollableScrollPhysics(),
        //             itemCount: questions.length,
        //             itemBuilder: (context, index) {
        //               return Container(
        //                   decoration: BoxDecoration(
        //                     border: Border.all(
        //                         color: Colors.black,
        //                         width: 0.5,
        //                         style: BorderStyle.solid),
        //                     borderRadius: const BorderRadius.all(
        //                       Radius.circular(20),
        //                     ),
        //                     color: Color.fromARGB(255, 244, 223, 223),
        //                   ),
        //                   margin: EdgeInsets.only(left: 5, right: 5, top: 5),
        //                   height: height * 0.2,
        //                   child: CustomListTile(
        //                     question: questions[index],
        //                     index: index,
        //                     token: widget.token,
        //                     questionProvider: _questionProvider,
        //                   ));
        //             })
        //         : Center(
        //             child: Container(
        //               alignment: Alignment.center,
        //               child: const Text(
        //                 'No Questions in this Quiz',
        //                 style: TextStyle(
        //                   fontSize: 20,
        //                   fontWeight: FontWeight.w600,
        //                 ),
        //               ),
        //             ),
        //           );
        //   }
        // },
        //   ),
        );
  }
}

class CustomListTile extends StatefulWidget {
  QuestionModel question;
  QuestionProvider questionProvider;
  int index;
  String token;
  CustomListTile(
      {required this.question,
      required this.index,
      required this.token,
      required this.questionProvider});

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth * 0.05,
          vertical: constraints.maxHeight * 0.05,
        ),
        child: Stack(
          children: [
            Column(children: [
              Container(
                height: constraints.maxHeight * 0.2,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${widget.index + 1}. ${widget.question.content}',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
              ),
              Container(
                height: constraints.maxHeight * 0.7,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 5,
                  childAspectRatio:
                      constraints.maxWidth / constraints.maxHeight * 1.5,
                  crossAxisCount: 2,
                  children: [
                    QuestionChoice(
                        question: widget.question,
                        choice: '1. ${widget.question.option1}',
                        token: widget.token),
                    QuestionChoice(
                      question: widget.question,
                      choice: '2. ${widget.question.option2}',
                      token: widget.token,
                    ),
                    QuestionChoice(
                      question: widget.question,
                      choice: '3. ${widget.question.option3}',
                      token: widget.token,
                    ),
                    QuestionChoice(
                      question: widget.question,
                      choice: '4. ${widget.question.option4}',
                      token: widget.token,
                    ),
                  ],
                ),
              ),
            ]),
            Positioned(
              right: 0.5,
              child: Container(
                height: constraints.maxHeight * 0.2,
                alignment: Alignment.center,
                child: PopupMenuButton(
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
                    ];
                  },
                  onSelected: (value) async {
                    if (value == 0) {
                      //delete
                      final QuestionService questionService = QuestionService();
                      String code = await questionService.deleteQuestion(
                          token: widget.token,
                          questionId: widget.question.questionId ?? 0);
                      if (code == '2000') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Question deleted successfully')));
                        widget.questionProvider.loadQuestions(
                            quizId: widget.question.quiz!['quizId'].toString(),
                            token: widget.token);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Question not deleted')));
                      }
                    } else if (value == 1) {
                      //update
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateQuestionPage(
                                  question: widget.question,
                                  token: widget.token)));
                    }
                  },
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

class QuestionChoice extends StatelessWidget {
  const QuestionChoice({
    Key? key,
    required this.choice,
    required this.token,
    required this.question,
  }) : super(key: key);

  final String choice;
  final QuestionModel question;
  final String token;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black, width: 0.5, style: BorderStyle.solid),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            color: Color.fromARGB(255, 128, 200, 243),
          ),
          child: Text(choice),
        );
      },
    );
  }
}
