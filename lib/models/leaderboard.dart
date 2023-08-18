class Leaderboard {
  final int totalPoints;
  final String userId;
  final String firstName;

  Leaderboard({
    required this.totalPoints,
    required this.userId,
    required this.firstName,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      totalPoints: json['totalPoints'] as int,
      userId: json['userId'] as String,
      firstName: json['firstName'] as String,
    );
  }
}


class CampaignUserLeaderboard {
  final int totalPoints;
  final String firstName;
  final String? profileUrl; // Make profileUrl nullable
  final String userId;

  CampaignUserLeaderboard({
    required this.totalPoints,
    required this.firstName,
    this.profileUrl,
    required this.userId,
  });

  factory CampaignUserLeaderboard.fromJson(Map<String, dynamic> json) {
    return CampaignUserLeaderboard(
      totalPoints: json['totalPoints'],
      firstName: json['firstName'],
      profileUrl: json['profileUrl'], // No need for default value since it's nullable
      userId: json['userId'],
    );
  }
}