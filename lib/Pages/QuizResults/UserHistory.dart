import 'package:assessmentportal/NewtworkUtil/API.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class UserHistory extends StatefulWidget {
  String token;
  int quizId;
  UserHistory({required this.token, required this.quizId});

  @override
  State<UserHistory> createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
  late Map<String, dynamic> quizHistoryResult;
  Future<Map<String, dynamic>> _loadHistory() async {
    final API api = API();
    return await api.getAllUsersForQuiz(
        token: widget.token, quizId: widget.quizId);
  }

  final AppBar appBar = AppBar(
    title: Text('Users'),
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
      body: FutureBuilder(
        future: _loadHistory(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            quizHistoryResult = snapshot.data as Map<String, dynamic>;
            return (quizHistoryResult['data'].length > 0)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          height: height * 0.05,
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.5,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Maximum Marks',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${quizHistoryResult['data'][0]['noOfQuestions']}',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Container(
                                width: width * 0.5,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Number of Questions',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${quizHistoryResult['data'][0]['noOfQuestions']}',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          )),
                      Container(
                        height: height * 0.90,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
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
                                quiz: quizHistoryResult['data'][index],
                                index: index);
                          },
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      'No records found!',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  );
          } else {
            return Center(
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
            );
          }
        }),
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
    return Column(
      children: [
        Container(
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
                color: Color.fromARGB(255, 249, 104, 126),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomQuizHistorySubtitleItem(
                      title: 'User ID: ', value: '${quiz['user']['userId']}'),
                  CustomQuizHistorySubtitleItem(
                      title: 'Name: ',
                      value:
                          '${quiz['user']['firstName']} ${quiz['user']['lastName']}'),
                  CustomQuizHistorySubtitleItem(
                      title: 'Username: ',
                      value: '${quiz['user']['user_name']}'),
                  //       "noOfQuestions": 10,
                ],
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
                      title: 'Attempted: ',
                      value: '${quiz['questionsAttempted']}'),
                  CustomQuizHistorySubtitleItem(
                      title: 'Correct: ', value: '${quiz['correctQuestions']}'),
                  CustomQuizHistorySubtitleItem(
                      title: 'Marks obtained: ',
                      value: '${quiz['marksObtained']}'),
                  //       "noOfQuestions": 10,
                ],
              ),
            ),
          ),
        ),
      ],
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
            width: constraints.maxWidth * 0.5,
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
            width: constraints.maxWidth * 0.5,
            child: Text(
              value,
              style: TextStyle(
                  color: Color.fromARGB(255, 9, 1, 57), fontSize: 12.sp),
            ),
          ),
        ],
      );
    });
  }
}
