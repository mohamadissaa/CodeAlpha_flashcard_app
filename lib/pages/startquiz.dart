import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:math';

class StartQuizScreen extends StatefulWidget {
  @override
  _StartQuizScreenState createState() => _StartQuizScreenState();
}

class _StartQuizScreenState extends State<StartQuizScreen> {
  final _answerController = TextEditingController();
  List<Map<String, String>> _flashcards = [];
  int _currentFlashcardIndex = 0;
  int _correctAnswers = 0;
  bool _quizCompleted = false;

  @override
  void initState() {
    Hive.openBox('quiz_scores');
    super.initState();
    final flashcardBox = Hive.box('flashcards');
    _flashcards = flashcardBox.values.map((flashcard) {
      return Map<String, String>.from(flashcard);
    }).toList();
    _flashcards.shuffle(Random());
  }

  // Save the score to Hive when the quiz is completed
  void _saveScore(int score, int totalQuestions) async {
    final scoreBox = Hive.box('quiz_scores');
    final quizResult = {
      'date': DateTime.now().toString(),
      'score': score.toString(),
      'total': totalQuestions.toString(),
    };
    scoreBox.add(quizResult); // Store the score as a Map
  }

  void _checkAnswer() {
    final String userAnswer = _answerController.text.trim();
    final String correctAnswer = _flashcards[_currentFlashcardIndex]['answer']!.trim();

    if (userAnswer.toLowerCase() == correctAnswer.toLowerCase()) {
      _correctAnswers++;
    }

    _answerController.clear();

    if (_currentFlashcardIndex < _flashcards.length - 1) {
      setState(() {
        _currentFlashcardIndex++;
      });
    } else {
      setState(() {
        _quizCompleted = true;
        _saveScore(_correctAnswers, _flashcards.length); // Save the score
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Mode'),
        backgroundColor: Colors.blueAccent.shade700,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _quizCompleted ? _buildQuizResults() : _buildQuizQuestion(),
      ),
    );
  }

  Widget _buildQuizQuestion() {
    return Column(
      children: <Widget>[
        Text(
          'Question ${_currentFlashcardIndex + 1} of ${_flashcards.length}',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 20),
        Text(
          _flashcards[_currentFlashcardIndex]['question']!,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: _answerController,
          decoration: InputDecoration(
            labelText: 'Your Answer',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _checkAnswer,
          child: Text('Submit Answer'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent.shade700,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
          ),
        ),
      ],
    );
  }

  Widget _buildQuizResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Quiz Completed!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent.shade700,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'You answered $_correctAnswers out of ${_flashcards.length} correctly.',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _flashcards.shuffle(Random());
                _currentFlashcardIndex = 0;
                _correctAnswers = 0;
                _quizCompleted = false;
              });
            },
            child: Text('Restart Quiz'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent.shade700,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Back to Home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.shade700,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }
}
