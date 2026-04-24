import 'package:flutter/material.dart';
import 'package:novlix_app/models/cities.dart';
import 'package:novlix_app/models/countries.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';
import 'tabs_screen.dart';

class AnimatedSplashHandler extends StatefulWidget {
  final List<cities> favoriteTrips;
  final List<countries> availableTrips;

  const AnimatedSplashHandler(
    this.favoriteTrips,
    this.availableTrips, {
    Key? key,
  }) : super(key: key);

  @override
  State<AnimatedSplashHandler> createState() => _AnimatedSplashHandlerState();
}

class _AnimatedSplashHandlerState extends State<AnimatedSplashHandler>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final String appName = "Novlix";

  static const double letterDelay = 0.5; // задержка между буквами в секундах
  static const double letterFadeDuration = 0.5; // длительность появления буквы

  @override
  void initState() {
    super.initState();

    final totalDurationSeconds =
        (appName.length - 1) * letterDelay + letterFadeDuration;

    _controller = AnimationController(
      duration: Duration(milliseconds: (totalDurationSeconds * 1000).round()),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();

    _startApp();
  }

  Future<void> _startApp() async {
    await Future.delayed(const Duration(seconds: 6));

    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    if (!mounted) return;

    if (!seenOnboarding) {
      await prefs.setBool('seenOnboarding', true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OnboardingScreen(
            favoriteTrips: widget.favoriteTrips,
            availableTrips: widget.availableTrips,
          ),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              TabsScreen(widget.favoriteTrips, widget.availableTrips),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedText() {
    List<Widget> letters = [];

    for (int i = 0; i < appName.length; i++) {
      letters.add(
        FadeTransition(
          opacity: DelayTween(
            begin: 0,
            end: 1,
            delay:
                i *
                letterDelay /
                ((appName.length - 1) * letterDelay + letterFadeDuration),
          ).animate(_controller),
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.deepOrange, Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            child: Text(
              appName[i],
              style: const TextStyle(
                fontSize: 42,
                fontFamily: 'Orbitron-VariableFont_wght',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      );
    }

    return Row(mainAxisSize: MainAxisSize.min, children: letters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/images/icon-5.png',
                width: 220,
                height: 220,
              ),
            ),
            const SizedBox(height: 11),
            _buildAnimatedText(),
            const SizedBox(height: 140),
            const CircularProgressIndicator(
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
              backgroundColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class DelayTween extends Tween<double> {
  final double delay;

  DelayTween({double begin = 0, double end = 1, required this.delay})
    : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    if (t < delay) {
      return 0;
    }
    double adjustedT = (t - delay) / (1 - delay);
    return super.lerp(adjustedT.clamp(0.0, 1.0));
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
