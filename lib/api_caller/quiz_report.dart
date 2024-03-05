import 'dart:convert';
import 'app_url.dart';
import 'package:http/http.dart' as http;

class QuestionFeedback {
  static Future<void> submitQuestionReport(
      String questionId, String reportText, String jwtToken) async {
    final url =
        Uri.parse('${AppUrl.baseUrl}/question/$questionId/issue-report');
    final headers = {
      'Content-Type': 'application/json',
      'token': jwtToken,
    };

    final body = jsonEncode({
      'description': reportText,
    });

    try {
      await http.post(url, headers: headers, body: body);
    } catch (error) {
      throw Exception('Failed to report question');
    }
  }
}
