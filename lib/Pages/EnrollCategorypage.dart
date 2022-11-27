import 'package:assessmentportal/NewtworkUtil/API.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EnrollCategorypage extends StatefulWidget {
  String userid;
  String token;
  EnrollCategorypage({required this.userid, required this.token});

  @override
  State<EnrollCategorypage> createState() => _EnrollCategorypageState();
}

class _EnrollCategorypageState extends State<EnrollCategorypage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  AppBar appBar = AppBar(
    title: Text('Enroll yourself'),
  );
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              height: height * 0.1,
              alignment: Alignment.centerLeft,
              child: Text(
                'Enter the code of the category you want to enroll in, then click enroll',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              height: height * 0.1,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE0EAE5),
                border: Border.all(
                    color: Colors.black, width: 0.5, style: BorderStyle.solid),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Container(
                  height: height * 0.05,
                  child: TextFormField(
                    obscureText: false,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Code cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    controller: _codeController,
                    decoration: const InputDecoration(
                      hintText: "Category Code",
                      prefixIcon: Icon(
                        FontAwesomeIcons.code,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              height: height * 0.05,
              width: width * 0.4,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    API api = API();
                    Map<String, dynamic> result =
                        await api.enrollUserInCategory(
                            userid: int.parse(widget.userid),
                            categoryid: int.parse(_codeController.text.trim()),
                            token: widget.token);
                    if (result['code'] == '2000') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enrollment successfully'),
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enrollment unsuccessful'),
                        ),
                      );
                    }
                  }
                },
                child: const FittedBox(
                  child: Text(
                    'Enroll',
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
