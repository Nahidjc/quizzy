import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdManager {
  BannerAd? _bannerAd;
  final String _adUnitId =
      'ca-app-pub-5140754333447071/6903131995'; // Set the ad unit ID here

  void loadAd(void Function(BannerAd?) onAdLoaded) {
    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          onAdLoaded(ad as BannerAd?);
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
      ),
    )..load();
  }

  void dispose() {
    _bannerAd?.dispose();
  }
}
