import 'dart:convert';

class JwtTokenUtil {
  static Map<String, dynamic> decryptJwtToken(String jwtToken) {
    final parts = jwtToken.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT token format');
    }
    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return json.decode(payload);
  }
}

class TokenModel {
  final String id;
  final String name;
  final String? profileUrl;
  final int coin;

  TokenModel({
    required this.id,
    required this.name,
    this.profileUrl,
    required this.coin,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      id: json['id'],
      name: json['name'],
      profileUrl: json['profileUrl'],
      coin: json['coin'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileUrl': profileUrl,
      'coin': coin,
    };
  }
}
