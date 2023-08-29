// ignore_for_file: avoid_print

import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  final String adUnitId;

  // Use the test ad unit ID as a constant
  static const String testAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  InterstitialAdManager({this.adUnitId = testAdUnitId});

  void loadAd() {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print('Interstitial ad loaded.');
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  void showAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      print('Interstitial ad is not ready yet.');
    }
  }
}
