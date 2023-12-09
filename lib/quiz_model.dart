import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Quiz {
  final int id;
  final String title;
  final int totalQuestions;

  Quiz({required this.id, required this.title, required this.totalQuestions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      totalQuestions: json['total_questions'],
    );
  }
}

class QuizProvider with ChangeNotifier {
  Quiz? _currentQuiz;
  bool _isLoading = false;
  final String _accessToken;

  QuizProvider(this._accessToken);

  Quiz? get currentQuiz => _currentQuiz;
  bool get isLoading => _isLoading;

  Future<void> fetchQuiz(int courseId) async {
    _isLoading = true;
    notifyListeners();

    var url = 'http://192.168.15.6:8000/api/quizzes/$courseId';
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json'
    });

    _isLoading = false;
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['success'] == true && jsonData['data'] != null) {
        _currentQuiz = Quiz.fromJson(jsonData['data']);
      }
    }
    notifyListeners();
  }
}
