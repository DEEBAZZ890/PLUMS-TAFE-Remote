import 'package:flutter/material.dart';
import 'package:plums/questions_model.dart';
import 'package:provider/provider.dart';
import 'quiz_model.dart'; // Ensure this is correctly imported
import 'questions_page.dart'; // Import QuestionsPage

class QuizPage extends StatelessWidget {
  final int courseId;
  final String courseName;

  const QuizPage({Key? key, required this.courseId, required this.courseName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$courseName Quiz')),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          // Trigger data fetch
          if (quizProvider.currentQuiz == null && !quizProvider.isLoading) {
            Future.microtask(() => quizProvider.fetchQuiz(courseId));
          }

          // Check if data is still loading
          if (quizProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if data is available
          if (quizProvider.currentQuiz != null) {
            return QuizContent(quizProvider: quizProvider);
          }

          // Display message when data is not available
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class QuizContent extends StatelessWidget {
  final QuizProvider quizProvider;

  const QuizContent({Key? key, required this.quizProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Total Questions: ${quizProvider.currentQuiz?.totalQuestions ?? 0}',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (quizProvider.currentQuiz != null) {
                await context
                    .read<QuestionProvider>()
                    .fetchQuestions(quizProvider.currentQuiz!.id);
                // ignore: use_build_context_synchronously
                if (context.read<QuestionProvider>().questions.isNotEmpty) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuestionsPage(
                        quizId: quizProvider.currentQuiz!.id,
                        quizTitle: quizProvider.currentQuiz!.title,
                        questions: context.read<QuestionProvider>().questions,
                      ),
                    ),
                  );
                } else {
                  // Handle case where no questions are fetched
                  print("No questions fetched");
                }
              }
            },
            child: const Text('Begin'),
          ),
        ],
      ),
    );
  }
}
