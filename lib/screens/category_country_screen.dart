import 'package:easy_localization/easy_localization.dart';
import '../widgets/city_item.dart';
import 'package:flutter/material.dart';
import '../app_data.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class CategorycountryScreen extends StatefulWidget {
  static const screenRoute = '/category-trips';

  @override
  State<CategorycountryScreen> createState() => _CategorycountryScreenState();
}

class _CategorycountryScreenState extends State<CategorycountryScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  late AnimationController _titleController;
  late Animation<Alignment> _beginAnimation;
  late Animation<Alignment> _endAnimation;

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _beginAnimation =
        AlignmentTween(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).animate(
          CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
        );

    _endAnimation =
        AlignmentTween(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ).animate(
          CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  TextSpan buildTextSpan(
    String text,
    double fontSize, {
    Color color = const Color(0xFFFFD700),
  }) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.2,
      ),
    );
  }

  TextSpan buildTextSpan1(
    String text,
    double fontSize, {
    Color color = Colors.black87,
  }) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.2,
      ),
    );
  }

  TextSpan buildTextSpan2(
    String text,
    String url, {
    double fontSize = 20,
    Color color = Colors.blue,
  }) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.0,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
          final Uri uri = Uri.parse(url);
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            throw 'Could not launch $uri';
          }
        },
    );
  }

  TextSpan buildTextSpan3(
    String text,
    double fontSize, {
    Color color = Colors.black,
  }) {
    return TextSpan(
      text: text,
      style: TextStyle(fontSize: fontSize, color: color, height: 1.2),
    );
  }

  Widget _buildPageContent(
    int index,
    List<List<String>> categoryList,
    String categoryTitle,
  ) {
    switch (index) {
      case 0:
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      buildTextSpan1('${'about'.tr()} $categoryTitle 🔍\n', 20),
                      buildTextSpan3('${categoryList[0][0].tr()}\n\n', 16),
                      buildTextSpan1('${'safety'.tr()} 🚔\n', 20),
                      buildTextSpan3('${categoryList[0][1].tr()}\n\n', 16),
                      buildTextSpan1('${'currency'.tr()} 💸\n', 20),
                      buildTextSpan3('${categoryList[0][2].tr()}\n\n', 16),
                      buildTextSpan1('${'time'.tr()} ✈️\n', 20),
                      buildTextSpan3('${categoryList[0][3].tr()}\n\n', 16),
                      buildTextSpan1('${'language'.tr()} 🌍\n', 20),
                      buildTextSpan3('${categoryList[0][4].tr()}\n\n', 16),
                    ],
                  ),
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 10),
                Text(
                  categoryList[0][5].tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      case 1:
        return Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1466691623998-d607fab1ca29?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGFpcnBvcnR8ZW58MHx8MHx8fDA%3D',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: double.infinity,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.93)),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        buildTextSpan1('${'airports'.tr()}\n', 25),
                        buildTextSpan('${categoryList[1][0].tr()}\n', 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        buildTextSpan1('${'airlines'.tr()}\n', 25),
                        buildTextSpan2(
                          categoryList[1][1].tr(),
                          categoryList[1][2],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[1][3].tr(),
                          categoryList[1][4],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[1][5].tr(),
                          categoryList[1][6],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        buildTextSpan1('${'flights'.tr()}\n', 25),
                        buildTextSpan2(
                          categoryList[1][7].tr(),
                          categoryList[1][8],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[1][9].tr(),
                          categoryList[1][10],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40), // Extra bottom padding
                ],
              ),
            ),
          ],
        );
      case 2:
        return Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              'https://cdn.pixabay.com/photo/2016/09/05/01/52/sim-card-1645646_1280.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: double.infinity,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.94)),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        buildTextSpan1('${'sim'.tr()}\n', 25),
                        buildTextSpan2(
                          categoryList[2][0].tr(),
                          categoryList[2][1],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[2][2].tr(),
                          categoryList[2][3],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[2][4].tr(),
                          categoryList[2][5],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[2][6].tr(),
                          categoryList[2][7],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        buildTextSpan1('${'esim'.tr()}\n', 25),
                        buildTextSpan('${categoryList[2][8].tr()}\n', 20),
                        buildTextSpan2(
                          categoryList[2][9].tr(),
                          categoryList[2][10],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[2][11].tr(),
                          categoryList[2][12],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[2][13].tr(),
                          categoryList[2][14],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[2][15].tr(),
                          categoryList[2][16],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40), // Bottom padding for scroll
                ],
              ),
            ),
          ],
        );
      case 3:
        return Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1596894729323-1e2cbd957cee?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTgxfHxob3RlbHN8ZW58MHx8MHx8fDA%3D',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            // Semi-transparent overlay (fixed)
            Container(
              height: double.infinity,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
            ),
            // Scrollable content
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        buildTextSpan1('${categoryList[3][0].tr()}\n', 25),
                        buildTextSpan2(
                          categoryList[3][1].tr(),
                          categoryList[3][2],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[3][3].tr(),
                          categoryList[3][4],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        buildTextSpan1('${categoryList[3][5].tr()}\n', 25),
                        buildTextSpan2(
                          categoryList[3][6].tr(),
                          categoryList[3][7],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[3][8].tr(),
                          categoryList[3][9],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        buildTextSpan1('${categoryList[3][10].tr()}\n', 25),
                        buildTextSpan2(
                          categoryList[3][11].tr(),
                          categoryList[3][12],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[3][13].tr(),
                          categoryList[3][14],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40), // Bottom padding for scroll
                ],
              ),
            ),
          ],
        );
      case 4:
        return Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              'https://plus.unsplash.com/premium_photo-1677993185892-f7823f314c4c?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTgxfHx3aGl0ZSUyMGNhcnN8ZW58MHx8MHx8fDA%3D',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: double.infinity,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        buildTextSpan1('${categoryList[4][0].tr()}\n', 25),
                        buildTextSpan2(
                          categoryList[4][1].tr(),
                          categoryList[4][2],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[4][3].tr(),
                          categoryList[4][4],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        buildTextSpan1('${categoryList[4][5].tr()}\n', 25),
                        buildTextSpan2(
                          categoryList[4][6].tr(),
                          categoryList[4][7],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[4][8].tr(),
                          categoryList[4][9],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        buildTextSpan1('${categoryList[4][10].tr()}\n', 25),
                        buildTextSpan2(
                          categoryList[4][11].tr(),
                          categoryList[4][12],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[4][13].tr(),
                          categoryList[4][14],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        buildTextSpan1('${categoryList[4][15].tr()}\n', 25),
                        buildTextSpan2(
                          categoryList[4][16].tr(),
                          categoryList[4][17],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[4][18].tr(),
                          categoryList[4][19],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        buildTextSpan1('${categoryList[4][20].tr()}\n', 25),
                        buildTextSpan2(
                          categoryList[4][21].tr(),
                          categoryList[4][22],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40), // Bottom padding for scroll
                ],
              ),
            ),
          ],
        );
      case 5:
        return Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1505935428862-770b6f24f629?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjZ8fGZvb2R8ZW58MHx8MHx8fDA%3D',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: double.infinity,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.94)),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [buildTextSpan1('${'popular'.tr()}', 25)],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          buildTextSpan('${categoryList[5][0].tr()}', 20),
                          const TextSpan(text: '\n'),
                          buildTextSpan('${categoryList[5][1].tr()}\n', 20),
                          buildTextSpan('${categoryList[5][2].tr()}', 20),
                          const TextSpan(text: '\n'),
                          buildTextSpan('${categoryList[5][3].tr()}\n', 20),
                          buildTextSpan('${categoryList[5][4].tr()}', 20),
                          const TextSpan(text: '\n'),
                          buildTextSpan('${categoryList[5][5].tr()}\n', 20),
                          buildTextSpan('${categoryList[5][6].tr()}', 20),
                          const TextSpan(text: '\n'),
                          buildTextSpan('${categoryList[5][7].tr()}', 20),
                        ],
                      ),
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        buildTextSpan1('${'discover'.tr()}\n', 25),
                        buildTextSpan2(
                          categoryList[5][8].tr(),
                          categoryList[5][9],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[5][10].tr(),
                          categoryList[5][11],
                        ),
                        const TextSpan(text: '\n\n'),
                        buildTextSpan1('${'delivery'.tr()}\n', 25),
                        buildTextSpan2(
                          categoryList[5][12].tr(),
                          categoryList[5][13],
                        ),
                        const TextSpan(text: '\n'),
                        buildTextSpan2(
                          categoryList[5][14].tr(),
                          categoryList[5][15],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case 6:
        return Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1555774698-0b77e0d5fac6?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YXBwfGVufDB8fDB8fHww',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: double.infinity,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    buildTextSpan1('${categoryList[6][0].tr()}\n', 25),
                    buildTextSpan2(categoryList[6][1].tr(), categoryList[6][2]),
                    const TextSpan(text: '\n'),
                    buildTextSpan2(categoryList[6][3].tr(), categoryList[6][4]),
                    const TextSpan(text: '\n\n'),
                    buildTextSpan1('${categoryList[6][5].tr()}\n', 25),
                    buildTextSpan2(categoryList[6][6].tr(), categoryList[6][7]),
                    const TextSpan(text: '\n'),
                    buildTextSpan2(categoryList[6][8].tr(), categoryList[6][9]),
                    const TextSpan(text: '\n\n'),
                    buildTextSpan1('${categoryList[6][10].tr()}\n', 25),
                    buildTextSpan2(
                      categoryList[6][11].tr(),
                      categoryList[6][12],
                    ),
                    const TextSpan(text: '\n'),
                    buildTextSpan2(
                      categoryList[6][13].tr(),
                      categoryList[6][14],
                    ),
                    const TextSpan(text: '\n\n'),
                    buildTextSpan1('${categoryList[6][15].tr()}\n', 25),
                    buildTextSpan2(
                      categoryList[6][16].tr(),
                      categoryList[6][17],
                    ),
                    const TextSpan(text: '\n'),
                    buildTextSpan2(
                      categoryList[6][18].tr(),
                      categoryList[6][19],
                    ),
                    const TextSpan(text: '\n\n'),
                    buildTextSpan1('${categoryList[6][20].tr()}\n', 25),
                    buildTextSpan2(
                      categoryList[6][21].tr(),
                      categoryList[6][22],
                    ),
                    const TextSpan(text: '\n'),
                    buildTextSpan2(
                      categoryList[6][23].tr(),
                      categoryList[6][24],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      default:
        return Center(
          child: Text(
            'Content not available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeArgument =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (routeArgument == null) {
      return Scaffold(body: Center(child: Text("Ошибка: данные не переданы.")));
    }

    final categoryId = routeArgument['id'] ?? '';
    final categoryTitle =
        (routeArgument['title'] as String?)?.tr() ?? 'Без названия';
    final categoryList =
        routeArgument['description'] as List<List<String>>? ?? [];
    final filteredTrips = cities_Data.where((trip) {
      return trip.countries_.contains(categoryId);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: AnimatedBuilder(
          animation: _titleController,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.deepOrange, Colors.white, Colors.purple],
                begin: _beginAnimation.value,
                end: _endAnimation.value,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Text(
                categoryTitle,
                style: TextStyle(
                  fontFamily: 'Preahvihear-Regular',
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 380,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _buildPageContent(
                          index,
                          categoryList,
                          categoryTitle,
                        ),
                      ),
                    );
                  },
                ),

                // Left arrow
                if (_currentPage > 0)
                  Positioned(
                    left: 4,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blue,
                        size: 32,
                      ),
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),

                // Right arrow
                if (_currentPage < 6)
                  Positioned(
                    right: 4,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                        size: 32,
                      ),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Page indicator
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(7, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return cityItem(
                  id: filteredTrips[index].id,
                  title: filteredTrips[index].title,
                  imageUrl: filteredTrips[index].imageUrl,
                );
              },
              itemCount: filteredTrips.length,
            ),
          ),
        ],
      ),
    );
  }
}
