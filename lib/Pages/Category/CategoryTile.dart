import 'dart:developer';

import 'package:assessmentportal/DataModel/CategoryModel.dart';
import 'package:assessmentportal/Pages/Quiz/QuizListPage.dart';
import 'package:assessmentportal/Pages/Category/UpdateCategory.dart';
import 'package:assessmentportal/Service/CateogoryService.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  int index;
  CategoryModel category;
  String token;
  CategoryTile(
      {required this.index, required this.category, required this.token});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: InkWell(
            onTap: () {
              log('Opening category $category ');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizListPage(
                    category: category,
                  ),
                ),
              );
            },
            child: Material(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Colors.lightGreenAccent,
                ),
                alignment: Alignment.center,
                child: LayoutBuilder(
                  builder: (context, size) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: size.maxHeight * 0.7,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  20,
                                ),
                                topRight: Radius.circular(
                                  20,
                                ),
                              ),
                              color: Colors.lightGreen,
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(
                                      20,
                                    ),
                                    topRight: Radius.circular(
                                      20,
                                    ),
                                  ),
                                  child: Image.asset(
                                    'images/category_default.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    'Category id: ${category.categoryId}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: PopupMenuButton(
                                    // add icon, by default "3 dot" icon
                                    // icon: Icon(Icons.book)
                                    itemBuilder: (context) {
                                      return [
                                        const PopupMenuItem<int>(
                                          value: 0,
                                          child: Text("Delete"),
                                        ),
                                        // PopupMenuItem<int>(
                                        //   value: 1,
                                        //   child: Switch.adaptive(
                                        //       activeColor: Colors.blueGrey.shade600,
                                        //       activeTrackColor: Colors.grey.shade400,
                                        //       inactiveThumbColor:
                                        //       Colors.blueGrey.shade600,
                                        //       inactiveTrackColor: Colors.grey.shade400,
                                        //       splashRadius: 50.0,
                                        //       value: _isQuizActive,
                                        //       onChanged: (value) {
                                        //         setState(() {
                                        //           _isQuizActive = value;
                                        //         });
                                        //       }),
                                        // ),
                                        const PopupMenuItem<int>(
                                          value: 1,
                                          child: Text("Update"),
                                        ),
                                      ];
                                    },
                                    onSelected: (value) async {
                                      if (value == 0) {
                                        //delete category
                                        CategoryService categoryService =
                                            CategoryService();
                                        String code = await categoryService
                                            .deleteCategory(
                                                token: token,
                                                categoryId:
                                                    category.categoryId);
                                        if (code == '2000') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Category deleted successfully'),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('Category not deleted'),
                                            ),
                                          );
                                        }
                                      } else if (value == 1) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateCategory(
                                              token: token,
                                              title: category.categoryTitle,
                                              descp: category.categoryDescp,
                                              id: category.categoryId,
                                            ),
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
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          height: size.maxHeight * 0.3,
                          child: Text(
                            '${category.categoryTitle}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
