import 'package:flutter/material.dart';
import 'package:quizzy/pages/quiz_report/quiz_report_page.dart';

class PracticeMultipleCorrectAnswerWidget extends StatelessWidget {
  final int questionIndex;
  final String question;
  final String questionId;
  final List<String> options;
  final List<int> correctAnswers;

  const PracticeMultipleCorrectAnswerWidget({
    Key? key,
    required this.questionIndex,
    required this.question,
    required this.questionId,
    required this.options,
    required this.correctAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question $questionIndex',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionReportScreen(
                        question: question,
                        questionId: questionId,
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.report,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: List.generate(options.length, (optionIndex) {
              final option = options[optionIndex];
              // final isCorrectedOption = _isCorrectAnswer(optionIndex);

              return InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getOptionColor(option),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getOptionBorderColor(option),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  bool _isCorrectAnswer(int optionIndex) {
    return correctAnswers.contains(optionIndex);
  }

  Color? _getOptionColor(option) {
    if (_isCorrectAnswer(options.indexOf(option))) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  Color _getOptionBorderColor(option) {
    return _isCorrectAnswer(options.indexOf(option))
        ? Colors.green[300]!
        : _getOptionColor(option) ?? Colors.grey[300]!;
  }

  // IconData? _getOptionIcon(bool isCorrectedOption, bool isSelected) {
  //   if (isCorrectedOption) {
  //     return Icons.check;
  //   } else if (isSelected) {
  //     return Icons.close;
  //   } else {
  //     return null;
  //   }
  // }

  // Color? _getOptionIconColor(bool isCorrectedOption) {
  //   if (isCorrectedOption) {
  //     return Colors.green;
  //   } else {
  //     return Colors.white;
  //   }
  // }
}
