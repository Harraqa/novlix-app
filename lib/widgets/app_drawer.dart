import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novlix_app/screens/about_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../screens/filters_screen.dart';
import '../providers/theme_provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  String _appVersion = '';
  late final AnimationController _controller;
  late final Animation<Alignment> _beginAnimation;
  late final Animation<Alignment> _endAnimation;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${info.version}+${info.buildNumber}';
    });
  }

  Widget buildListTile(String title, IconData icon, VoidCallback onTapLink) {
    return ListTile(
      leading: Icon(icon, size: 36, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 26,
          fontFamily: 'MPLUSRounded1c-Medium',
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTapLink,
    );
  }

  Widget buildSwitchTile(
    BuildContext context,
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, size: 36, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 26,
          fontFamily: 'MPLUSRounded1c-Medium',
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }

  void _launchContactDialog(BuildContext context) {
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('contact_us'.tr()),
            content: Text('${'you_can_contact'.tr()}\n\nharraqaiead@gmail.com'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  Clipboard.setData(
                    const ClipboardData(text: 'harraqaiead@gmail.com'),
                  );
                  Navigator.of(dialogContext).pop();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('email_copied'.tr()),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text(
                  'copy_email'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () async {
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: 'harraqaiead@gmail.com',
                    query: Uri.encodeFull('subject=Novlix Support&body=Hello,'),
                  );

                  try {
                    await launchUrl(
                      emailUri,
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch email app')),
                      );
                    }
                  }

                  if (mounted) Navigator.of(dialogContext).pop();
                },
                child: Text(
                  'send_email'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  void _shareApp(BuildContext context) {
    Navigator.pop(context);
    const appLink =
        'https://drive.google.com/uc?export=download&id=1xxopfNqgCh2PTnMQjb6qAc73loHzNfQG';
    Share.share('${'share_text'.tr()} $appLink');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 55),
            color: Colors.blue,
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/icon-5.png', width: 70, height: 70),
                const SizedBox(width: 10),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return ShaderMask(
                      shaderCallback: (bounds) =>
                          LinearGradient(
                            colors: [
                              Colors.deepOrange,
                              Colors.white,
                              Colors.purple,
                            ],
                            begin: _beginAnimation.value,
                            end: _endAnimation.value,
                          ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                      child: child,
                    );
                  },
                  child: Text(
                    'Novlix'.tr(),
                    style: const TextStyle(
                      fontFamily: 'Orbitron-VariableFont_wght',
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          buildListTile(
            'all_countries'.tr(),
            Icons.flag_circle,
            () => Navigator.of(context).pushReplacementNamed('/tabs'),
          ),
          buildListTile(
            'filter'.tr(),
            Icons.filter_list,
            () => Navigator.of(
              context,
            ).pushReplacementNamed(FiltersScreen.screenRoute),
          ),
          buildListTile(
            'currency_converter'.tr(),
            Icons.currency_exchange,
            () => Navigator.of(context).pushNamed('/converter'),
          ),
          buildSwitchTile(
            context,
            'dark_mode'.tr(),
            Icons.dark_mode,
            themeProvider.isDarkMode,
            (value) => themeProvider.toggleTheme(value),
          ),
          buildListTile(
            'contact_us'.tr(),
            Icons.contact_mail,
            () => _launchContactDialog(context),
          ),
          buildListTile(
            'share_app'.tr(),
            Icons.share,
            () => _shareApp(context),
          ),
          buildListTile(
            'about_app'.tr(),
            Icons.info_outline,
            () => Navigator.of(context).pushNamed(AboutScreen.routeName),
          ),

          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Version $_appVersion',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
