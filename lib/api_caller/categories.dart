import 'dart:convert';
import 'app_url.dart';
import 'package:http/http.dart' as http;
import 'package:quizzy/models/level_model.dart';

class CategoryList {
  Future<List<dynamic>> fetchData() async {
    final url = Uri.parse('${AppUrl.baseUrl}/level/all');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var quizLevelResponse = QuizLevelResponse.fromJson(data);
      List<QuizLevel> levels = quizLevelResponse.data;
      return levels;
    } else {
      throw Exception('Failed to load data from API');
    }
  }
}
