class Leaderboard {
  final int totalPoints;
  final String userId;
  final String name;

  Leaderboard({
    required this.totalPoints,
    required this.userId,
    required this.name,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      totalPoints: json['totalPoints'] as int,
      userId: json['userId'] as String,
      name: json['name'] as String,
    );
  }
}


class CampaignUserLeaderboard {
  final int totalPoints;
  final String name;
  final String? profileUrl; // Make profileUrl nullable
  final String userId;

  CampaignUserLeaderboard({
    required this.totalPoints,
    required this.name,
    this.profileUrl,
    required this.userId,
  });

  factory CampaignUserLeaderboard.fromJson(Map<String, dynamic> json) {
    return CampaignUserLeaderboard(
      totalPoints: json['totalPoints'],
      name: json['name'],
      profileUrl: json['profileUrl'], // No need for default value since it's nullable
      userId: json['userId'],
    );
  }
}