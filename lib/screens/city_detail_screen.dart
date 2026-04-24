import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:novlix_app/app_data.dart';
import 'package:novlix_app/widgets/interstitial_ads.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class cityDetailScreen extends StatefulWidget {
  static const screenRoute = '/trip-detail';

  final Function mangeFavorite;
  final Function isFavorite;

  cityDetailScreen(this.mangeFavorite, this.isFavorite);

  @override
  _cityDetailScreenState createState() => _cityDetailScreenState();
}

class _cityDetailScreenState extends State<cityDetailScreen> {
  int _currentIndex = 0;

  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  Timer? _timer;
  DateTime? _cityTime;

  tz.Location? _cityLocation;

  @override
  void initState() {
    super.initState();

    tz.initializeTimeZones();

    InterstitialAdManager.loadAndShowAd();

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-5754664066089308/5183782522',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
          print('Banner Ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner Ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }

  void _startCityTimeUpdater(String timezone) {
    try {
      _cityLocation = tz.getLocation(timezone);
      _cityTime = tz.TZDateTime.now(_cityLocation!);

      _timer?.cancel();
      _timer = Timer.periodic(Duration(minutes: 1), (_) {
        setState(() {
          _cityTime = tz.TZDateTime.now(_cityLocation!);
        });
      });
    } catch (e) {
      print('Invalid timezone: $timezone');
      _cityTime = null;
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _showWeather(String cityName) async {
    final apiKey = '7e70c540bb874ac5be0111052250607';
    final encodedCityName = Uri.encodeComponent(cityName.trim());
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$encodedCityName',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final temp = data['current']['temp_c'];
        final desc = data['current']['condition']['text'];
        final humidity = data['current']['humidity'];
        final wind = data['current']['wind_kph'];
        final iconUrl = 'https:${data['current']['condition']['icon']}';

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Center(
              child: Text(
                '${'weather_in'.tr()} ${data['location']['name']}',
                textAlign: TextAlign.center,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(iconUrl),
                SizedBox(height: 10),
                Text('${'temp'.tr()}: $temp°C', textAlign: TextAlign.center),
                Text(
                  '${'humidity'.tr()}: $humidity%',
                  textAlign: TextAlign.center,
                ),
                Text('${'wind'.tr()}: $wind km/h', textAlign: TextAlign.center),
                Text(
                  '${'description'.tr()}: $desc',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('ok'.tr()),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Failed to load weather: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('error_loading_weather'.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripId = ModalRoute.of(context)?.settings.arguments;
    final selectedTrip = cities_Data.firstWhere((trip) => trip.id == tripId);

    if (_cityLocation == null || _cityLocation!.name != selectedTrip.timezone) {
      _startCityTimeUpdater(selectedTrip.timezone);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedTrip.title.tr(),
          style: TextStyle(fontFamily: 'Preahvihear-Regular'),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Carousel with image index
              Stack(
                children: [
                  ClipRRect(
                    child: CarouselSlider(
                      items: selectedTrip.imageUrl.map((image) {
                        return Image.network(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 300,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 250,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      '${_currentIndex + 1}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 150,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Text(
                  'top_att'.tr(),
                  style: TextStyle(
                    fontFamily: 'Preahvihear-Regular',
                    color: Colors.black,
                    fontSize:
                        (context.locale.languageCode != 'ar' &&
                            context.locale.languageCode != 'en')
                        ? 22
                        : 28,
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 200,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemCount: selectedTrip.places.length,
                  itemBuilder: (ctx, index) => Card(
                    color: _currentIndex == index
                        ? Colors.blue.shade100
                        : Colors.white,
                    elevation: _currentIndex == index ? 5 : 0.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${index + 1}. ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: selectedTrip.places[index],
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final Uri uri = Uri.parse(
                                    selectedTrip.placesUrl[index],
                                  );
                                  if (!await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  )) {
                                    throw 'Could not launch $uri';
                                  }
                                },
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () async {
                                  final Uri uri = Uri.parse(
                                    selectedTrip.placesUrl[index],
                                  );
                                  if (!await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  )) {
                                    throw 'Could not launch $uri';
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    Icons.open_in_new,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              if (_isBannerAdReady)
                Container(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  alignment: Alignment.center,
                  child: AdWidget(ad: _bannerAd!),
                ),
            ],
          ),

          if (_cityTime != null)
            Positioned(
              bottom: 9,
              left: 85,
              right: 85,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'local_time_and_date'.tr(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat.Hm('en').format(_cityTime!),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(width: 50),
                        Text(
                          DateFormat('M/d/y', 'en').format(_cityTime!),
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 13.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 5), // Padding on left side
            FloatingActionButton(
              heroTag: 'weather',
              child: Icon(Icons.cloud),
              onPressed: () => _showWeather(selectedTrip.title),
            ),
            SizedBox(width: 190), // Space for center clock/date
            FloatingActionButton(
              heroTag: 'fav',
              child: Icon(
                widget.isFavorite(tripId) ? Icons.star : Icons.star_border,
              ),
              onPressed: () {
                widget.mangeFavorite(tripId);
                final isFavNow = widget.isFavorite(tripId);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavNow
                          ? 'added_to_favorites'.tr() + ' ✅'
                          : 'removed_from_favorites'.tr() + ' ❌',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            SizedBox(width: 5), // Padding on right side
          ],
        ),
      ),
    );
  }
}
