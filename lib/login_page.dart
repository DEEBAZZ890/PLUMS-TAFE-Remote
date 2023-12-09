import 'package:flutter/material.dart';
import 'package:plums/user_auth_model.dart';
import 'package:provider/provider.dart';
import 'courses_page.dart'; // Import CoursesPage
import 'sign_up_page.dart'; // Import SignUpPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late UserAuthModel _authModel;

  @override
  void initState() {
    super.initState();
    _authModel = Provider.of<UserAuthModel>(context, listen: false);
    _authModel.addListener(_authListener);
  }

  @override
  void deactivate() {
    super.deactivate();
    _authModel.removeListener(_authListener);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _authListener() {
    // Check the login status and navigate if logged in and if the widget is still in the tree
    if (Provider.of<UserAuthModel>(context, listen: false).isLoggedIn &&
        mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const CoursesPage()),
      );
    }
  }

  void _navigateToSignUp() {
    // Navigate to the Sign-Up Page
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo above the email field
              Transform.scale(
                scale: 0.75, // Scale factor for making the image half its size
                child: Image.asset(
                    'assets/Logo.png'), // Replace with the correct asset path
              ),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.grey),
                  hintText: 'user123@email.com',
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16), // Spacing between fields
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24), // Spacing before the login button
              SizedBox(
                width: double.infinity, // Make the button as wide as possible
                child: ElevatedButton(
                  onPressed: () {
                    // Implement your login logic here
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    Provider.of<UserAuthModel>(context, listen: false)
                        .login(email, password);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Button shape
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                  ),
                  child: const Text(
                    'LOG IN',
                    style: TextStyle(color: Colors.white), // Text color
                  ),
                ),
              ),
              TextButton(
                onPressed: _navigateToSignUp,
                child: const Text(
                  'Don’t have an account? Sign up',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
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
