import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Course {
  final int id; // Add an integer field for the ID
  final String name, description, level;
  final bool isPublished;

  Course(this.id, this.name, this.description, this.level,
      this.isPublished); // Include ID in constructor
}

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  final String _accessToken; // Field to store the access token

  CourseProvider(this._accessToken); // Constructor accepting the token

  List<Course> get courses => _courses;

  Future<void> fetchCourses() async {
    var url = 'http://192.168.15.6:8000/api/courses';

    try {
      Map<String, String> headers = {
        'Authorization':
            'Bearer $_accessToken', // Use the provided access token
        'Content-Type': 'application/json'
      };

      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 429) {
        // Handle rate limit error
        print('Rate limit exceeded. Please try again later.');
        // Show an error message to the user or implement a retry mechanism
      } else if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['data'] != null) {
          List<Course> loadedCourses = [];
          for (var c in jsonData['data']['data']) {
            Course course = Course(c['id'], c['name'], c['description'],
                c['level'], c['is_published'] == 1);

            loadedCourses.add(course);
          }

          _courses = loadedCourses;
          notifyListeners();
        } else {
          // Handle the case where the data is not successfully retrieved.
          print("Failed to retrieve courses. Message: ${jsonData['message']}");
        }
      } else {
        // Handle other types of errors
        print(
            'Error: Server responded with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }
}
