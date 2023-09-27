import 'package:http/http.dart';
import 'package:quizzy/api_caller/app_url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransferCoinAPI {
  Future<Response> transferCoin(
    String transferToEmail,
    String jwtToken,
    num transferAmount,
  ) async {
    final url = Uri.parse('${AppUrl.baseUrl}/user/coin/transfer');
    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': jwtToken,
      },
      body: json.encode(
        {
          'email': transferToEmail,
          'coin': transferAmount,
        },
      ),
    );
  }
}
