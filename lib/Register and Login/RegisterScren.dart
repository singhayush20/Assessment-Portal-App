import 'dart:developer';

import 'package:assessmentportal/AppConstants/Themes.dart';
import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/NewtworkUtil/API.dart';
import 'package:assessmentportal/Register%20and%20Login/VerifyEmailOTP.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final API api = API();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Container(
            height: 100,
            width: 100,
            child: const CustomLoadingIndicator(),
          ),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.05,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Container(
                  height: height * 0.1,
                  child: Text(
                    'Enter the email address you want to use for your account',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                Container(
                  height: height * 0.2,
                  decoration: boxDecoration,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.05,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: constraints.maxHeight * 0.1,
                            ),
                            Container(
                              height: constraints.maxHeight * 0.4,
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 2,
                                  controller: _emailController,
                                  obscureText: false,
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter email';
                                    } else {
                                      if (!EmailValidator.validate(value)) {
                                        return "Wrong email id";
                                      } else {
                                        return null;
                                      }
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: Theme.of(context)
                                        .inputDecorationTheme
                                        .hintStyle,
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.envelope,
                                      color: Colors.white,
                                    ),
                                    focusedBorder: Theme.of(context)
                                        .inputDecorationTheme
                                        .focusedBorder,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.1,
                            ),
                            Container(
                              height: constraints.maxHeight * 0.2,
                              child: ElevatedButton(
                                child: const Text(
                                  "Send OTP",
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    context.loaderOverlay.show();

                                    String email = _emailController.text;
                                    Map<String, dynamic> result = await api
                                        .sendEmailVerificationOTP(email: email);
                                    log('result from fetching email otp: $result');
                                    context.loaderOverlay.hide();
                                    String? code = result['code'];
                                    if (code == '2000') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VerifyEmailOTP(
                                            email: email,
                                          ),
                                        ),
                                      );
                                    } else if (code == '2001') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('OTP could not be sent!'),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.1,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
