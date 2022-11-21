import 'dart:developer';

import 'package:assessmentportal/NewtworkUtil/API.dart';
import 'package:assessmentportal/Register%20and%20Login/RegisterDetails.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VerifyEmailOTP extends StatefulWidget {
  String? email;
  VerifyEmailOTP({required String email}) {
    this.email = email;
  }

  @override
  State<VerifyEmailOTP> createState() => _VerifyEmailOTPState();
}

class _VerifyEmailOTPState extends State<VerifyEmailOTP> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final API api = API();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height * 0.1,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Verify your email.',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                height: height * 0.05,
                child: Text(
                  'You must have received an OTP on the email you just entered. Enter it here and click verify',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                height: height * 0.1,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                ),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _otpController,
                    obscureText: false,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter OTP';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "OTP",
                      prefixIcon: Icon(
                        FontAwesomeIcons.key,
                        color: Colors.black,
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
                child: ElevatedButton(
                  child: FittedBox(
                    child: Text(
                      "Verify",
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> result =
                          await api.verifyEmailVerificationOTP(
                              email: widget.email, otp: _otpController.text);
                      log('email otp verification result: $result');
                      String? code = result['code'];
                      if (code == '2000') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterDetails(
                              email: widget.email!,
                            ),
                          ),
                        );
                      } else if (code == '2001') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Verification Failed!'),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                height: height * 0.05,
                child: TextButton(
                  child: FittedBox(
                    child: Text(
                      "Didn't receive? Resend.",
                    ),
                  ),
                  onPressed: () async {
                    Map<String, dynamic> result = await api
                        .sendEmailVerificationOTP(email: widget.email!);
                    log('email otp sent again: $result');
                    String? code = result['code'];
                    if (code == '2000') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('OTP Sent!'),
                        ),
                      );
                    } else if (code == '2001') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Verification Failed!'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
