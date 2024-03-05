import 'package:flutter/material.dart';
import 'package:quizzy/pages/quiz_report/quiz_report_page.dart';

class PracticeSingleCorrectAnswerWidget extends StatelessWidget {
  final int questionIndex;
  final String question;
  final List<String> options;
  final String questionId;
  final int correctAnswer;

  const PracticeSingleCorrectAnswerWidget(
      {Key? key,
      required this.questionIndex,
      required this.question,
      required this.questionId,
      required this.options,
      required this.correctAnswer})
      : super(key: key);

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
              final isCorrectedOption = correctAnswer == optionIndex;

              return InkWell(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCorrectedOption
                          ? Colors.green[300]!
                          : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isCorrectedOption ? Icons.check : null,
                        color: isCorrectedOption ? Colors.green : Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isCorrectedOption ? Colors.green : Colors.black,
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
}
