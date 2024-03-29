import 'package:flutter/material.dart';
import 'package:quizzy/api_caller/quiz.dart';
import 'package:quizzy/configs/variables.dart';
import 'package:quizzy/models/quiz_model.dart';
import 'package:quizzy/pages/practice_questions.dart';
import 'package:quizzy/pages/quiz_page.dart';

class QuizDetails extends StatefulWidget {
  final QuizData quiz;
  const QuizDetails({Key? key, required this.quiz}) : super(key: key);

  @override
  State<QuizDetails> createState() => _QuizDetailsState();
}

class _QuizDetailsState extends State<QuizDetails> {
  QuizApi quizApi = QuizApi();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double passageHeight = screenHeight * 0.37;
    int quizLength = widget.quiz.questions.length;
    var len = quizLength.toString();
    var title = widget.quiz.title;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ready for the challenge",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Variables.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.question_answer,
                              color: Colors.deepPurple),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "$len Questions",
                              style: TextStyle(
                                color: Variables.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.star, color: Colors.orange),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '100 Points',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: passageHeight,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Icon(
                              Icons.info_outline,
                              size: 60,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Text(
                          "Select Prepare Yourself to get ready for the quiz, or click Attempt Quiz to proceed directly.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                    radius: 24,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quiz Creator',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.quiz.mentor,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PracticeQuestionPage(quiz: widget.quiz),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Variables.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.4, 0),
                  ),
                  child: Text(
                    "Prepare Yourself",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(quiz: widget.quiz),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Variables.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.4, 0),
                  ),
                  child: Text(
                    'Attempt Quiz',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
