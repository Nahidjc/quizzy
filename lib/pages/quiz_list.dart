import 'package:flutter/material.dart';
import 'package:quizzy/api_caller/quiz.dart';
import 'package:quizzy/components/custom_drawer.dart';
import 'package:quizzy/models/quiz_model.dart';
import 'package:quizzy/pages/quiz_details.dart';
import 'package:breadcrumbs/breadcrumbs.dart';

class ListTable {
  final String title;
  final void Function(BuildContext) onTap;

  const ListTable({
    required this.title,
    required this.onTap,
  });
}

class QuizList extends StatefulWidget {
  final String displayName;
  final String subjectName;
  final String levelName;
  final String subjectId;
  final String stageId;

  const QuizList({
    Key? key,
    required this.displayName,
    required this.subjectName,
    required this.levelName,
    required this.subjectId,
    required this.stageId,
  }) : super(key: key);

  @override
  State<QuizList> createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  List<QuizData> quizzes = [];
  @override
  void initState() {
    super.initState();
    fetchQuizData();
  }

  bool isLoading = false;
  Future<void> fetchQuizData() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuizApi quizApi = QuizApi();
      var quizData = await quizApi.fetchQuiz(widget.stageId, widget.subjectId);
      setState(() {
        isLoading = false;
      });
      setState(() {
        quizzes = quizData;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.0,
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 144, 106, 250),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Breadcrumbs(
            crumbs: [
              TextSpan(text: widget.displayName),
              TextSpan(text: widget.subjectName),
              TextSpan(text: widget.levelName),
            ],
            separator: ' > ',
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          actions: [Container()],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : quizzes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sentiment_dissatisfied,
                          color: Colors.deepOrange,
                          size: 72,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Oops!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "We're sorry, but there are no quizzes available for this subject and level at the moment.",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: fetchQuizData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Text(
                            "Refresh",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: quizzes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(5.0),
                        color: Colors.white,
                        child: ListTile(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizDetails(quiz: quizzes[index]),
                          ),
                        ),
                          title: Text(
                            quizzes[index].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        endDrawer: const CustomDrawer(),
      // bottomNavigationBar: const BottomNav()
    );
  }
}
