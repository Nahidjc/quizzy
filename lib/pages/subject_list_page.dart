import 'package:flutter/material.dart';
import 'package:quizzy/components/custom_drawer.dart';
import 'package:quizzy/components/info_message.dart';
import 'package:quizzy/models/level_model.dart';
import 'package:quizzy/pages/quiz_level.dart';

class SubjectList extends StatelessWidget {
  final List<dynamic> subjectList;
  final String displayName;
  const SubjectList(
      {super.key, required this.subjectList, required this.displayName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 80.0,
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 144, 106, 250),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [Container()],
            title: Text(displayName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold))),
        body: subjectList.isNotEmpty
            ? ListView.builder(
                itemCount: subjectList.length,
                itemBuilder: (context, index) {
                  Subject subject = subjectList[index];
                  return Card(
                    margin: const EdgeInsets.all(5.0),
                    color: Colors.white,
                    child: ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizLevelList(
                              subjectName: subject.subjectName,
                              displayName: displayName,
                              subjectId: subject.id),
                        ),
                      ),
                      title: Text(
                        subject.subjectName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                    ),
                  );
                },
              )
            : InfoMessage('No data available for $displayName'),
        endDrawer: const CustomDrawer(),
      // bottomNavigationBar: const BottomNav()
    );
  }
}
