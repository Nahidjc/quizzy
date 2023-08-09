import 'dart:convert';
import 'package:quizzy/models/campaign.dart';
import 'package:quizzy/models/campaign_quiz.dart';

import 'app_url.dart';
import 'package:http/http.dart' as http;

class CampaignApi {
  Future<Campaign> getCampaign() async {
    final url = Uri.parse('${AppUrl.baseUrl}/quiz/campaign/current');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      Map<String, dynamic> data = responseData['data'];

      Campaign campaign = Campaign.fromJson(data);
      return campaign;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<List<CampaignModel>> getCampaignQuiz(
      String campaignId, String userId) async {
    final url = Uri.parse('${AppUrl.baseUrl}/quiz/campaign-quiz');
    final headers = {
      'campaignid': campaignId,
      'userid': userId,
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> parsedData = responseData['data'];
      return parsedData.map((quiz) => CampaignModel.fromJson(quiz)).toList();
    } else {
      throw Exception('Failed to load data from API');
    }
  }
}
