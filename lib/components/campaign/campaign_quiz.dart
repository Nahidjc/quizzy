import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy/api_caller/campaign.dart';
import 'package:quizzy/components/campaign/campaign_quiz_result.dart';
import 'package:quizzy/components/campaign/convert_quiz.dart';
import 'package:quizzy/components/multiple_answer_quiz.dart';
import 'package:quizzy/components/single_answer_quiz.dart';
import 'package:quizzy/models/campaign_quiz.dart';
import 'package:quizzy/provider/login_provider.dart';
import 'dart:async';
import 'package:quizzy/utils/quiz_points.dart';
import 'package:quizzy/widget/circular_progress.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class CampaignQuiz extends StatefulWidget {
  final CampaignModel quiz;
  const CampaignQuiz({Key? key, required this.quiz}) : super(key: key);

  @override
  State<CampaignQuiz> createState() => _CampaignQuizState();
}

class _CampaignQuizState extends State<CampaignQuiz> {
  List<Map<String, dynamic>> quizData = [];
  late AuthProvider authProvider;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      quizData = convertToQuiz(widget.quiz.questions);
    });
    startTimer();
  }

  Map<int, dynamic> selectedAnswers = {};
  int score = 0;
  int points = 0;
  bool isSubmitting = false;
  int totalTime = 600;
  late int timeRemaining;
  Timer? timer;
  int currentQuestionIndex = 0;

  List<dynamic> getSelectedAnswer(Map<int, dynamic> selectedAnswers) {
    int skipQuestion = 0;
    List<dynamic> selectedAnswersArray = [];

    for (int i = 0; i < quizData.length; i++) {
      if (!selectedAnswers.containsKey(i)) {
        if (quizData[i].containsKey('correctAnswers')) {
          skipQuestion++;
          selectedAnswersArray.add([quizData[i]['options'].length]);
        } else {
          skipQuestion++;
          selectedAnswersArray.add(quizData[i]['options'].length);
        }
      } else {
        dynamic answer = selectedAnswers[i];
        selectedAnswersArray.add(answer);
      }
    }
    return [skipQuestion, selectedAnswersArray];
  }

  void startTimer() {
    timeRemaining = totalTime;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (timeRemaining > 0) {
          timeRemaining--;
        } else {
          timer.cancel();
          submitQuiz();
        }
      });
    });
  }

  void showWarningIfQuestionsNotFilled() {
    if (!allQuestionsAnswered) {
      PanaraConfirmDialog.show(
        context,
        title: "Warning",
        message:
            "You have not answered all questions. Do you want to submit anyway?",
        confirmButtonText: "Submit",
        cancelButtonText: "Cancel",
        onTapCancel: () {
          Navigator.pop(context);
        },
        onTapConfirm: () {
          Navigator.pop(context);
          submitQuiz();
        },
        panaraDialogType: PanaraDialogType.warning,
        barrierDismissible: false,
      );
    } else {
      submitQuiz();
    }
  }

  Future submitQuiz() async {
    timer?.cancel();
    setState(() {
      isSubmitting = true;
    });

    int correctAnswers = 0;
    for (int i = 0; i < quizData.length; i++) {
      final question = quizData[i];
      final selectedAnswer = selectedAnswers[i];

      if (question.containsKey('correctAnswer')) {
        final correctAnswer = question['correctAnswer'];
        if (selectedAnswer == correctAnswer) {
          correctAnswers++;
        }
      } else if (question.containsKey('correctAnswers')) {
        final correctAnswersList = question['correctAnswers'];
        if (selectedAnswer != null &&
            selectedAnswer.length == correctAnswersList.length &&
            selectedAnswer.toSet().containsAll(correctAnswersList)) {
          correctAnswers++;
        }
      }
    }

    final quizPoint = QuizPoints();
    int quizpoint = quizPoint.calculatePoints(
        correctAnswers, timeRemaining, quizData.length);
    setState(() {
      score = correctAnswers;
      points = quizpoint;
    });
    List<dynamic> result = getSelectedAnswer(selectedAnswers);
    int skipQuestion = result[0];
    int timeSpent = totalTime - timeRemaining;
    List<dynamic> selectedArray = result[1];
    selectedAnswers = {};
    final campaignApi = CampaignApi();
    await campaignApi.attemptCampaignQuiz(widget.quiz.campaign, widget.quiz.id,
        authProvider.userId, points, selectedArray);
    updateData();
    setState(() {
      isSubmitting = false;
    });
    gottoNextPage(
        correctAnswers, quizpoint, selectedArray, skipQuestion, timeSpent);
  }

  void updateData() {
    authProvider.userDetails(authProvider.userId);
  }

  void gottoNextPage(
      correctAnswers, quizpoint, selectedArray, skipQuestion, timeSpent) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CampaignQuizResultPage(
            quizData: quizData,
            correctAnswers: correctAnswers,
            percentage: (correctAnswers / quizData.length) * 100,
            quizpoint: quizpoint,
            selectedArray: selectedArray,
            skipQuestion: skipQuestion,
            timeSpent: timeSpent,
            campaign: widget.quiz.campaign),
      ),
    );
  }

  void nextQuestion() {
    if (currentQuestionIndex < quizData.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  bool allQuestionsAnswered = false;
  bool checkAllQuestionsAnswered() {
    for (var i = 0; i < quizData.length; i++) {
      if (selectedAnswers[i] == null) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = quizData[currentQuestionIndex];
    final dynamic options = currentQuestion['options'];

    List<dynamic> getOptions() {
      if (options is List<dynamic>) {
        return options;
      } else if (options is int) {
        return List.generate(options, (index) => index.toString());
      } else {
        return [];
      }
    }

    final List<dynamic> questionOptions = getOptions();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              PanaraConfirmDialog.show(
                context,
                title: 'Submit Quiz?',
                message:
                    'Are you sure you want to leave? Your quiz will be submitted.',
                confirmButtonText: "OK",
                cancelButtonText: "Cancel",
                onTapCancel: () {
                  Navigator.pop(context);
                },
                onTapConfirm: () {
                  Navigator.pop(context);
                  submitQuiz();
                },
                panaraDialogType: PanaraDialogType.warning,
                barrierDismissible: false,
              );
            },
          ),
          actions: [Container()],
        ),
        body: isSubmitting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleProgressBar(
                        timeRemaining: timeRemaining,
                        strokeWidth: 10.0,
                        radius: 50.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${currentQuestionIndex + 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: (currentQuestionIndex + 1) /
                                          quizData.length,
                                      backgroundColor: Colors.transparent,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Colors.green),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 18),
                              Text(
                                ' ${quizData.length - currentQuestionIndex - 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              'Question ${currentQuestionIndex + 1}/${quizData.length}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: SizedBox(
                              height: 80, // Set the desired fixed height
                              child: SingleChildScrollView(
                                child: Text(
                                  currentQuestion['question'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: FractionallySizedBox(
                        alignment: Alignment.center,
                        widthFactor: 1.0,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (currentQuestion.containsKey('correctAnswers'))
                                MultipleCorrectAnswerQuestionWidget(
                                  options: questionOptions,
                                  selectedAnswers:
                                      selectedAnswers[currentQuestionIndex] ??
                                          [],
                                  onAnswerSelected: (selectedOptions) {
                                    setState(() {
                                      selectedAnswers[currentQuestionIndex] =
                                          selectedOptions;
                                      allQuestionsAnswered =
                                          checkAllQuestionsAnswered();
                                    });
                                  },
                                )
                              else
                                SingleCorrectAnswerQuestionWidget(
                                  options: questionOptions,
                                  selectedAnswer:
                                      selectedAnswers[currentQuestionIndex],
                                  onAnswerSelected: (selectedOption) {
                                    setState(() {
                                      selectedAnswers[currentQuestionIndex] =
                                          selectedOption;
                                      allQuestionsAnswered =
                                          checkAllQuestionsAnswered();
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (currentQuestionIndex > 0)
                          ElevatedButton(
                            onPressed: previousQuestion,
                            child: const Text('Previous'),
                          ),
                        const SizedBox(width: 20),
                        if (currentQuestionIndex < quizData.length - 1)
                          ElevatedButton(
                            onPressed: nextQuestion,
                            child: const Text('Next'),
                          ),
                        const SizedBox(width: 20),
                        if (currentQuestionIndex == quizData.length - 1)
                          ElevatedButton(
                            onPressed: showWarningIfQuestionsNotFilled,
                            child: const Text('Submit Quiz'),
                          ),
                      ],
                    )
                  ],
                ),
              ));
  }
}
