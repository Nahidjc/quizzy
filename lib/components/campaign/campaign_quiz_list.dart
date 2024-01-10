import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy/api_caller/campaign.dart';
import 'package:quizzy/components/campaign/quiz_item.dart';
import 'package:quizzy/components/campaign/skeleton.dart';
import 'package:quizzy/components/custom_drawer.dart';
import 'package:quizzy/configs/variables.dart';
import 'package:quizzy/models/campaign_quiz.dart';
import 'package:quizzy/provider/login_provider.dart';

class CampaignQuizList extends StatefulWidget {
  final String campaignId;
  const CampaignQuizList({super.key, required this.campaignId});

  @override
  State<CampaignQuizList> createState() => _CampaignQuizListState();
}

class _CampaignQuizListState extends State<CampaignQuizList> {
  late List<CampaignModel> _currentQuizList;
  late List<CampaignModel> closedCampaignQuizData = [];
  late List<CampaignModel> upcomingCampaignQuizData = [];
  late List<CampaignModel> runningCampaignQuizData = [];
  final CampaignApi campaignApi = CampaignApi();
  bool isLoading = false;
  bool runningQuiz = false;
  bool upcomingQuiz = true;
  @override
  void initState() {
    super.initState();
    _upcomingCampaignQuiz();
  }

  Future<void> _upcomingCampaignQuiz() async {
    setState(() {
      isLoading = true;
    });
    try {
      String userId = Provider.of<AuthProvider>(context, listen: false).userId;
      upcomingCampaignQuizData =
          await campaignApi.getCampaignUpcomingQuiz(widget.campaignId, userId);
      _currentQuizList = upcomingCampaignQuizData;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _closedCampaignQuiz() async {
    setState(() {
      isLoading = true;
    });
    try {
      String userId = Provider.of<AuthProvider>(context, listen: false).userId;
      closedCampaignQuizData =
          await campaignApi.getCampaignClosedQuiz(widget.campaignId, userId);
      _currentQuizList = closedCampaignQuizData;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _runningCampaignQuiz() async {
    setState(() {
      isLoading = true;
    });
    try {
      String userId = Provider.of<AuthProvider>(context, listen: false).userId;
      runningCampaignQuizData =
          await campaignApi.getCampaignRunningQuiz(widget.campaignId, userId);
      _currentQuizList = runningCampaignQuizData;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Campaign Quiz',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Variables.primaryColor,
        actions: [Container()],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildQuizTypeOption('Upcoming', upcomingQuiz),
              const SizedBox(width: 10),
              buildQuizTypeOption('Running', runningQuiz),
              const SizedBox(width: 10),
              buildQuizTypeOption('Closed', !runningQuiz && !upcomingQuiz),
            ],
          ),
        ),
        Expanded(
          child: isLoading
              ? const SkeletonBoxes()
              : _currentQuizList.isEmpty
                  ? NoQuizzesMessage(
                      refreshQuizzes: _upcomingCampaignQuiz,
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: _currentQuizList.map((quiz) {
                        return CampaignQuizItem(
                          title: quiz.title,
                          isAttempted: quiz.isAttempted,
                          points: quiz.point,
                          startTime: quiz.startTime,
                          endTime: quiz.endTime,
                          quiz: quiz,
                        );
                      }).toList(),
                    ),
        )
      ]),
      endDrawer: const CustomDrawer(),
    );
  }

  Widget buildQuizTypeOption(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          upcomingQuiz = title == 'Upcoming';
          runningQuiz = title == 'Running';
          if (upcomingQuiz) {
            _upcomingCampaignQuiz();
          } else if (runningQuiz) {
            _runningCampaignQuiz();
          } else {
            _closedCampaignQuiz();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Variables.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Variables.primaryColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class NoQuizzesMessage extends StatelessWidget {
  final VoidCallback refreshQuizzes;

  const NoQuizzesMessage({required this.refreshQuizzes, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            size: 100,
            color: Variables.primaryColor,
          ),
          const SizedBox(height: 20),
          const Text(
            "No quizzes available at this time.",
            style: TextStyle(
              fontSize: 20,
              color: Variables.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Check back later for more exciting quizzes!",
            style: TextStyle(
              fontSize: 16,
              color: Variables.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: refreshQuizzes,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Variables.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Refresh",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
