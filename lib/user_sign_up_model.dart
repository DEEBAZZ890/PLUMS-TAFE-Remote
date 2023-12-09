import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserSignUpModel with ChangeNotifier {
  bool _isRegistered = false;

  bool get isRegistered => _isRegistered;

  Future<String> signUp(String name, String email, String password) async {
    const url =
        'http://192.168.15.6:8000/api/login'; // Adjust the URL as necessary 192.168.15.6
    String message = "";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );

      final responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        _isRegistered = true;
        message = responseData['message'] ?? "Account created successfully";
      } else {
        _isRegistered = false;
        message = responseData['data']['email'][0] ?? "Unknown error occurred";
      }
    } catch (error) {
      _isRegistered = false;
      message = 'Error occurred during sign-up: ${error.toString()}';
    }

    notifyListeners();
    return message;
  }
}
