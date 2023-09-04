import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quizzy/ads/banner_ads.dart';
import 'package:quizzy/components/custom_drawer.dart';
import 'package:quizzy/components/info_message.dart';
import 'package:quizzy/models/level_model.dart';
import 'package:quizzy/pages/quiz_level.dart';

class SubjectList extends StatefulWidget {
  final List<dynamic> subjectList;
  final String displayName;

  const SubjectList({
    Key? key,
    required this.subjectList,
    required this.displayName,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 144, 106, 250),
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
      body: widget.subjectList.isNotEmpty
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: widget.subjectList.length,
                itemBuilder: (context, index) {
                  Subject subject = widget.subjectList[index];
                  return Card(
                    margin: const EdgeInsets.all(5.0),
                    color: Colors.white,
                    child: ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizLevelList(
                            subjectName: subject.subjectName,
                            displayName: widget.displayName,
                            subjectId: subject.id,
                          ),
                        ),
                      ),
                      title: Align(
                        alignment: Alignment.center,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                subject.subjectName,
                                style: TextStyle(
                                  fontSize: constraints.maxHeight * 0.2,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
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
