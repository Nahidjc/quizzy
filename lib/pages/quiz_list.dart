import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quizzy/ads/banner_ads.dart';
import 'package:quizzy/api_caller/quiz.dart';
import 'package:quizzy/components/custom_drawer.dart';
import 'package:quizzy/configs/variables.dart';
import 'package:quizzy/models/quiz_model.dart';
import 'package:quizzy/pages/quiz_details.dart';

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
        backgroundColor: Variables.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.levelName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
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
                          backgroundColor: Variables.primaryColor,
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
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                    ),
                    itemCount: quizzes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizDetails(quiz: quizzes[index]),
                          ),
                        ),
                        child: Container(
                          decoration: gradientBoxDecoration,
                          child: Center(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double fontSize = constraints.maxWidth * 0.12;
                                return Text(
                                  quizzes[index].title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(1, 1),
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                );
                              },
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


final gradientBoxDecoration = BoxDecoration(
  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7953E1),
      Color.fromRGBO(141, 105, 240, 0.79),
    ],
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp,
    transform: GradientRotation(230.54 * (3.14159265359 / 180.0)),
  ),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Variables.primaryColor.withOpacity(.3),
      spreadRadius: 2,
      blurRadius: 5,
      offset: const Offset(0, 3),
    ),
  ],
);
