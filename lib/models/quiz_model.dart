class QuizModel {
  List<QuizData> data;
  String message;

  QuizModel({required this.data, required this.message});

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      data: List<QuizData>.from(
          json['data'].map((data) => QuizData.fromJson(data))),
      message: json['message'],
    );
  }
}

class QuizData {
  String id;
  String mentor;
  String title;
  String subjectId;
  List<Question> questions;
  String difficultyLevel;

  QuizData({
    required this.id,
    required this.mentor,
    required this.title,
    required this.subjectId,
    required this.questions,
    required this.difficultyLevel,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) {
    return QuizData(
      id: json['quizId'],
      mentor: json['userId'],
      title: json['title'],
      subjectId: json['subjectId'],
      // questions: [],
      questions: List<Question>.from(
          json['questions'].map((data) => Question.fromJson(data))),
      difficultyLevel: json['levelId'],
    );
  }
}

class Question {
  String question;
  List<String> options;
  dynamic correctAnswer;
  List<int>? correctAnswers;

  String? id;

  Question({
    required this.question,
    required this.options,
    this.correctAnswer,
    this.id,
    this.correctAnswers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final hasCorrectAnswer = json.containsKey('correctAnswer');
    // final hasCorrectAnswers = json.containsKey('correctAnswers');
    // if (hasCorrectAnswer && hasCorrectAnswers) {
    //   throw ArgumentError(
    //       'Both correctAnswer and correctAnswers are present. Only one should be provided.');
    // }
    return Question(
      question: json['question'],
      options:
          List<String>.from(json['options'].map((option) => option.toString())),
      correctAnswer: hasCorrectAnswer ? json['correctAnswer'] : null,
      correctAnswers: null,
      // correctAnswers:
      //     hasCorrectAnswers ? List<int>.from(json['correctAnswers']) : null,
      id: json['questionId'],
    );
  }
}
