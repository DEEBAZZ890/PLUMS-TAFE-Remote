import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserAuthModel with ChangeNotifier {
  bool _isLoggedIn = false;
  String _accessToken = ''; // Variable to store the authentication token

  bool get isLoggedIn => _isLoggedIn;
  String get accessToken => _accessToken; // Getter for the access token

  Future<void> login(String email, String password) async {
    const url =
        'http://192.168.15.6:8000/api/login'; // Adjust the URL as necessary

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _isLoggedIn = true;
        _accessToken =
            responseData['data']['access_token']; // Store the access token
        notifyListeners();
      } else {
        // Handle error response
        print('Login failed: ${responseData['message']}');
      }
    } catch (error) {
      // Handle any other errors
      print('Error occurred during login: $error');
    }
  }
}
