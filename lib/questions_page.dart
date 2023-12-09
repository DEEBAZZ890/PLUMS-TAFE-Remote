import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart'; // Add this line for firstWhereOrNull
import 'questions_model.dart'; // Ensure this model is correctly defined

class QuestionsPage extends StatefulWidget {
  final int quizId;
  final String quizTitle;
  final List<Question> questions;

  const QuestionsPage({
    super.key,
    required this.quizId,
    required this.quizTitle,
    required this.questions,
  });

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  int currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {};
  bool _quizCompleted = false;
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    if (_quizCompleted) {
      return _buildResultsScreen();
    }

    if (widget.questions.isEmpty ||
        currentQuestionIndex >= widget.questions.length) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.quizTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    Question currentQuestion = widget.questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Question ${currentQuestionIndex + 1} of ${widget.questions.length}'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      currentQuestion.content,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildAnswerSection(currentQuestion),
                  ],
                ),
              ),
            ),
          ),
          _buildNavigationButton(),
        ],
      ),
    );
  }

  Widget _buildAnswerSection(Question question) {
    switch (question.type) {
      case 'multiple_choice':
        return _buildMultipleChoice(question.answers, question.id);
      case 'true_false':
        return _buildTrueFalse(question.answers, question.id);
      case 'short_answer':
        return _buildShortAnswer();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMultipleChoice(List<Answer> answers, int questionId) {
    return Column(
      children: answers.map((answer) {
        return RadioListTile<int>(
          title: Text(answer.content),
          value: answer.id,
          groupValue: _selectedAnswers[questionId],
          onChanged: (int? value) => _onAnswerChanged(value, questionId),
        );
      }).toList(),
    );
  }

  Widget _buildTrueFalse(List<Answer> answers, int questionId) {
    _selectedAnswers[questionId] ??= answers.first.id;

    return Column(
      children: answers.map((answer) {
        return RadioListTile<int>(
          title: Text(answer.content),
          value: answer.id,
          groupValue: _selectedAnswers[questionId],
          onChanged: (int? value) => _onAnswerChanged(value, questionId),
        );
      }).toList(),
    );
  }

  Widget _buildShortAnswer() {
    return const TextField(
      decoration: InputDecoration(
        labelText: 'Your Answer',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildNavigationButton() {
    String buttonText = currentQuestionIndex < widget.questions.length - 1
        ? 'Next'
        : 'Complete';

    return SizedBox(
      width: double.infinity, // Makes the button span the whole width
      child: ElevatedButton(
        onPressed: () {
          if (currentQuestionIndex < widget.questions.length - 1) {
            setState(() {
              currentQuestionIndex++;
            });
          } else {
            setState(() {
              _calculateResults();
              _quizCompleted = true;
            });
          }
        },
        child: Text(
          buttonText,
          style: const TextStyle(color: Colors.white), // White text color
        ),
      ),
    );
  }

  void _onAnswerChanged(int? value, int questionId) {
    if (value != null) {
      setState(() {
        _selectedAnswers[questionId] = value;
      });
    }
  }

  void _calculateResults() {
    _score = 0;
    for (var i = 0; i < widget.questions.length; i++) {
      Question question = widget.questions[i];
      int? selectedAnswerId = _selectedAnswers[question.id];
      Answer? selectedAnswer =
          question.answers.firstWhereOrNull((a) => a.id == selectedAnswerId);
      if (selectedAnswer != null && selectedAnswer.isCorrect) {
        _score++;
      }
    }
  }

  Widget _buildResultsScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Quiz Completed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Score: $_score/${widget.questions.length}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 40,
              width: 200,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Return to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
