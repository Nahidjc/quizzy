import 'dart:convert';
import 'package:quizzy/models/stage_model.dart';
import 'package:quizzy/token/token_manager.dart';

import 'app_url.dart';
import 'package:http/http.dart' as http;

class StageList {
  Future<List<StageData>> fetchStage(String userid, String subjectId) async {
    final url = Uri.parse('${AppUrl.baseUrl}/level/$subjectId');
    String? authToken = await TokenManager.getToken();
    final headers = {'token': authToken!, 'userid': userid};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var stageDataResponse = StageDataResponse.fromJson(jsonData);
      List<StageData> stages = stageDataResponse.data;
      return stages;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future subscribeStage(String userId, String stageId) async {
    final url = Uri.parse('${AppUrl.baseUrl}/stage/subscribe');
    String? authToken = await TokenManager.getToken();
    final body = {'userId': userId, 'stageId': stageId};
    final headers = {'Content-Type': 'application/json', 'token': authToken!};

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        // Successful API call
        print("Subscription successful!");
        print(response.body);
        // You can handle the response data here if needed
      }
    } catch (e) {
      throw Exception('Failed to load data from API');
    }
  }
}
