import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:novlix_app/models/cities.dart';
import 'package:novlix_app/models/countries.dart';
import 'package:novlix_app/screens/countries_screen.dart';
import 'package:novlix_app/screens/favorites_screen.dart';
import 'package:novlix_app/screens/search_screen.dart';
import 'package:novlix_app/widgets/app_drawer.dart';
import '../main.dart';

class TabsScreen extends StatefulWidget {
  final List<cities> favoriteTrips;
  final List<countries> _ava;

  TabsScreen(this.favoriteTrips, this._ava);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  int _selectedScreenIndex = 0;
  late List<Map<String, Object>> _screens;
  late AnimationController _controller;
  late Animation<Alignment> _beginAnimation;
  late Animation<Alignment> _endAnimation;

  String _languageSymbol = 'EN';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _beginAnimation = AlignmentTween(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _endAnimation = AlignmentTween(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _screens = [
      {'Screen': countriesscreen(widget._ava), 'Title': 'world_title'.tr()},
      {
        'Screen': FavoritesScreen(widget.favoriteTrips),
        'Title': 'favorite'.tr(),
      },
      {'Screen': SearchScreen(), 'Title': 'search'.tr()},
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateLanguageSymbol(context.locale.languageCode);
  }

  void _updateLanguageSymbol(String code) {
    setState(() {
      switch (code) {
        case 'en':
          _languageSymbol = 'EN';
          break;
        case 'ar':
          _languageSymbol = 'ع';
          break;
        case 'es':
          _languageSymbol = 'ES';
          break;
        case 'fr':
          _languageSymbol = 'FR';
          break;
        case 'ru':
          _languageSymbol = 'RU';
          break;
        default:
          _languageSymbol = code.toUpperCase();
      }
    });
  }

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('chooseLanguage'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageTile('English', const Locale('en')),
              _buildLanguageTile('العربية', const Locale('ar')),
              _buildLanguageTile('Español', const Locale('es')),
              _buildLanguageTile('Français', const Locale('fr')),
              _buildLanguageTile('Русский', const Locale('ru')),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageTile(String title, Locale locale) {
    return ListTile(
      title: Text(title),
      onTap: () {
        MyApp.setLocale(context, locale);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _screens[0]['Title'] = 'world_title'.tr();
    _screens[1]['Title'] = 'favorite'.tr();
    _screens[2]['Title'] = 'search'.tr();

    double titleFontSize =
        (context.locale.languageCode == 'es' ||
            context.locale.languageCode == 'fr')
        ? 24.5
        : 30;

    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.deepOrange, Colors.white, Colors.purple],
                begin: _beginAnimation.value,
                end: _endAnimation.value,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Text(
                _screens[_selectedScreenIndex]['Title'] as String,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontFamily: 'Commissioner-Regular',
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => _showLanguageDialog(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.language, size: 28),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 28,
                    child: Text(
                      _languageSymbol,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Commissioner-Regular',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
      ),

      drawer: AppDrawer(),
      body: _screens[_selectedScreenIndex]['Screen'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectScreen,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedScreenIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: 'countries'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.star),
            label: 'favorite'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: 'search'.tr(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
