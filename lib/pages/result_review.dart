import 'package:flutter/material.dart';
import 'package:quizzy/components/custom_drawer.dart';
import 'package:quizzy/components/review/multple_answer_result.dart';
import 'package:quizzy/components/review/single_answer_result.dart';

class ResultReviewPage extends StatefulWidget {
  final List<Map<String, dynamic>> quizData;
  final List<dynamic> selectedAnswers;

  const ResultReviewPage({
    Key? key,
    required this.quizData,
    required this.selectedAnswers,
  }) : super(key: key);

  @override
  State<ResultReviewPage> createState() => _ResultReviewPageState();
}

class _ResultReviewPageState extends State<ResultReviewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Result Review'),
          actions: [Container()],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (int i = 0; i < widget.quizData.length; i++)
                Column(
                  children: [
                    if (widget.quizData[i].containsKey('correctAnswer'))
                      SingleCorrectAnswerWidget(
                        questionIndex: i + 1,
                        question: widget.quizData[i]['question'] as String,
                        options: widget.quizData[i]['options'] as List<String>,
                        correctAnswer:
                            widget.quizData[i]['correctAnswer'] as int,
                        selectedAnswer: widget.selectedAnswers[i],
                      ),
                    if (widget.quizData[i].containsKey('correctAnswers'))
                      MultipleCorrectAnswerWidget(
                        questionIndex: i + 1,
                        question: widget.quizData[i]['question'] as String,
                        options: widget.quizData[i]['options'] as List<String>,
                        correctAnswers:
                            widget.quizData[i]['correctAnswers'] as List<int>,
                        selectedAnswers:
                            (widget.selectedAnswers[i] as List<dynamic>)
                                .cast<int>(),
                      ),
                  ],
                ),
            ],
          ),
        ),
        endDrawer: const CustomDrawer());
  }
}
