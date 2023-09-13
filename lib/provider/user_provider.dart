import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:quizzy/api_caller/app_url.dart';
import 'package:quizzy/models/user_data_model.dart';

class UserProvider extends ChangeNotifier {
  UserDataModel? _userDetails;
  UserDataModel? get userDetails => _userDetails;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<UserDataModel> fetchUserDetailsById(String userId) async {
    final url = Uri.parse('${AppUrl.baseUrl}/user/details');
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.get(url, headers: {'userid': userId});
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        final user = UserDataModel.fromJson(data['data']);
        _isLoading = false;
        _userDetails = user;
        notifyListeners();
        return user;
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUserProfile({
    String? name,
    String? lastName,
    String? mobileNumber,
    String? profilePicPath,
    String? userId,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      final url = Uri.parse('${AppUrl.baseUrl}/user/update/$userId');
      final request = http.MultipartRequest('POST', url);
      request.fields['name'] = name ?? '';
      request.fields['lastName'] = lastName ?? '';
      request.fields['mobileNumber'] = mobileNumber ?? '';
      if (profilePicPath != null) {
        final fileBytes = await File(profilePicPath).readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'image',
          fileBytes,
          filename: profilePicPath.split('/').last,
        );
        request.files.add(multipartFile);
      }
      final response = await request.send();
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUserData() {
    _userDetails = null;
    notifyListeners();
  }
}
