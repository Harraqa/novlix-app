import 'package:flutter/material.dart';
import 'package:novlix_app/models/countries.dart';
import 'package:novlix_app/widgets/country_item.dart';

class countriesscreen extends StatelessWidget {
  final List<countries> _ava;

  const countriesscreen(this._ava);

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 7 / 8,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      children: _ava
          .map(
            (categoryData) => countryIteam(
              categoryData.id,
              categoryData.title,
              categoryData.countryList,
              categoryData.imageUrl,
              categoryData.eurpoe,
              categoryData.non_europe,
            ),
          )
          .toList(),
    );
  }
}
