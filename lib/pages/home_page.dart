import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quizzy/ads/banner_ads.dart';
import 'package:quizzy/components/category/categories.dart';
import 'package:quizzy/components/category/category_skeleton.dart';
import 'package:quizzy/components/custom_drawer.dart';
import 'package:quizzy/components/header.dart';
import 'package:quizzy/api_caller/categories.dart';
import 'package:quizzy/components/slider.dart';
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
    categoryList = levels;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(children: [
        Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(15.0, 20.0, 15, 0.0),
            child: const Text("Competitions Categories",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))),
        Expanded(
            child: isLoading
                ? const CategorySkeleton()
                : Categories(categoryList: categoryList)),
        SizedBox(
          height: 160,
          child: CarouselSliderCustom(),
        ),
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
      endDrawer: const CustomDrawer(),
    );
  }


  // void _loadAd() async {
  //   BannerAd(
  //     adUnitId: _adUnitId,
  //     request: const AdRequest(),
  //     size: AdSize.banner,
  //     listener: BannerAdListener(
  //       onAdLoaded: (ad) {
  //         setState(() {
  //           _bannerAd = ad as BannerAd;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, err) {
  //         ad.dispose();
  //       },
  //       onAdOpened: (Ad ad) {},
  //       onAdClosed: (Ad ad) {},
  //       onAdImpression: (Ad ad) {},
  //     ),
  //   ).load();
  // }

  @override
  void dispose() {
    // _bannerAd?.dispose();
    _bannerAdManager.dispose();
    super.dispose();
  }
}
