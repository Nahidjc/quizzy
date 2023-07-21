import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});
  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<LeaderboardEntry> todayLeaderboardData = [
    LeaderboardEntry(
      profilePic: 'assets/images/avatar.png',
      name: 'John Doe',
      points: 250,
    ),
    LeaderboardEntry(
      profilePic: 'assets/images/avatar.png',
      name: 'Jane Smith',
      points: 200,
    ),
    LeaderboardEntry(
      profilePic: 'assets/images/avatar.png',
      name: 'David Johnson',
      points: 180,
    ),
  ];

  List<LeaderboardEntry> weeklyLeaderboardData = [
    LeaderboardEntry(
      profilePic: 'assets/images/avatar.png',
      name: 'Emily Brown',
      points: 300,
    ),
    LeaderboardEntry(
      profilePic: 'assets/images/avatar.png',
      name: 'Michael Wilson',
      points: 280,
    ),
    LeaderboardEntry(
      profilePic: 'assets/images/avatar.png',
      name: 'Sarah Davis',
      points: 260,
    ),
    LeaderboardEntry(
      profilePic: 'assets/images/avatar.png',
      name: 'John Smith',
      points: 240,
    ),
    LeaderboardEntry(
      profilePic: 'assets/images/avatar.png',
      name: 'Jennifer Johnson',
      points: 220,
    ),
    LeaderboardEntry(
      profilePic: 'assets/images/avatar.png',
      name: 'David Brown',
      points: 200,
    ),
    LeaderboardEntry(
      profilePic: 'assets/images/avatar.png',
      name: 'Jessica Taylor',
      points: 180,
    ),
    LeaderboardEntry(
      profilePic: 'assets/images/avatar.png',
      name: 'Andrew Davis',
      points: 160,
    ),
    LeaderboardEntry(
      profilePic: 'assets/images/avatar.png',
      name: 'Sophia Wilson',
      points: 140,
    ),
    LeaderboardEntry(
      profilePic: 'assets/images/avatar.png',
      name: 'James Smith',
      points: 120,
    ),
  ];

  late List<LeaderboardEntry> currentLeaderboardData;
  bool showTodayLeaderboard = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentLeaderboardData = todayLeaderboardData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLeaderboardOption('Today', showTodayLeaderboard),
                  const SizedBox(width: 10),
                  _buildLeaderboardOption('Weekly', !showTodayLeaderboard),
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
          currentLeaderboardData = showTodayLeaderboard
              ? todayLeaderboardData
              : weeklyLeaderboardData;
          isLoading = true;
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              isLoading = false;
            });
          });
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.blue,
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
    return Column(
      children: currentLeaderboardData
          .sublist(0, currentLeaderboardData.length)
          .asMap()
          .entries
          .map((entry) => _buildTopPerformerRow(entry.value, entry.key + 1))
          .toList(),
    );
  }

  Widget _buildTopPerformerRow(LeaderboardEntry entry, int position) {
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
              radius: 20,
              backgroundImage: AssetImage(entry.profilePic),
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
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${entry.points} Points',
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
  final String profilePic;
  final String name;
  final int points;

  LeaderboardEntry({
    required this.profilePic,
    required this.name,
    required this.points,
  });
}