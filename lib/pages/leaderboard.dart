import 'package:flutter/material.dart';
import 'package:quizzy/api_caller/leaderboard.dart';
import 'package:quizzy/configs/variables.dart';
import 'package:quizzy/models/leaderboard.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});
  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<dynamic> dailyLeaderboard = [];
  List<dynamic> weeklyLeaderboard = [];
  List<dynamic> allTimeLeaderboard = [];
  late List<dynamic> currentLeaderboardData;
  bool showTodayLeaderboard = true;
  bool showWeeklyLeaderboard = false;
  bool isLoading = false;
  String todayRewardText =
      'Daily leaderboard rewards: 1st place gets 50 coins, 2nd place earns 30 coins, and 3rd place receives 20 coins.';
  String weeklyRewardText =
      'Weekly leaderboard rewards: 1st place gets 200 coins, 2nd place earns 100 coins, and 3rd place receives 50 coins.';

  @override
  void initState() {
    super.initState();
    fetchDailyLeaderboardData();
    currentLeaderboardData = dailyLeaderboard;
  }

  Future<void> fetchDailyLeaderboardData() async {
    setState(() {
      isLoading = true;
    });
    LeaderboardAPi leaderboardApi = LeaderboardAPi();
    dailyLeaderboard = await leaderboardApi.getDailyLeaderboard();
    currentLeaderboardData = dailyLeaderboard;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchWeeklyLeaderboardData() async {
    setState(() {
      isLoading = true;
    });
    LeaderboardAPi leaderboardApi = LeaderboardAPi();
    weeklyLeaderboard = await leaderboardApi.getWeeklyLeaderboard();
    currentLeaderboardData = weeklyLeaderboard;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchAllTimeLeaderboardData() async {
    setState(() {
      isLoading = true;
    });
    LeaderboardAPi leaderboardApi = LeaderboardAPi();
    allTimeLeaderboard = await leaderboardApi.getAllTimeLeaderboard();
    currentLeaderboardData = allTimeLeaderboard;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Leaderboard",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Variables.primaryColor,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Variables.primaryColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                showTodayLeaderboard ? todayRewardText : weeklyRewardText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLeaderboardOption('Today', showTodayLeaderboard),
                  const SizedBox(width: 10),
                  _buildLeaderboardOption('Weekly', showWeeklyLeaderboard),
                  const SizedBox(width: 10),
                  _buildLeaderboardOption('All Time',
                      !showTodayLeaderboard && !showWeeklyLeaderboard),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: isLoading
                      ? _buildSkeletonLoader()
                      : _buildTopPerformers(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardOption(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showTodayLeaderboard = title == 'Today';
          showWeeklyLeaderboard = title == 'Weekly';
          if (showTodayLeaderboard) {
            fetchDailyLeaderboardData();
          } else if (showWeeklyLeaderboard) {
            fetchWeeklyLeaderboardData();
          } else {
            fetchAllTimeLeaderboardData();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Variables.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Variables.primaryColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTopPerformers() {
    if (currentLeaderboardData.isEmpty) {
      return Center(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Variables.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blueGrey[600],
                  size: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  'No quiz attempts have been made yet. It\'s a great opportunity to challenge yourself and test your knowledge.',
                  style: TextStyle(
                    fontSize: 18, // Set font size to medium
                    color: Colors.blueGrey[600],
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      );
    } else {
      return Column(
        children: currentLeaderboardData
            .sublist(0, currentLeaderboardData.length)
            .asMap()
            .entries
            .map((entry) => _buildTopPerformerRow(entry.value, entry.key + 1))
            .toList(),
      );
    }
  }

  Widget _buildTopPerformerRow(Leaderboard entry, int position) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Variables.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  entry.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${entry.totalPoints} Points',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Variables.secondaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$position${_getOrdinalIndicator(position)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Column(
      children: List.generate(
        5,
        (index) => Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }

  String _getOrdinalIndicator(int number) {
    if (number % 10 == 1 && number % 100 != 11) {
      return 'st';
    } else if (number % 10 == 2 && number % 100 != 12) {
      return 'nd';
    } else if (number % 10 == 3 && number % 100 != 13) {
      return 'rd';
    } else {
      return 'th';
    }
  }
}

class LeaderboardEntry {
  final String name;
  final int points;

  LeaderboardEntry({
    required this.name,
    required this.points,
  });
}
