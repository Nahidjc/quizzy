import 'dart:convert';
import 'package:quizzy/models/quiz_model.dart';
import 'package:quizzy/token/token_manager.dart';

import 'app_url.dart';
import 'package:http/http.dart' as http;

class QuizApi {
  Future<List<QuizData>> fetchQuiz(String stageId, String subjectId) async {
    final url =
        Uri.parse('${AppUrl.baseUrl}/quiz/subject/$subjectId/level/$stageId');
    String? authToken = await TokenManager.getToken();
    final headers = {
      'stageid': stageId,
      'subjectid': subjectId,
      'token': authToken!
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var quizModelData = QuizModel.fromJson(jsonData);
      List<QuizData> quizzes = quizModelData.data;
      return quizzes;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<List<Question>> fetchRandomQuestions(String subject) async {
    final url = Uri.parse('${AppUrl.baseUrl}/quiz/questions/$subject/random');
    final headers = {'subject': subject};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var questionList = jsonData['data'] as List;
      var questions =
          questionList.map((data) => Question.fromJson(data)).toList();
      return questions;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<void> attemptQuiz(String quizId, String userId, int point) async {
    final url = Uri.parse('${AppUrl.baseUrl}/quiz/$quizId/attempt');
    String? authToken = await TokenManager.getToken();
    await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'token': authToken!},
      body: json.encode(
        {
          'quizId': quizId,
          'userId': userId,
          'point': point,
        },
      ),
    );
  }
}
