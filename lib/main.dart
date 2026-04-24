import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:novlix_app/screens/about_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:google_mobile_ads/google_mobile_ads.dart';

import './app_data.dart';
import 'models/countries.dart';
import 'models/cities.dart';
import './providers/theme_provider.dart';

import 'screens/category_country_screen.dart';
import './screens/filters_screen.dart';
import './screens/tabs_screen.dart';
import 'screens/city_detail_screen.dart';
import './screens/animated_splash_screen.dart';
import './screens/currency_converter.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await EasyLocalization.ensureInitialized();

  await MobileAds.instance.initialize();

  tz.initializeTimeZones();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('es'),
        Locale('fr'),
        Locale('ru'),
      ],
      path: 'assets/translations',
      startLocale: Locale('en'),
      saveLocale: false,
      child: MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    context.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {'European': false, 'Non_European': false};

  List<countries> _availableTrips = countries_Data;
  List<cities> _favoriteTrips = [];

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  void _changeFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availableTrips = countries_Data.where((category) {
        if (_filters['European'] == true && category.eurpoe != true) {
          return false;
        }
        if (_filters['Non_European'] == true && category.non_europe != true) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _manageFavorite(String tripId) {
    final existingIndex = _favoriteTrips.indexWhere(
      (trip) => trip.id == tripId,
    );

    if (existingIndex >= 0) {
      setState(() {
        _favoriteTrips.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favoriteTrips.add(cities_Data.firstWhere((trip) => trip.id == tripId));
      });
    }
  }

  bool _isFavorite(String id) {
    return _favoriteTrips.any((trip) => trip.id == id);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Preahvihear-Regular',
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        fontFamily: 'Preahvihear-Regular',
      ),
      builder: (context, child) {
        return SafeArea(child: child!);
      },
      routes: {
        '/': (ctx) => AnimatedSplashHandler(_favoriteTrips, _availableTrips),
        '/tabs': (ctx) => TabsScreen(_favoriteTrips, _availableTrips),
        '/converter': (_) => CurrencyConverter(),
        CategorycountryScreen.screenRoute: (ctx) => CategorycountryScreen(),
        cityDetailScreen.screenRoute: (ctx) =>
            cityDetailScreen(_manageFavorite, _isFavorite),
        FiltersScreen.screenRoute: (ctx) =>
            FiltersScreen(_filters, _changeFilters),
        AboutScreen.routeName: (ctx) => AboutScreen(),
      },
    );
  }
}
