import 'package:flashcard_quiz/pages/addflashcard.dart';
import 'package:flashcard_quiz/pages/startquiz.dart';
import 'package:flashcard_quiz/pages/viewscore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('flashcards');
  await Hive.openBox('quiz_scores');

  runApp(FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashcard Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Uniform button color
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade700,
        title: Text('Flashcard Quiz App', style: TextStyle(fontSize: 24)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildMenuButton(context, 'Add Flashcards', Icons.add, AddFlashcardScreen()),
            SizedBox(height: 20),
            _buildQuizButton(context),
            SizedBox(height: 20),
            _buildScoreButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String label, IconData icon, Widget targetPage) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      icon: Icon(icon, size: 28),
      label: Text(label, style: TextStyle(fontSize: 18,color: Colors.white),),
    );
  }

  // Button to start the quiz (checks if flashcards exist)
  Widget _buildQuizButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final flashcardBox = Hive.box('flashcards');
        if (flashcardBox.isEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('No Flashcards Available'),
              content: Text('Please add some flashcards before starting the quiz.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StartQuizScreen()),
          );
        }
      },
      icon: Icon(Icons.play_arrow, size: 28),
      label: Text('Start Quiz', style: TextStyle(fontSize: 18,color: Colors.white)),
    );
  }

  // Button to view score history (checks if any scores exist)
  Widget _buildScoreButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final scoreBox = Hive.box('quiz_scores');
        if (scoreBox.isEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('No Scores Available'),
              content: Text('You haven\'t taken any quizzes yet.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScoreHistoryScreen()),
          );
        }
      },
      icon: Icon(Icons.score, size: 28),
      label: Text('View Scores', style: TextStyle(fontSize: 18,color: Colors.white)),
    );
  }
}
