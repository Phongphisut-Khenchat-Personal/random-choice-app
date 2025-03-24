import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  static const String _appId = 'ca-app-pub-8016574176760176~1572155866';
  static const String _interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; 

  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAd; // เพิ่มตัวแปรสำหรับแบนเนอร์

  void initialize() {
    MobileAds.instance.initialize();
    _loadInterstitialAd();
    _loadBannerAd(); // เรียกฟังก์ชันโหลดแบนเนอร์
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('Interstitial ad loaded');
          _interstitialAd = ad;
          _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('Interstitial ad dismissed');
              ad.dispose();
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Failed to show interstitial ad: $error');
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Failed to load interstitial ad: $error');
          _interstitialAd = null;
          Get.snackbar(
            'ข้อผิดพลาดโฆษณา',
            'ไม่สามารถโหลดโฆษณาได้ กรุณาตรวจสอบการเชื่อมต่อ',
            backgroundColor: Colors.red[50],
            colorText: Colors.red[800],
          );
        },
      ),
    );
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner, // ขนาดมาตรฐานของแบนเนอร์ (320x50)
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Failed to load banner ad: $error');
          ad.dispose();
        },
      ),
    )..load(); // เริ่มโหลดแบนเนอร์
  }

  static void showInterstitialAd() {
    final instance = AdService();
    if (instance._interstitialAd != null) {
      instance._interstitialAd!.show();
      instance._interstitialAd = null;
    } else {
      debugPrint('Interstitial ad not loaded yet');
      instance._loadInterstitialAd();
    }
  }

  // ฟังก์ชันสำหรับรับ BannerAd เพื่อใช้ใน UI
  BannerAd? getBannerAd() {
    return _bannerAd;
  }

  // ล้างทรัพยากรเมื่อไม่ใช้
  void dispose() {
    _interstitialAd?.dispose();
    _bannerAd?.dispose();
  }
}