import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Answer {
  final int id;
  final int questionId;
  final String content;
  final bool isCorrect;

  Answer({
    required this.id,
    required this.questionId,
    required this.content,
    required this.isCorrect,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      questionId: json['question_id'],
      content: json['content'],
      isCorrect: json['is_correct'] == 1,
    );
  }
}

class Question {
  final int id;
  final int quizId;
  final String content;
  final String type;
  final int points;
  List<Answer> answers = [];

  Question({
    required this.id,
    required this.quizId,
    required this.content,
    required this.type,
    required this.points,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      quizId: json['quiz_id'],
      content: json['content'],
      type: json['type'],
      points: json['points'],
      answers: [], // Initially empty
    );
  }
}

class QuestionProvider with ChangeNotifier {
  List<Question> _questions = [];
  bool _isLoading = false;
  final String accessToken;

  List<Question> get questions => _questions;
  bool get isLoading => _isLoading;

  QuestionProvider(this.accessToken);

  Future<void> fetchQuestions(int quizId) async {
    _isLoading = true;
    notifyListeners();

    final questionsUrl =
        'http://192.168.15.6:8000/api/quizzes/$quizId/questions';

    try {
      var response = await http.get(
        Uri.parse(questionsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['data'] != null) {
          List<dynamic> questionsJson = data['data'];
          _questions =
              questionsJson.map((json) => Question.fromJson(json)).toList();

          for (var question in _questions) {
            await fetchAnswersForQuestion(question);
          }

          print("Fetched questions: $_questions");
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching questions: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAnswersForQuestion(Question question) async {
    final answersUrl =
        'http://192.168.15.6:8000/api/questions/${question.id}/answers';

    try {
      var response = await http.get(
        Uri.parse(answersUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['data'] != null) {
          List<dynamic> answersJson = data['data'];
          question.answers =
              answersJson.map((json) => Answer.fromJson(json)).toList();
        }
      } else {
        print(
            'Error fetching answers for question ${question.id}: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching answers for question ${question.id}: $error');
    }
  }
}
