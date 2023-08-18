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
  final String firstName;
  final String? profileUrl;
  final int coin;

  TokenModel({
    required this.id,
    required this.firstName,
    this.profileUrl,
    required this.coin,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      id: json['id'],
      firstName: json['firstName'],
      profileUrl: json['profileUrl'],
      coin: json['coin'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'profileUrl': profileUrl,
      'coin': coin,
    };
  }
}
