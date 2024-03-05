// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quizzy/api_caller/quiz_report.dart';
import 'package:quizzy/configs/variables.dart';
import 'package:quizzy/token/token_manager.dart';

class QuestionReportScreen extends StatefulWidget {
  final String question;
  final String questionId;

  const QuestionReportScreen({
    Key? key,
    required this.question,
    required this.questionId,
  }) : super(key: key);

  @override
  QuestionReportScreenState createState() => QuestionReportScreenState();
}

class QuestionReportScreenState extends State<QuestionReportScreen> {
  bool isLoading = false;

  final TextEditingController _reportController = TextEditingController();
  void handleSubmitQuestionReport() async {
    String reportText = _reportController.text;
    String? jwtToken = await TokenManager.getToken();

    try {
      setState(() {
        isLoading = true;
      });
      await QuestionFeedback.submitQuestionReport(
          widget.questionId, reportText, jwtToken!);
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Your issue report have been accepted.');
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context);
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: 'Failed to report question',
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question: ${widget.question}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _reportController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Enter your report here...',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),

            // Report Button
            ElevatedButton(
              onPressed: handleSubmitQuestionReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: Variables.primaryColor,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text('Report',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }
}
