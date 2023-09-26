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
      String campaignId, String studentid) async {
    final url = Uri.parse('${AppUrl.baseUrl}/quiz/campaign-quiz');
    final headers = {
      'campaignid': campaignId,
      'studentid': studentid,
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
  Future<List<CampaignModel>> getCampaignUpcomingQuiz(
      String campaignId, String studentid) async {
    final url = Uri.parse('${AppUrl.baseUrl}/quiz/campaign/upcoming-quiz');
    final headers = {
      'campaignid': campaignId,
      'studentid': studentid,
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

  Future<List<CampaignModel>> getCampaignRunningQuiz(
      String campaignId, String studentid) async {
    final url = Uri.parse('${AppUrl.baseUrl}/quiz/campaign/running-quiz');
    final headers = {
      'campaignid': campaignId,
      'studentid': studentid,
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

  Future<List<CampaignModel>> getCampaignClosedQuiz(
      String campaignId, String studentid) async {
    final url = Uri.parse('${AppUrl.baseUrl}/quiz/campaign/closed-quiz');
    final headers = {
      'campaignid': campaignId,
      'studentid': studentid,
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

  Future<void> attemptCampaignQuiz(String campaign, String quizId,
      String userId, int point, List selectedAnswers) async {
    final url = Uri.parse('${AppUrl.baseUrl}/quiz/attempt/campaign');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          'campaign': campaign,
          'quizId': quizId,
          'userId': userId,
          'point': point,
          'selectedAnswers': selectedAnswers
        },
      ),
    );
  }
}
