import 'package:flutter/material.dart';

void main() {
  runApp(FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz',
      theme: ThemeData.dark(),
      home: FlashcardHomePage(),
    );
  }
}

class FlashcardHomePage extends StatefulWidget {
  @override
  _FlashcardHomePageState createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage> {
  List<Flashcard> flashcards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard Quiz'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _navigateToAddFlashcardScreen(context);
              },
              child: Text('Add Flashcard'),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: flashcards.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(flashcards[index].question),
                    subtitle: Text(flashcards[index].answer),
                    onTap: () {
                      _startQuiz(context, flashcards[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddFlashcardScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFlashcardScreen()),
    );
    if (result != null && result is Flashcard) {
      setState(() {
        flashcards.add(result);
      });
    }
  }

  void _startQuiz(BuildContext context, Flashcard flashcard) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizScreen(flashcard)),
    );
  }
}

class AddFlashcardScreen extends StatefulWidget {
  @override
  _AddFlashcardScreenState createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Flashcard'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: answerController,
              decoration: InputDecoration(labelText: 'Answer'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _addFlashcard();
              },
              child: Text('Add Flashcard'),
            ),
          ],
        ),
      ),
    );
  }

  void _addFlashcard() {
    if (questionController.text.isNotEmpty && answerController.text.isNotEmpty) {
      Navigator.pop(
        context,
        Flashcard(
          question: questionController.text,
          answer: answerController.text,
        ),
      );
    }
  }
}

class QuizScreen extends StatefulWidget {
  final Flashcard flashcard;

  QuizScreen(this.flashcard);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool isQuestionVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isQuestionVisible ? widget.flashcard.question : widget.flashcard.answer,
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isQuestionVisible = !isQuestionVisible;
                });
              },
              child: Text(isQuestionVisible ? 'Show Answer' : 'Show Question'),
            ),
          ],
        ),
      ),
    );
  }
}

class Flashcard {
  final String question;
  final String answer;

  Flashcard({required this.question, required this.answer});
}
