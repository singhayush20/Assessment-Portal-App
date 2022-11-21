import 'package:assessmentportal/NewtworkUtil/API.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  bool isPasswordVisible = false;

  final _confirmPasswordController = TextEditingController();

  final _otpController = TextEditingController();

  bool isOTPSent = false;
  @override
  Widget build(BuildContext context) {
    final API api = API();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.05,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Container(
                  height: height * 0.1,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Quizzo',
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
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: height * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Form(
                    key: _formKey,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            //====Email====
                            Container(
                              alignment: Alignment.center,
                              height: constraints.maxHeight * 0.2,
                              child: TextFormField(
                                controller: _emailController,
                                obscureText: false,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email cannot be empty';
                                  } else {
                                    return null;
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
                            //Send OTP Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: constraints.maxHeight * 0.1,
                                  child: TextButton(
                                    onPressed: () async {
                                      if (EmailValidator.validate(
                                          _emailController.text)) {
                                        Map<String, dynamic> result = await api
                                            .sendForgotPasswordVerificationOTP(
                                                email: _emailController.text);
                                        String code = result['code'];
                                        if (code == '2000') {
                                          if (!isOTPSent) {
                                            setState(() {
                                              isOTPSent = true;
                                            });
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('${result['message']}'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: FittedBox(
                                      alignment: Alignment.center,
                                      fit: BoxFit.fitWidth,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 2,
                                        ),
                                        child: Text(
                                          'Send OTP',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.1,
                                  child: TextButton(
                                    onPressed: () async {
                                      if (EmailValidator.validate(
                                          _emailController.text)) {
                                        Map<String, dynamic> result = await api
                                            .sendForgotPasswordVerificationOTP(
                                                email: _emailController.text);
                                        String code = result['code'];
                                        if (code == '2000') {
                                          if (!isOTPSent) {
                                            setState(() {
                                              isOTPSent = true;
                                            });
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('${result['message']}'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: FittedBox(
                                      alignment: Alignment.center,
                                      fit: BoxFit.fitWidth,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 2,
                                        ),
                                        child: Text(
                                          'Resend OTP',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //====OTP====
                            Container(
                              height: constraints.maxHeight * 0.2,
                              alignment: Alignment.center,
                              child: TextFormField(
                                enabled: isOTPSent ? true : false,
                                controller: _otpController,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter otp';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "OTP",
                                  prefixIcon: Icon(
                                    FontAwesomeIcons.key,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            // Container(
                            //   alignment: Alignment.centerRight,
                            //   height: constraints.maxHeight * 0.1,
                            //   child: TextButton(
                            //     onPressed: () {
                            //       if (!isOTPVerified) {
                            //         setState(() {
                            //           isOTPVerified = true;
                            //         });
                            //       }
                            //     },
                            //     child: FittedBox(
                            //       alignment: Alignment.center,
                            //       fit: BoxFit.fitWidth,
                            //       child: Padding(
                            //         padding: EdgeInsets.symmetric(
                            //           vertical: 2,
                            //         ),
                            //         child: Text(
                            //           'Verify OTP',
                            //           style: TextStyle(
                            //             fontSize: 15,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            //====PASSWORD====
                            Container(
                              height: constraints.maxHeight * 0.2,
                              alignment: Alignment.center,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: isPasswordVisible,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password cannot be empty';
                                  } else if (value.length < 8) {
                                    return "Password must be atleast 8 characters long";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  prefixIcon: Icon(
                                    FontAwesomeIcons.lock,
                                    color: Colors.black,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      (!isPasswordVisible)
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            //====CONFIRM PASSWORD====
                            Container(
                              height: constraints.maxHeight * 0.2,
                              alignment: Alignment.center,
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: isPasswordVisible,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Password cannot be empty";
                                  } else if (value !=
                                      _passwordController.text) {
                                    return "Passwords do not match";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  prefixIcon: Icon(
                                    FontAwesomeIcons.lock,
                                    color: Colors.black,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      (!isPasswordVisible)
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(
                                        () {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.2,
                  ),
                  height: height * 0.05,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> result =
                            await api.resetPasswordAndVerifyOTP(
                                email: _emailController.text,
                                password: _passwordController.text,
                                otp: int.parse(_otpController.text));
                        String code = result['code'];
                        if (code == '2000') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Passwor Reset Successfully"),
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${result['message']}"),
                            ),
                          );
                        }
                      }
                    },
                    child: FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.fitWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 2,
                        ),
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 80,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
