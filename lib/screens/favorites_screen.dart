import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../widgets/city_item.dart';
import '../models/cities.dart';

class FavoritesScreen extends StatefulWidget {
  final List<cities> favoriteTrips;

  FavoritesScreen(this.favoriteTrips);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Locale? _currentLocale;

  late BannerAd _bannerAd;
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-5754664066089308/4696874976',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerLoaded = true;
          });
          print('Google AdMob banner loaded');
        },
        onAdFailedToLoad: (ad, error) {
          print('Google AdMob banner failed to load: $error');
          ad.dispose();
        },
        onAdOpened: (ad) => print('Ad opened'),
        onAdClosed: (ad) => print('Ad closed'),
        onAdClicked: (ad) => print('Ad clicked'),
        onAdImpression: (ad) => print('Ad impression'),
      ),
    );

    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newLocale = EasyLocalization.of(context)!.locale;
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: widget.favoriteTrips.isEmpty
                ? Center(child: Text('favo_sc'.tr()))
                : ListView.builder(
                    itemCount: widget.favoriteTrips.length,
                    itemBuilder: (ctx, index) {
                      final trip = widget.favoriteTrips[index];
                      return cityItem(
                        id: trip.id,
                        title: trip.title,
                        imageUrl: trip.imageUrl,
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _isBannerLoaded
          ? Container(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : SizedBox.shrink(),
    );
  }
}
