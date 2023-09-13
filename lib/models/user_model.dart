class UserDetails {
  final String token;
  final String name;
  final int coin;
  final String id;
  final String? profileUrl;

  UserDetails({
    required this.token,
    required this.name,
    required this.coin,
    required this.id,
    this.profileUrl,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      token: json['token'],
      name: json['name'],
      coin: json['coin'],
      id: json['id'],
      profileUrl: json['profileUrl'],
    );
  }
}

class UserData {
  int coin;
  String id;
  String name;
  String message;
  String? profileUrl;

  UserData({
    required this.coin,
    required this.id,
    required this.name,
    required this.message,
    this.profileUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      coin: json['data']['coin'] as int,
      id: json['data']['id'] as String,
      name: json['data']['name'] as String,
      message: json['message'] as String,
      profileUrl: json['data']['profileUrl'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'coin': coin,
        'id': id,
        'name': name,
        'profileUrl': profileUrl,
      },
      'message': message,
    };
  }
}
