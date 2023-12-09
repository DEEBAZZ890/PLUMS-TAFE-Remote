import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_model.dart'; // Import your CourseProvider
import 'quiz_page.dart'; // Import your QuizPage

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  int _pointers = 0;
  DateTime? _initialPressTime;

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Courses")),
      body: OrientationBuilder(
        builder: (context, orientation) {
          bool isLandscape = orientation == Orientation.landscape;

          return Listener(
            onPointerDown: (PointerDownEvent event) {
              _pointers++;
              if (_pointers == 2) {
                _initialPressTime = DateTime.now();
              }
            },
            onPointerUp: (PointerUpEvent event) {
              _pointers--;
              if (_pointers == 0 && _initialPressTime != null) {
                final duration = DateTime.now().difference(_initialPressTime!);
                if (duration >= const Duration(seconds: 1)) {
                  _showContactPopup(context);
                }
              }
            },
            child: FutureBuilder(
              future: courseProvider.fetchCourses(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.black)),
                  );
                } else if (snapshot.hasData && courseProvider.courses.isEmpty) {
                  return const Center(
                      child: Text("No courses available.",
                          style: TextStyle(color: Colors.black)));
                } else {
                  return isLandscape
                      ? _buildLandscapeLayout(courseProvider)
                      : _buildPortraitLayout(courseProvider);
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLandscapeLayout(CourseProvider courseProvider) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4 / 3,
      ),
      itemCount: courseProvider.courses.length,
      itemBuilder: (ctx, i) => _buildCourseCard(courseProvider, i),
    );
  }

  Widget _buildPortraitLayout(CourseProvider courseProvider) {
    return ListView.builder(
      itemCount: courseProvider.courses.length,
      itemBuilder: (ctx, i) => _buildCourseCard(courseProvider, i),
    );
  }

  Widget _buildCourseCard(CourseProvider courseProvider, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.purple, width: 2),
      ),
      elevation: 4,
      shadowColor: Colors.purple.withOpacity(0.5),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(
                courseId: courseProvider.courses[index].id,
                courseName: courseProvider.courses[index].name,
              ),
            ),
          );
        },
        child: ListTile(
          title: Text(courseProvider.courses[index].name,
              style: const TextStyle(color: Colors.black)),
          subtitle: Text(courseProvider.courses[index].description,
              style: const TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  void _showContactPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () => _makePhoneCall('1300300822'),
                child: const Text('1300 300 822',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline)),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _sendEmail('enquiry@nmtafe.wa.edu.au'),
                child: const Text('enquiry@nmtafe.wa.edu.au',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline)),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _openTelegram('m.me/northmetrotafe'),
                child: const Text('m.me/northmetrotafe',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline)),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _openBrowser(
                    'https://www.northmetrotafe.wa.edu.au/courses'),
                child: const Text('www.northmetrotafe.wa.edu.au',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _makePhoneCall(String phoneNumber) {
    // Implement function to make a phone call
  }

  void _sendEmail(String emailAddress) {
    // Implement function to send an email
  }

  void _openTelegram(String telegramId) {
    // Implement function to open Telegram
  }

  void _openBrowser(String url) {
    // Implement function to open a browser
  }
}
