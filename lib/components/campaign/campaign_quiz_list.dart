import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy/api_caller/campaign.dart';
import 'package:quizzy/components/campaign/quiz_item.dart';
import 'package:quizzy/components/campaign/skeleton.dart';
import 'package:quizzy/components/custom_drawer.dart';
import 'package:quizzy/models/campaign_quiz.dart';
import 'package:quizzy/provider/login_provider.dart';

class CampaignQuizList extends StatefulWidget {
  final String campaignId;
  const CampaignQuizList({super.key, required this.campaignId});

  @override
  State<CampaignQuizList> createState() => _CampaignQuizListState();
}

class _CampaignQuizListState extends State<CampaignQuizList> {
  late List<CampaignModel> _campaignQuizList;
  final CampaignApi campaignApi = CampaignApi();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchCampaignQuiz();
  }

  Future<void> _fetchCampaignQuiz() async {
    setState(() {
      isLoading = true;
    });
    try {
      String userId = Provider.of<AuthProvider>(context, listen: false).userId;
      List<CampaignModel> campaignQuizList =
          await campaignApi.getCampaignQuiz(widget.campaignId, userId);
      setState(() {
        _campaignQuizList = campaignQuizList;
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
        title: const Text('Campaign Quiz'),
        actions: [Container()],
      ),
      body: isLoading
          ? const SkeletonBoxes()
            : _campaignQuizList.isEmpty
                ? NoQuizzesMessage(
                    refreshQuizzes: _fetchCampaignQuiz,
                  )
                : ListView(
              children: _campaignQuizList.map((quiz) {
                return CampaignQuizItem(
                    title: quiz.title,
                    isAttempted: quiz.isAttempted,
                    points: quiz.point,
                    startTime: quiz.startTime,
                    endTime: quiz.endTime,
                    quiz: quiz);
              }).toList(),
            ),
        endDrawer: const CustomDrawer());
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
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            "No quizzes available at this time.",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Check back later for more exciting quizzes!",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: refreshQuizzes,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
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
