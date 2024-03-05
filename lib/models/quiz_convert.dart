import 'package:quizzy/models/quiz_model.dart';

List<Map<String, dynamic>> convertToQuizData(List<Question> quizList) {
  List<Map<String, dynamic>> quizData = [];
  for (var quiz in quizList) {
    Map<String, dynamic> quizMap = {
      "question": quiz.question,
      "options": quiz.options,
      "questionId": quiz.id,
      if (quiz.correctAnswers != null)
        "correctAnswers": quiz.correctAnswers
      else if (quiz.correctAnswer != null)
        "correctAnswer": quiz.correctAnswer,
    };
    quizData.add(quizMap);
  }
  return quizData;
}
