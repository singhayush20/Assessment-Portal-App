import 'dart:developer';

import 'package:assessmentportal/DataModel/CategoryModel.dart';
import 'package:assessmentportal/Pages/QuizListPage.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  int index;
  CategoryModel category;
  CategoryTile({required this.index, required this.category});

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
                                      } else if (value == 1) {}
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
