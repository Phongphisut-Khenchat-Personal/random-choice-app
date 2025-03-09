import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  static const String _appId = 'ca-app-pub-3940256099942544~3347511713'; // Test App ID
  static const String _bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Test Banner ID
  static const String _interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Test Interstitial ID

  InterstitialAd? _interstitialAd;

  void initialize() {
    MobileAds.instance.initialize();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  static void showInterstitialAd() {
    final instance = AdService();
    if (instance._interstitialAd != null) {
      instance._interstitialAd!.show();
      instance._interstitialAd = null;
    } else {
      instance._loadInterstitialAd();
    }
  }

  static String get bannerAdUnitId => _bannerAdUnitId;
}