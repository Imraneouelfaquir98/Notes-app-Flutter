import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class AdManager{
  static int nbr_1    = 1, nbr_2    = 1, nbr_3    = 1;
  static int period_1 = 3, period_2 = 1, period_3 = 4;
}

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  int get inc => 0;
  set inc (val) => val;

  String get bannerAdUnitUd => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111' // for testing
      : '';

  String get interstitialAdUnitUd => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712' // for testing
      : '';

  BannerAdListener get adListener => _adListener;

  BannerAdListener _adListener = BannerAdListener(
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}.'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) =>
        print('Ad failed to load: ${ad.adUnitId}, $error.'),
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
    onAdImpression: (ad) => print('Ad impressed: ${ad.adUnitId}.'),
    onAdWillDismissScreen: (ad) => print('Ad will dismiss screen: ${ad.adUnitId}.'),
  );
}