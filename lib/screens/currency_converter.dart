import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/exchange_service.dart';

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';
  double? result;
  final TextEditingController controller = TextEditingController();

  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-5754664066089308/7080345793',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner failed to load: $error');
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    controller.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  void convert() async {
    final rate = await fetchExchangeRate(fromCurrency, toCurrency);
    final amount = double.tryParse(controller.text);
    if (rate != null && amount != null) {
      setState(() => result = amount * rate);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('invalid_input_or_failed'.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'currency_converter'.tr(),
          style: TextStyle(fontFamily: 'Preahvihear-Regular'),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'amount'.tr(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildDropdown(fromCurrency, (val) {
                  setState(() => fromCurrency = val!);
                }),
                Icon(Icons.swap_horiz, size: 28),
                buildDropdown(toCurrency, (val) {
                  setState(() => toCurrency = val!);
                }),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: convert,
              child: Text('convert'.tr()),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 34, vertical: 14),
              ),
            ),
            if (result != null)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Card(
                  color: Colors.blue.shade50,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.attach_money, color: Colors.blue, size: 28),
                        SizedBox(width: 10),
                        Text(
                          '${'result'.tr()}: ${result!.toStringAsFixed(2)} $toCurrency',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _isBannerAdReady
          ? Container(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : null,
    );
  }

  DropdownButton<String> buildDropdown(
    String value,
    ValueChanged<String?> onChanged,
  ) {
    const currencies = [
      'USD',
      'EUR',
      'GBP',
      'JPY',
      'RUB',
      'JOD',
      'TRY',
      'CNY',
      'THB',
      'MXN',
    ];
    return DropdownButton<String>(
      value: value,
      items: currencies
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
