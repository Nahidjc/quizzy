import 'package:flutter/material.dart';
import 'package:quizzy/ads/banner_ads.dart';
import 'package:quizzy/components/category/categories.dart';
import 'package:quizzy/components/category/category_skeleton.dart';
import 'package:quizzy/components/custom_drawer.dart';
import 'package:quizzy/components/header.dart';
import 'package:quizzy/api_caller/categories.dart';
// import 'package:quizzy/components/slider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  late BannerAdManager _bannerAdManager;
  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();
    _bannerAdManager = BannerAdManager();
    _loadAd();
    fetchCategoryList();
  }

  void _loadAd() {
    _bannerAdManager.loadAd((ad) {
      setState(() {
        _bannerAd = ad;
      });
    });
  }

  List categoryList = [];
  Future<void> fetchCategoryList() async {
    setState(() {
      isLoading = true;
    });
    List<dynamic> levels = await CategoryList().fetchData();
    categoryList = levels.sublist(0, 4);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const MyAppBar(),
      body: Stack(alignment: Alignment.topLeft, children: [
        Container(
          height: double.infinity,
        ),
        const SizedBox(
          height: 300,
          child: MyAppBar(),
        ),
        const SizedBox(
          height: 30,
        ),
        Positioned(
            top: 250,
            left: 25,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              height: MediaQuery.of(context).size.height - 300,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Column(children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(15.0, 20.0, 15, 0.0),
                      child: const Center(
                        child: Text("Featured Categories",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(121, 73, 255, 1),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold)),
                      )),
                  Expanded(
                      child: isLoading
                          ? const CategorySkeleton()
                          : Categories(categoryList: categoryList)),
                  // SizedBox(
                  //   height: 130,
                  //   child: CarouselSliderCustom(),
                  // ),

                  const SizedBox(height: 10),
                  if (_bannerAd != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SafeArea(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd!),
                        ),
                      ),
                    )
                ]),
              ),
            ))
      ]),
      endDrawer: const CustomDrawer(),
    );
  }

  @override
  void dispose() {
    _bannerAdManager.dispose();
    super.dispose();
  }
}
