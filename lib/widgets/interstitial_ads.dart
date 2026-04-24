// interstitial_ads.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  static InterstitialAd? _interstitialAd;
  static bool _isAdLoaded = false;
  static bool _hasShownAd = false;

  static void loadAndShowAd() {
    if (_hasShownAd) {
      print('Interstitial ad already shown this session.');
      return;
    }

    InterstitialAd.load(
      adUnitId: 'ca-app-pub-5754664066089308/5461284009',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
            },
          );
          ad.show();
          _hasShownAd = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Failed to load interstitial ad: $error');
        },
      ),
    );
  }
}
