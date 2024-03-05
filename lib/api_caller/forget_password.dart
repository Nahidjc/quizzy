import 'dart:convert';
import 'app_url.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordInitiate {
  Future<void> initiateForgotPassword(String email) async {
    final url = Uri.parse('${AppUrl.baseUrl}/setting/forgot-password/initiate');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({'email': email});
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Forgot password initiation successful');
    } else {
      print(
          'Failed to initiate forgot password. Status code: ${response.statusCode}');
    }
  }

  Future<String> confirmForgotPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final url = Uri.parse('${AppUrl.baseUrl}/setting/forgot-password/confirm');
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'email': email,
      'code': code,
      'newPassword': newPassword,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Failed to confirm forgot password. Status code: ${response.body}');
      throw Exception('Failed to confirm forgot password');
    }
  }
}
