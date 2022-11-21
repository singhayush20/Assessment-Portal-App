import 'dart:developer';

import 'package:assessmentportal/NewtworkUtil/API.dart';
import 'package:assessmentportal/Register%20and%20Login/VerifyEmailOTP.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: height * 0.1,
              margin: EdgeInsets.symmetric(
                horizontal: width * 0.05,
              ),
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(
              height: height * 0.2,
              margin: EdgeInsets.symmetric(
                horizontal: width * 0.05,
              ),
              decoration: BoxDecoration(
                color: Colors.red[200],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.05,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: constraints.maxHeight * 0.2,
                        ),
                        Container(
                          height: constraints.maxHeight * 0.2,
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _emailController,
                              obscureText: false,
                              cursorColor: Colors.black,
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
                              decoration: const InputDecoration(
                                hintText: "Email",
                                prefixIcon: Icon(
                                  FontAwesomeIcons.envelope,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.2,
                        ),
                        Container(
                          height: constraints.maxHeight * 0.2,
                          child: ElevatedButton(
                            child: const Text(
                              "Send OTP",
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String email = _emailController.text;
                                Map<String, dynamic> result = await api
                                    .sendEmailVerificationOTP(email: email);
                                log('result from fetching email otp: $result');
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('OTP could not be sent!'),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.2,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ]),
    );
  }
}
