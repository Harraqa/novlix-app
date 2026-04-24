import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../widgets/app_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const screenRoute = '/filters';

  final Function saveFilters;
  final Map<String, bool> currentFilters;

  FiltersScreen(this.currentFilters, this.saveFilters);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _europe = false;
  var _winter = false;
  bool _filtersChanged = false;

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();

    _europe = widget.currentFilters['European'] ?? false;
    _winter = widget.currentFilters['Non_European'] ?? false;

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-5754664066089308/5842435689',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
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

  void _saveFilters() {
    final selectedFilters = {'European': _europe, 'Non_European': _winter};
    widget.saveFilters(selectedFilters);
    setState(() {
      _filtersChanged = false;
    });
  }

  Future<bool> _onWillPop() async {
    if (_filtersChanged) {
      final shouldSave = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('unsaved_changes'.tr()),
          content: Text('save_changes_prompt'.tr()),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                'discard'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                _saveFilters();
                Navigator.of(ctx).pop(true);
              },
              child: Text(
                'save'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );

      if (shouldSave != null && shouldSave) {
        Navigator.of(context).pushReplacementNamed('/tabs');
      }
      return false;
    }

    Navigator.of(context).pushReplacementNamed('/tabs');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'filter_settings'.tr(),
            style: TextStyle(
              fontFamily: 'Preahvihear-Regular',
              fontSize:
                  (context.locale.languageCode == 'ar' ||
                      context.locale.languageCode == 'en')
                  ? 25
                  : 19,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.save, size: 30, color: Colors.yellow),
              onPressed: _saveFilters,
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SwitchListTile(
                    title: Text('eu_cou'.tr(), style: TextStyle(fontSize: 19)),
                    subtitle: Text('eu_trip'.tr()),
                    value: _europe,
                    onChanged: (newValue) {
                      setState(() {
                        _europe = newValue;
                        _filtersChanged = true;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text(
                      'non_eu_cou'.tr(),
                      style: TextStyle(fontSize: 19),
                    ),
                    subtitle: Text('glob_trip'.tr()),
                    value: _winter,
                    onChanged: (newValue) {
                      setState(() {
                        _winter = newValue;
                        _filtersChanged = true;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _isBannerAdReady
            ? Container(
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              )
            : null,
      ),
    );
  }
}
