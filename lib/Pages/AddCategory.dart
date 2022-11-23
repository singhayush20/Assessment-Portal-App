import 'package:assessmentportal/AppConstants/constants.dart';
import 'package:assessmentportal/Service/CateogoryService.dart';
import 'package:assessmentportal/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descpritionController = TextEditingController();
  final AppBar appBar = AppBar(
    title: Text('Add a new Category'),
  );
  late UserProvider _userProvider;
  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);

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
            Container(
              alignment: Alignment.center,
              height: height * 0.3,
              child: ClipRRect(
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(
                //     20,
                //   ),
                //   topRight: Radius.circular(
                //     20,
                //   ),
                // ),
                child: Image.asset(
                  'images/category_default.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: height * 0.05,
              child: Text(
                'Fill the details and click Add',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              height: height * 0.2,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    20,
                  ),
                  topRight: Radius.circular(
                    0,
                  ),
                  bottomLeft: Radius.circular(
                    0,
                  ),
                  bottomRight: Radius.circular(
                    20,
                  ),
                ),
                color: Color(0xFFC8E8A2),
              ),
              child: Form(
                key: _formKey,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
                        ),
                        //====Title====
                        Container(
                          alignment: Alignment.center,
                          height: constraints.maxHeight * 0.4,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: 0.5,
                                style: BorderStyle.solid),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(
                                20,
                              ),
                              topRight: Radius.circular(
                                0,
                              ),
                              bottomLeft: Radius.circular(
                                0,
                              ),
                              bottomRight: Radius.circular(
                                20,
                              ),
                            ),
                            color: Color(0xFFC8E8A2),
                          ),
                          child: TextFormField(
                            controller: _titleController,
                            obscureText: false,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Title cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "Title",
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                FontAwesomeIcons.heading,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.1,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: constraints.maxHeight * 0.4,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: 0.5,
                                style: BorderStyle.solid),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(
                                20,
                              ),
                              topRight: Radius.circular(
                                0,
                              ),
                              bottomLeft: Radius.circular(
                                0,
                              ),
                              bottomRight: Radius.circular(
                                20,
                              ),
                            ),
                            color: Color(0xFFC8E8A2),
                          ),
                          child: TextFormField(
                            controller: _descpritionController,
                            obscureText: false,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Description cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "Description",
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                FontAwesomeIcons.noteSticky,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
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
                    CategoryService categoryService = CategoryService();
                    String code = await categoryService.addNewCategory(
                        title: _titleController.text,
                        descp: _descpritionController.text,
                        token: _userProvider.sharedPreferences!
                                .getString(BEARER_TOKEN) ??
                            'null',
                        adminId: _userProvider.user!.userId);
                    if (code == "2000") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Category Added Successfully'),
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Category could not be created'),
                        ),
                      );
                      // }
                    }
                  }
                },
                child: const FittedBox(
                  child: Text(
                    'Add Category',
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
