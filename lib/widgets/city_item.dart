import 'package:easy_localization/easy_localization.dart';
import '../screens/city_detail_screen.dart';
import 'package:flutter/material.dart';

class cityItem extends StatelessWidget {
  final String id;
  final String title;
  final List<String> imageUrl;

  cityItem({required this.id, required this.title, required this.imageUrl});

  void selectTrip(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamed(cityDetailScreen.screenRoute, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectTrip(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 7,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    imageUrl[0],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 250,
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0),
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: [0.6, 1],
                    ),
                  ),
                  child: Text(
                    title.tr(),
                    style: TextStyle(
                      fontFamily: 'Commissioner-Regular',
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
