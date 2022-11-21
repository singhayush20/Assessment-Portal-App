import 'package:assessmentportal/Register%20and%20Login/LoginPage.dart';
import 'package:assessmentportal/Service/UserService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterDetails extends StatefulWidget {
  String? email;
  RegisterDetails({required String email}) {
    this.email = email;
  }

  @override
  State<RegisterDetails> createState() => _RegisterDetailsState();
}

class _RegisterDetailsState extends State<RegisterDetails> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool isPasswordVisible = true;

  String? userRole;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),
        child: Column(
          children: [
            Container(
              height: height * 0.2,
              child: FittedBox(
                child: Text(
                  "User Details",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(
              height: height * 0.5,
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.lightGreen,
              ),
              child: Form(
                key: _formKey,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        //====NAME====
                        Container(
                          alignment: Alignment.center,
                          height: constraints.maxHeight * 0.2,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: constraints.maxHeight * 0.2,
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    obscureText: false,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'First Name cannot be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "First Name",
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.person,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: constraints.maxHeight * 0.2,
                                  child: TextFormField(
                                    controller: _lastNameController,
                                    obscureText: false,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      // if (value!.isEmpty) {
                                      //   return 'Last Name cannot be empty';
                                      // } else {
                                      //   return null;
                                      // }
                                      //last name can be empty
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Last Name",
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.person,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //====USERNAME====
                        Container(
                          height: constraints.maxHeight * 0.2,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _usernameController,
                                  obscureText: false,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Username cannot be empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Username",
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.circleUser,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          'Account Type',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.bottomLeft,
                                              child: RadioListTile(
                                                title: Text("Admin"),
                                                value: "ADMIN",
                                                groupValue: userRole,
                                                onChanged: (value) {
                                                  setState(() {
                                                    userRole = value.toString();
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.bottomLeft,
                                              child: RadioListTile(
                                                title: Text("Student"),
                                                value: "STUDENT",
                                                groupValue: userRole,
                                                onChanged: (value) {
                                                  setState(() {
                                                    userRole = value.toString();
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
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
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password cannot be empty";
                              } else if (value != _passwordController.text) {
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
                                      isPasswordVisible = !isPasswordVisible;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        //====PHONE NUMBER====
                        Container(
                          height: constraints.maxHeight * 0.2,
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: _phoneController,
                            obscureText: false,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.length < 10) {
                                return "Invalid phone number";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: "Phone Number",
                              prefixIcon: Icon(
                                FontAwesomeIcons.phone,
                                color: Colors.black,
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
              height: height * 0.1,
            ),
            Container(
              height: height * 0.05,
              width: width * 0.5,
              child: ElevatedButton(
                onPressed: () async {
                  //save the details to the database
                  if (_formKey.currentState!.validate() && userRole != null) {
                    final UserService userService = UserService();
                    Map<String, dynamic> result = await userService.saveUser(
                      _firstNameController.text,
                      _lastNameController.text,
                      widget.email!,
                      _passwordController.text,
                      _phoneController.text,
                      _usernameController.text,
                      userRole!,
                    );
                    String code = result['code'];
                    if (code == "2000") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Registration Successful!'),
                        ),
                      );
                      Navigator.popUntil(context, (route) => false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    } else if (code == '2002') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${result['message']}'),
                        ),
                      );
                    }
                  } else if (userRole == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Select the account type!'),
                      ),
                    );
                  }
                },
                child: Text(
                  'Submit Details',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
