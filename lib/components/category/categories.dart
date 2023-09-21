import 'package:flutter/material.dart';
import 'package:quizzy/configs/variables.dart';
import 'package:quizzy/pages/subject_list_page.dart';
import 'package:quizzy/models/level_model.dart';

class Categories extends StatelessWidget {
  final List<dynamic> categoryList;

  const Categories({super.key, required this.categoryList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: categoryList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 22.0,
          mainAxisSpacing: 22.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          QuizLevel category = categoryList[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubjectList(
                    subjectList: category.subjectList,
                    displayName: category.displayName),
              ),
            ),
            child: Container(
              decoration: gradientBoxDecoration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.school,
                    size: 40.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8.0),
                  Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double fontSize = constraints.maxWidth * 0.10;
                        return Text(
                          category.displayName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(1, 1),
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

final gradientBoxDecoration = BoxDecoration(
  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7953E1),
      Color.fromRGBO(141, 105, 240, 0.79),
    ],
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp,
    transform: GradientRotation(230.54 * (3.14159265359 / 180.0)),
  ),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Variables.primaryColor.withOpacity(.3),
      spreadRadius: 2,
      blurRadius: 5,
      offset: const Offset(0, 3),
    ),
  ],
);
