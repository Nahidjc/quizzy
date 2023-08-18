import 'dart:convert';
import 'package:quizzy/models/leaderboard.dart';

import 'app_url.dart';
import 'package:http/http.dart' as http;

class LeaderboardAPi {
  Future<List<Leaderboard>> getDailyLeaderboard() async {
    try {
      final url = Uri.parse('${AppUrl.baseUrl}/user/today/leaderboard');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<dynamic> dailyData = jsonData['data'];
        var dailyLeaderboard =
            dailyData.map((data) => Leaderboard.fromJson(data)).toList();
        return dailyLeaderboard;
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Leaderboard>> getWeeklyLeaderboard() async {
    try {
      final url = Uri.parse('${AppUrl.baseUrl}/user/weekly/leaderboard');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<dynamic> weeklyData = jsonData['data'];
        var weeklyLeaderboard =
            weeklyData.map((data) => Leaderboard.fromJson(data)).toList();
        return weeklyLeaderboard;
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Leaderboard>> getAllTimeLeaderboard() async {
    try {
      final url = Uri.parse('${AppUrl.baseUrl}/user/alltime/leaderboard');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<dynamic> weeklyData = jsonData['data'];
        var weeklyLeaderboard =
            weeklyData.map((data) => Leaderboard.fromJson(data)).toList();
        return weeklyLeaderboard;
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<CampaignUserLeaderboard>> getCampaignLeaderboard() async {
    try {
      final url = Uri.parse('${AppUrl.baseUrl}/quiz/campaign/leaderboard');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<dynamic> campaignData = jsonData['data'];
        var campaignLeaderboard = campaignData
            .map((data) => CampaignUserLeaderboard.fromJson(data))
            .toList();
        return campaignLeaderboard;
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
