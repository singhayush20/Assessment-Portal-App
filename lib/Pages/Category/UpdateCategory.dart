import 'package:assessmentportal/Service/CateogoryService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UpdateCategory extends StatefulWidget {
  String token;
  String title, descp;
  int id;

  UpdateCategory(
      {required this.token,
      required this.title,
      required this.descp,
      required this.id});

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descpController = TextEditingController();
  @override
  void initState() {
    setState(() {
      _titleController.text = widget.title;
      _descpController.text = widget.descp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Update Category',
        ),
      ),
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
              height: height * 0.05,
              alignment: Alignment.centerLeft,
              child: Text(
                'Edit the details and click update',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
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
              height: height * 0.2,
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE0EAE5),
                border: Border.all(
                    color: Colors.black, width: 0.5, style: BorderStyle.solid),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: constraints.maxHeight * 0.4,
                          child: TextFormField(
                            controller: _titleController,
                            obscureText: false,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Title cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "Title",
                              prefixIcon: Icon(
                                FontAwesomeIcons.heading,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: constraints.maxHeight * 0.4,
                          child: TextFormField(
                            maxLines: 2,
                            controller: _descpController,
                            obscureText: false,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Description cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "Description",
                              prefixIcon: Icon(
                                FontAwesomeIcons.circleInfo,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
                    String code = await categoryService.updateQuiz(
                      token: widget.token,
                      title: _titleController.text.trim(),
                      description: _descpController.text.trim(),
                      categoryId: widget.id,
                    );
                    if (code == '2000') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Category updated successfully'),
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Category not updated'),
                        ),
                      );
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
    );
  }
}
