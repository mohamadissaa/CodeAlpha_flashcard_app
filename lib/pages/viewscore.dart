import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ScoreHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scoreBox = Hive.box('quiz_scores');

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Score History'),
        backgroundColor: Colors.blueAccent.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: scoreBox.listenable(),
          builder: (context, Box box, _) {
            if (box.isEmpty) {
              return _buildNoScoresWidget();
            }

            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final quizResult = box.getAt(index);
                final score = quizResult['score'];
                final total = quizResult['total'];
                final date = quizResult['date'];

                // Formatting the date for better readability
                final formattedDate = DateFormat('MMM dd, yyyy - HH:mm').format(DateTime.parse(date));

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    title: Text(
                      'Score: $score / $total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      'Date: $formattedDate',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    trailing: Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent.shade700,
                      size: 30,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Widget to display if no scores are recorded
  Widget _buildNoScoresWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.history_toggle_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 20),
          Text(
            'No scores recorded yet.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
