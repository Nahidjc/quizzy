import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quizzy/ads/banner_ads.dart';
import 'package:quizzy/api_caller/quiz.dart';
import 'package:quizzy/components/custom_drawer.dart';
import 'package:quizzy/models/quiz_model.dart';
import 'package:quizzy/pages/quiz_details.dart';
import 'package:breadcrumbs/breadcrumbs.dart';

class ListTable {
  final String title;
  final void Function(BuildContext) onTap;

  const ListTable({
    required this.title,
    required this.onTap,
  });
}

class QuizList extends StatefulWidget {
  final String displayName;
  final String subjectName;
  final String levelName;
  final String subjectId;
  final String stageId;

  const QuizList({
    Key? key,
    required this.displayName,
    required this.subjectName,
    required this.levelName,
    required this.subjectId,
    required this.stageId,
  }) : super(key: key);

  @override
  State<QuizList> createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  List<QuizData> quizzes = [];
  late BannerAdManager _bannerAdManager;
  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();
    _bannerAdManager = BannerAdManager();
    _loadAd();
    fetchQuizData();
  }

  void _loadAd() {
    _bannerAdManager.loadAd((ad) {
      setState(() {
        _bannerAd = ad;
      });
    });
  }

  @override
  void dispose() {
    _bannerAdManager.dispose();
    super.dispose();
  }

  bool isLoading = false;
  Future<void> fetchQuizData() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuizApi quizApi = QuizApi();
      var quizData = await quizApi.fetchQuiz(widget.stageId, widget.subjectId);
      setState(() {
        isLoading = false;
      });
      setState(() {
        quizzes = quizData;
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
        toolbarHeight: 80.0,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 144, 106, 250),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Breadcrumbs(
          crumbs: [
            TextSpan(text: widget.displayName),
            TextSpan(text: widget.subjectName),
            TextSpan(text: widget.levelName),
          ],
          separator: ' > ',
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        actions: [Container()],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : quizzes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.deepOrange,
                        size: 72,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Oops!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "We're sorry, but there are no quizzes available for this subject and level at the moment.",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: fetchQuizData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: const Text(
                          "Refresh",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 10.0, 0.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(context),
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: quizzes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(5.0),
                        color: Colors.white,
                        child: ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuizDetails(quiz: quizzes[index]),
                            ),
                          ),
                          title: SizedBox(
                            width: 150.0,
                            child: Center(
                              child: Text(
                                quizzes[index].title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      endDrawer: const CustomDrawer(),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: _bannerAd?.size.height.toDouble() ?? 0,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (_bannerAd != null) AdWidget(ad: _bannerAd!),
            ],
          ),
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 400) {
      return 4;
    } else {
      return 3;
    }
  }
}
