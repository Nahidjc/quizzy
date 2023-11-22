import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quizzy/ads/banner_ads.dart';
import 'package:quizzy/api_caller/stage.dart';
import 'package:quizzy/components/custom_drawer.dart';
import 'package:quizzy/components/info_message.dart';
import 'package:quizzy/configs/variables.dart';
import 'package:quizzy/models/stage_model.dart';
import 'package:quizzy/pages/login_page.dart';
import 'package:quizzy/pages/quiz_list.dart';
import 'package:quizzy/provider/login_provider.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class QuizLevelList extends StatefulWidget {
  final String subjectName;
  final String displayName;
  final String subjectId;
  const QuizLevelList(
      {super.key,
      required this.subjectName,
      required this.displayName,
      required this.subjectId});
  @override
  State<QuizLevelList> createState() => _QuizLevelListState();
}

class _QuizLevelListState extends State<QuizLevelList> {
  final StageList _stageList = StageList();
  late AuthProvider user;
  List<dynamic> _stages = [];
  bool isLoading = false;
  late BannerAdManager _bannerAdManager;
  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();
    _bannerAdManager = BannerAdManager();
    _loadAd();
    user = Provider.of<AuthProvider>(context, listen: false);
    _fetchStages();
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

  Future<void> _fetchStages() async {
    setState(() {
      isLoading = true;
    });
    try {
      String userId = Provider.of<AuthProvider>(context, listen: false).userId;
      List<dynamic> stageData =
          await _stageList.fetchStage(userId, widget.subjectId);
      setState(() {
        _stages = stageData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateData() {
    user.userDetails(user.userId);
  }

  Future<void> _stageSubscribe(String userId, String stageId) async {
    setState(() {
      isLoading = true;
    });
    try {
      await _stageList.subscribeStage(userId, stageId);
      updateData();
      _fetchStages();
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
    final user = Provider.of<AuthProvider>(context);

    if (!user.isAuthenticated) {
      return const LoginPage();
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 144, 106, 250),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.subjectName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [Container()],
      ),
      body: Center(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _stages.isNotEmpty
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= _stages.length) {
                        return Container();
                      }

                      StageData levelData = _stages[index];
                      String levelName = levelData.levelName;
                      bool isUnlocked = levelData.isAccessible;
                      String stageId = levelData.id;
                      int cost = levelData.cost;
                      StageData? previousStage;
                      if (index > 0) {
                        previousStage = _stages[index - 1];
                      }
                      bool isPreviousUnlocked =
                          previousStage != null && previousStage.isAccessible;
                      return buildLevelButton(context, levelName, isUnlocked,
                          stageId, cost, isPreviousUnlocked);
                    },
                    itemCount: _stages.length,
                  )
                : InfoMessage('No data available for ${widget.subjectName}'),
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

  Widget buildLevelButton(BuildContext context, String levelName,
      bool isUnlocked, String stageId, int cost, bool isPreviousUnlocked) {
    final user = Provider.of<AuthProvider>(context);
    const double buttonWidth = 110.0;
    const double buttonHeight = 110.0;
    Color textColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: GestureDetector(
        onTap: () {
          if (isUnlocked) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizList(
                    displayName: widget.displayName,
                    subjectName: widget.subjectName,
                    levelName: levelName,
                    subjectId: widget.subjectId,
                    stageId: stageId),
              ),
            );
          } else {
            if (!isPreviousUnlocked) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                text: "You need to subscribe to the previous Level first.",
              );
            } else if (user.coin < cost) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                text: "You don't have enough coins to unlock this level",
              );
            } else {
              PanaraConfirmDialog.show(
                context,
                title: "Level is locked",
                message: "To unlock this level, you need to pay $cost coin.",
                confirmButtonText: "Unlock",
                cancelButtonText: "Cancel",
                onTapCancel: () {
                  Navigator.pop(context);
                },
                onTapConfirm: () {
                  Navigator.pop(context);
                  _stageSubscribe(user.userId, stageId);
                },
                panaraDialogType: PanaraDialogType.normal,
                barrierDismissible: false,
              );
            }
          }
        },
        child: Container(
            width: buttonWidth,
            height: buttonHeight,
            decoration: gradientBoxDecoration,
            child: Container(
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isUnlocked)
                      Icon(
                        Icons.lock,
                        color: textColor,
                        size: 24.0,
                      ),
                    Text(
                      levelName,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
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
