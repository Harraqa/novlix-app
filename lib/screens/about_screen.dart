import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'about_app'.tr(),
          style: TextStyle(
            fontSize: Localizations.localeOf(context).languageCode == 'fr'
                ? 22
                : 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Novlix'.tr(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'version'.tr(args: ['1.0.0']),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'about_description'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            Center(
              child: Text(
                '© 2025 Novlix Team',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
