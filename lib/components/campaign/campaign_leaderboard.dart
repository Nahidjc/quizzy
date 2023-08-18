import 'package:flutter/material.dart';
import 'package:quizzy/api_caller/leaderboard.dart';
import 'package:quizzy/models/leaderboard.dart';

class CampaignLeaderboardPage extends StatefulWidget {
  const CampaignLeaderboardPage({Key? key}) : super(key: key);

  @override
  State<CampaignLeaderboardPage> createState() =>
      _CampaignLeaderboardPageState();
}

class _CampaignLeaderboardPageState extends State<CampaignLeaderboardPage> {
  List<dynamic> campaignLeaderboardData = [];
  late List<dynamic> currentLeaderboardData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCampaignLeaderboardData();
  }

  Future<void> fetchCampaignLeaderboardData() async {
    setState(() {
      isLoading = true;
    });
    LeaderboardAPi leaderboardApi = LeaderboardAPi();
    campaignLeaderboardData = await leaderboardApi.getCampaignLeaderboard();
    currentLeaderboardData = campaignLeaderboardData;
    setState(() {
      isLoading = false;
    });
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

  Widget _buildTopPerformerRow(CampaignUserLeaderboard entry, int position) {
    ImageProvider<Object>? backgroundImage;
    if (entry.profileUrl == null) {
      backgroundImage = const AssetImage("assets/images/avatar.png");
    } else {
      backgroundImage = NetworkImage(entry.profileUrl!);
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
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
            width: 60,
            height: 60,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 15,
              backgroundImage: backgroundImage,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  entry.firstName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${entry.totalPoints} Points',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
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
              color: Colors.blue,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Campaign Leaderboard",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: isLoading
                      ? _buildSkeletonLoader()
                      : Column(
                          children: currentLeaderboardData
                              .asMap()
                              .entries
                              .map((entry) => _buildTopPerformerRow(
                                  entry.value, entry.key + 1))
                              .toList(),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CampaignLeaderboardEntry {
  final String firstName;
  final int totalPoints;
  final String? profileUrl;
  final String userId;

  CampaignLeaderboardEntry({
    required this.firstName,
    required this.totalPoints,
    this.profileUrl,
    required this.userId,
  });
}