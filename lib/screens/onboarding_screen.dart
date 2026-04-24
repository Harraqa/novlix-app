import 'package:flutter/material.dart';
import 'package:novlix_app/models/cities.dart';
import 'package:novlix_app/models/countries.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tabs_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final List<cities> favoriteTrips;
  final List<countries> availableTrips;

  const OnboardingScreen({
    Key? key,
    required this.favoriteTrips,
    required this.availableTrips,
  }) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Welcome',
      'desc': 'Explore amazing countries around the world.',
      'image': 'assets/images/onboarding1.jpg',
    },
    {
      'title': 'Enjoy the Experience',
      'desc': 'Discover helpful tools and a smooth, easy experience.',
      'image': 'assets/images/onboarding2.jpg',
    },
    {
      'title': 'Enjoy your trip',
      'desc': 'Let the adventure begin!',
      'image': 'assets/images/onboarding3.jpg',
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => TabsScreen(
          widget.favoriteTrips, // ✅ доступ через widget
          widget.availableTrips, // ✅ доступ через widget
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (ctx, i) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _pages[i]['image']!,
              height: 320,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 30),
            Text(
              _pages[i]['title']!,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                _pages[i]['desc']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text("Skip"),
                onPressed: _completeOnboarding,
              ),
              Row(
                children: List.generate(_pages.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 12 : 8,
                    height: _currentPage == index ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Colors.blue : Colors.grey,
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    child: Text(
                      _currentPage == _pages.length - 1 ? "Start" : "Next",
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
