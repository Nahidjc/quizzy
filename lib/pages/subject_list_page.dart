import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quizzy/ads/banner_ads.dart';
import 'package:quizzy/api_caller/subject_api.dart';
import 'package:quizzy/components/category/category_skeleton.dart';
import 'package:quizzy/components/custom_drawer.dart';
import 'package:quizzy/components/info_message.dart';
import 'package:quizzy/configs/variables.dart';
import 'package:quizzy/models/subject_model.dart';
import 'package:quizzy/pages/quiz_level.dart';
import 'package:quizzy/token/token_manager.dart';

class SubjectList extends StatefulWidget {
  final String displayName;
  final String categoryId;

  const SubjectList({
    Key? key,
    required this.displayName,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  late BannerAdManager _bannerAdManager;
  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();
    fetchSubjectList();
    _bannerAdManager = BannerAdManager();
    _loadAd();
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
  List subjects = [];
  Future<void> fetchSubjectList() async {
    setState(() {
      isLoading = true;
    });
    String? authToken = await TokenManager.getToken();
    List<dynamic> subjectListData =
        await SubjectListAPi().fetchData(authToken!, widget.categoryId);
    subjects = subjectListData;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        backgroundColor: Variables.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [Container()],
        title: Text(
          widget.displayName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: CategorySkeleton())
          : subjects.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(context),
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 22.0,
                      mainAxisSpacing: 22.0,
                    ),
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      Subject subject = subjects[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizLevelList(
                              subjectName: subject.displayName,
                              displayName: widget.displayName,
                              subjectId: subject.id,
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: gradientBoxDecoration,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.subject_outlined,
                                  size: 40.0,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 8.0),
                                Center(
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      double fontSize =
                                          constraints.maxWidth * 0.10;
                                      return Text(
                                        subject.displayName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              offset: const Offset(1, 1),
                                              blurRadius: 1.0,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ]),
                        ),
                      );
                    },
                  ),
                )
              : InfoMessage('No data available for ${widget.displayName}'),
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
