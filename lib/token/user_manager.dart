import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static const String _nameKey = 'userName';
  static const String _userIdKey = 'userId';
  static const String _coinKey = 'userCoin';
  static const String _profileUrlKey = 'userProfileUrl';

  // Save user data to shared preferences
  static Future<void> saveUserData(
      String name, String userId, int coin, String profileUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_userIdKey, userId);
    await prefs.setInt(_coinKey, coin);
    await prefs.setString(_profileUrlKey, profileUrl);
  }

  // Retrieve user data from shared preferences
  static Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString(_nameKey);
    String? userId = prefs.getString(_userIdKey);
    int? coin = prefs.getInt(_coinKey);
    String? profileUrl = prefs.getString(_profileUrlKey);
    return {
      'name': name,
      'userId': userId,
      'coin': coin,
      'profileUrl': profileUrl,
    };
  }

  static Future<void> deleteUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_coinKey);
    await prefs.remove(_profileUrlKey);
  }
}
