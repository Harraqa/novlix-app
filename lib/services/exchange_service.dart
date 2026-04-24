import 'package:http/http.dart' as http;
import 'dart:convert';

Future<double?> fetchExchangeRate(String from, String to) async {
  const apiKey = '4b041ce28c68a93ccdf18503e5d21ebf';
  final url = Uri.parse(
    'https://api.exchangerate.host/convert?from=$from&to=$to&amount=1&access_key=$apiKey',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['success'] == true) {
      return data['result'].toDouble();
    }
  }
  return null;
}
