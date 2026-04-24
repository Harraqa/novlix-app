import 'package:easy_localization/easy_localization.dart';
import '../screens/category_country_screen.dart';
import 'package:flutter/material.dart';

class countryIteam extends StatelessWidget {
  final String id;
  final String title;
  final List<List<String>> categoryList;
  final String imageUrl;
  final bool eurpoe;
  final bool non_europe;

  countryIteam(
    this.id,
    this.title,
    this.categoryList,
    this.imageUrl,
    this.eurpoe,
    this.non_europe, {
    super.key,
  });

  void selectcategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      CategorycountryScreen.screenRoute,
      arguments: {'id': id, 'title': title, 'description': categoryList},
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Force rebuild on locale change
    final _ = context.locale;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () => selectcategory(context),
          child: Stack(
            children: [
              Image.network(imageUrl, height: 250, fit: BoxFit.fill),
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.1),
                child: Text(
                  title.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Preahvihear-Regular',
                    fontSize:
                        (context.locale.languageCode == 'fr' ||
                            context.locale.languageCode == 'es')
                        ? 27.0
                        : (context.locale.languageCode == 'ru'
                              ? 24.8
                              : 31.5781),
                    color: Colors.white,
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
