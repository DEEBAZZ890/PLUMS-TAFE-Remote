import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plums/questions_model.dart';
import 'package:provider/provider.dart';
import 'course_model.dart';
import 'courses_page.dart';
import 'login_page.dart';
import 'user_auth_model.dart'; // Import your UserAuthModel
import 'user_sign_up_model.dart'; // Import your UserSignUpModel
import 'quiz_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserAuthModel>(create: (_) => UserAuthModel()),
        ChangeNotifierProvider<UserSignUpModel>(
            create: (_) => UserSignUpModel()),
        ChangeNotifierProvider(
            create: (context) => CourseProvider(
                Provider.of<UserAuthModel>(context, listen: false)
                    .accessToken)),
        ChangeNotifierProvider(
            create: (context) => QuestionProvider(
                Provider.of<UserAuthModel>(context, listen: false)
                    .accessToken)),

        ChangeNotifierProvider(
            create: (context) => QuizProvider(
                Provider.of<UserAuthModel>(context, listen: false)
                    .accessToken)), // QuizProvider with access token
        // Add other providers if needed
      ],
      child: MaterialApp(
          title: 'Plums',
          theme: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              labelStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
            ),

            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Button shape
                ),
                padding: const EdgeInsets.symmetric(vertical: 20.0),
              ),
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.black),
            ),
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(background: Colors.white),
            // Add other theme properties if needed
          ),
          home: const SplashScreen(), // Your SplashScreen
          debugShowCheckedModeBanner: false),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Check if the user is logged in
      final isLoggedIn =
          Provider.of<UserAuthModel>(context, listen: false).isLoggedIn;

      // Navigate based on the login status
      if (isLoggedIn) {
        // If logged in, navigate to the CategoriesPage
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CoursesPage()));
      } else {
        // If not logged in, navigate to the LoginPage
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple, // Adjust the color as needed
      body: Center(
        child: Image.asset('assets/Logo.png'), // Replace with your logo's path
      ),
    );
  }
}
