import 'package:flutter/material.dart';
import 'package:quizzy/ads/banner_ads.dart';
import 'package:quizzy/components/category/categories.dart';
import 'package:quizzy/components/category/category_skeleton.dart';
// import 'package:quizzy/components/custom_drawer.dart';
// import 'package:quizzy/components/header.dart';
import 'package:quizzy/api_caller/categories.dart';
// import 'package:quizzy/components/slider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quizzy/configs/variables.dart';
import 'package:quizzy/token/token_manager.dart';

class AllQuizCategories extends StatefulWidget {
  const AllQuizCategories({super.key});
  @override
  State<AllQuizCategories> createState() => _AllQuizCategoriesState();
}

class _AllQuizCategoriesState extends State<AllQuizCategories> {
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
    String? authToken = await TokenManager.getToken();
    List<dynamic> levels = await CategoryList().fetchData(authToken!);
    categoryList = levels;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quiz Categories",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Variables.primaryColor,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          height: MediaQuery.of(context).size.height,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: Column(children: [
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAdManager.dispose();
    super.dispose();
  }
}
