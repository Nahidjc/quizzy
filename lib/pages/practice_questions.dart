import 'package:flutter/material.dart';
import 'package:quizzy/components/practice/practice_multple_answer_result.dart';
import 'package:quizzy/components/practice/practice_single_answer_result.dart';
import 'package:quizzy/models/quiz_convert.dart';
import 'package:quizzy/models/quiz_model.dart';

class PracticeQuestionPage extends StatefulWidget {
  final QuizData quiz;
  const PracticeQuestionPage({Key? key, required this.quiz}) : super(key: key);

  @override
  State<PracticeQuestionPage> createState() => _PracticeQuestionPageState();
}

class _PracticeQuestionPageState extends State<PracticeQuestionPage> {
  List<Map<String, dynamic>> quizData = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      quizData = convertToQuizData(widget.quiz.questions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Related Questions for Practice",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        elevation: 4, 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (int i = 0; i < quizData.length; i++)
              Column(
                children: [
                  if (quizData[i].containsKey('correctAnswer'))
                    PracticeSingleCorrectAnswerWidget(
                      questionIndex: i + 1,
                        question: quizData[i]['question'] as String,
                        options: quizData[i]['options'] as List<String>,
                        correctAnswer: quizData[i]['correctAnswer'] as int
                    ),
                  if (quizData[i].containsKey('correctAnswers'))
                    PracticeMultipleCorrectAnswerWidget(
                      questionIndex: i + 1,
                      question: quizData[i]['question'] as String,
                      options: quizData[i]['options'] as List<String>,
                      correctAnswers:
                          quizData[i]['correctAnswers'] as List<int>,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
