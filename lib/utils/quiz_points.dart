class QuizPoints {
  int calculatePoints(int correctAnswers, int remainingTime, int quizLength) {
    int basePoints = correctAnswers * 1;
    double percentage = correctAnswers / quizLength;
    int timeBonus;
    if (percentage == 1.0) {
      timeBonus = (remainingTime * 0.10).round();
    } else if (percentage >= 0.9) {
      timeBonus = (remainingTime * 0.09).round();
    } else if (percentage >= 0.8) {
      timeBonus = (remainingTime * 0.08).round();
    } else if (percentage >= 0.7) {
      timeBonus = (remainingTime * 0.07).round();
    } else if (percentage >= 0.6) {
      timeBonus = (remainingTime * 0.06).round();
    } else if (percentage >= 0.5) {
      timeBonus = (remainingTime * 0.05).round();
    } else if (percentage >= 0.4) {
      timeBonus = (remainingTime * 0.04).round();
    } else if (percentage >= 0.3) {
      timeBonus = (remainingTime * 0.03).round();
    } else if (percentage >= 0.2) {
      timeBonus = (remainingTime * 0.02).round();
    } else if (percentage >= 0.1) {
      timeBonus = (remainingTime * 0.01).round();
    } else {
      timeBonus = 0;
    }

    int totalPoints = basePoints + timeBonus;

    return totalPoints;
  }
}
