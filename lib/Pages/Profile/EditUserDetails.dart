import 'dart:developer';

import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class EditUserDetails extends StatefulWidget {
  @override
  State<EditUserDetails> createState() => _EditUserDetailsState();
}

class _EditUserDetailsState extends State<EditUserDetails> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();

  final _phoneController = TextEditingController();
  bool _isFirstBuild = true;
  late UserProvider _userProvider;
  AppBar appBar = AppBar(
    title: const Text('Edit Profile'),
  );
  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    if (_isFirstBuild == true) {
      _isFirstBuild = false;
      _firstNameController.text = _userProvider.user!.firstName;
      _lastNameController.text = _userProvider.user!.lastName;
      _usernameController.text = _userProvider.user!.userName;
      _phoneController.text = _userProvider.user!.phoneNumber;
      log("phone number: ${_userProvider.user!.phoneNumber}");
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: LoaderOverlay(
        overlayWholeScreen: false,
        overlayHeight: height,
        overlayWidth: width,
        overlayColor: Colors.white,
        useDefaultLoading: false,
        overlayWidget: Center(
          child: SizedBox(
            height: height * 0.1,
            width: width * 0.15,
            child: DataLoadingIndicator(),
          ),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: width * 0.08,
          ),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                alignment: Alignment.center,
                height: height * 0.2,
                child: FittedBox(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: ClipOval(
                      child: Image.asset('images/DefaultProfileImage.jpg'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                height: height * 0.1,
                child: const Text(
                  "Re-enter the details you want to change and then click update",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                height: height * 0.4,
                // margin: EdgeInsets.symmetric(
                //   horizontal: 10,
                // ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0EAE5),
                  border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                      style: BorderStyle.solid),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                const SizedBox(
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
                            child: Expanded(
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
                height: height * 0.05,
              ),
              Container(
                height: height * 0.05,
                width: width * 0.5,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      context.loaderOverlay.show();
                      String code = await _userProvider.updateUserDetails(
                        _userProvider.user!.userId,
                        _firstNameController.text,
                        _lastNameController.text,
                        _userProvider.user!.email,
                        _userProvider.user!.password,
                        _phoneController.text,
                        _usernameController.text,
                        _userProvider.user!.profile,
                        _userProvider.user!.roles,
                      );
                      context.loaderOverlay.hide();
                      if (code == "2000") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User updated successfully!'),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User could not be updated'),
                          ),
                        );
                        // }
                      }
                    }
                  },
                  child: const FittedBox(
                    child: Text(
                      'Update',
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
