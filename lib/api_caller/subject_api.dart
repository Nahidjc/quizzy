import 'dart:convert';
import 'package:quizzy/models/subject_model.dart';
import 'app_url.dart';
import 'package:http/http.dart' as http;

class SubjectListAPi {
  Future<List<Subject>> fetchData(String token, String categoryId) async {
    final url = Uri.parse('${AppUrl.baseUrl}/subject/category/$categoryId');
    final headers = {
      'token': token,
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];
      List<Subject> subjects =
          data.map((json) => Subject.fromJson(json)).toList();
      return subjects;
    } else {
      throw Exception('Failed to load data from API');
    }
  }
}
