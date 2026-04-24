import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:novlix_app/app_data.dart';
import 'package:novlix_app/models/cities.dart';
import 'package:novlix_app/models/countries.dart';
import 'package:novlix_app/screens/category_country_screen.dart';
import 'package:novlix_app/screens/city_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String selectedFilter = 'All';
  List<String> filteredKeys = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Locale? _currentLocale;

  List<String> get countryKeys => countries_Data.map((e) => e.title).toList();
  List<String> get cityKeys => cities_Data.map((e) => e.title).toList();
  List<String> get allKeys => [...countryKeys, ...cityKeys];

  @override
  void initState() {
    super.initState();
    filteredKeys = allKeys;

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newLocale = EasyLocalization.of(context)!.locale;

    // Force full rebuild if locale changed
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
      _filterKeys(_controller.text);
      setState(() {}); // rebuild widget tree including ChoiceChips
    }
  }

  void _filterKeys(String query) {
    List<String> baseList;

    if (selectedFilter == 'Countries') {
      baseList = countryKeys;
    } else if (selectedFilter == 'Cities') {
      baseList = cityKeys;
    } else {
      baseList = allKeys;
    }

    setState(() {
      filteredKeys = baseList
          .where((key) => key.tr().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
      _filterKeys(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: Text('all'.tr()),
                  selected: selectedFilter == 'All',
                  onSelected: (_) => _onFilterSelected('All'),
                ),
                ChoiceChip(
                  label: Text('countries'.tr()),
                  selected: selectedFilter == 'Countries',
                  onSelected: (_) => _onFilterSelected('Countries'),
                ),
                ChoiceChip(
                  label: Text('cities'.tr()),
                  selected: selectedFilter == 'Cities',
                  onSelected: (_) => _onFilterSelected('Cities'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'search_hint'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          _focusNode.unfocus();
                          _filterKeys('');
                        },
                      )
                    : null,
              ),
              onChanged: _filterKeys,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredKeys.length,
              itemBuilder: (context, index) {
                final key = filteredKeys[index];

                return ListTile(
                  title: Text(key.tr()),
                  onTap: () {
                    countries? matchedCategory;
                    cities? matchedTrip;

                    try {
                      matchedCategory = countries_Data.firstWhere(
                        (cat) => cat.title == key,
                      );
                    } catch (_) {
                      matchedCategory = null;
                    }

                    try {
                      matchedTrip = cities_Data.firstWhere(
                        (trip) => trip.title == key,
                      );
                    } catch (_) {
                      matchedTrip = null;
                    }

                    if (matchedCategory != null) {
                      Navigator.pushNamed(
                        context,
                        CategorycountryScreen.screenRoute,
                        arguments: {
                          'id': matchedCategory.id,
                          'title': matchedCategory.title,
                          'description': matchedCategory.countryList,
                        },
                      );
                    } else if (matchedTrip != null) {
                      Navigator.pushNamed(
                        context,
                        cityDetailScreen.screenRoute,
                        arguments: matchedTrip.id,
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
