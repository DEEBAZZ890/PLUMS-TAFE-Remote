import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_sign_up_model.dart'; // Import your UserSignUpModel
import 'courses_page.dart'; // Import CoursesPage

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      _showDialog('Error', 'Passwords do not match');
      return;
    }

    String responseMessage =
        await Provider.of<UserSignUpModel>(context, listen: false)
            .signUp(name, email, password);

    print('Response Message: $responseMessage'); // Debugging statement

    if (Provider.of<UserSignUpModel>(context, listen: false).isRegistered) {
      _showDialog('Success', responseMessage, onSuccess: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CoursesPage()));
      });
    } else {
      _showDialog('Error', responseMessage);
    }
  }

  void _showDialog(String title, String message, {VoidCallback? onSuccess}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                if (onSuccess != null) {
                  onSuccess();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _nameController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  labelText: 'Name',
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                  border: Theme.of(context).inputDecorationTheme.border,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  labelText: 'Email',
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                  border: Theme.of(context).inputDecorationTheme.border,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  labelText: 'Password',
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                  border: Theme.of(context).inputDecorationTheme.border,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  labelText: 'Confirm Password',
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                  border: Theme.of(context).inputDecorationTheme.border,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Button shape
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                  ),
                  child: const Text(
                    'SIGN UP',
                    style: TextStyle(color: Colors.white), // Text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
