import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddFlashcardScreen extends StatefulWidget {
  @override
  _AddFlashcardScreenState createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  // Open the Hive box
  final flashcardBox = Hive.box('flashcards');

  // Function to handle adding a flashcard
  void _addFlashcard() {
    final String question = _questionController.text.trim();
    final String answer = _answerController.text.trim();

    if (question.isNotEmpty && answer.isNotEmpty) {
      // Save the flashcard in Hive
      flashcardBox.add({'question': question, 'answer': answer});

      // Clear the text fields
      _questionController.clear();
      _answerController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Flashcard Added!'),
          backgroundColor: Colors.greenAccent.shade700,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both a question and an answer.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Flashcard',style: TextStyle(color: Colors.white),),
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
        child: Column(
          children: <Widget>[
            // Input fields for question and answer
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                labelText: 'Answer',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addFlashcard,
              child: Text('Save Flashcard',style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent.shade700,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                shadowColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            // Display flashcards stored in Hive
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: flashcardBox.listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return Center(child: Text('No flashcards added yet.'));
                  } else {
                    return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        var flashcard = box.getAt(index);
                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            title: Text(
                              flashcard['question'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                flashcard['answer'],
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
