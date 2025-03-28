import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Currency {
  final String name;
  final double rate;
  Currency(this.name, this.rate);
}

class CurrencyResponse {
  final Map<String, double> rates;
  const CurrencyResponse({required this.rates});

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('data') || json['data'] is! Map<String, dynamic>) {
      throw const FormatException('Invalid currency API response format.');
    }

    final Map<String, double> parsedData =
        (json['data'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, (value as num).toDouble()));

    return CurrencyResponse(rates: parsedData);
  }
}

class CurrencyService {
  static final String url = 'https://api.freecurrencyapi.com/v1/latest';
  final String _apiKey = dotenv.env['FREECURRENCY_API_KEY'] ?? '';

  Future<Map<String, double>> getCurrencyRate() async {
    if (_apiKey.isEmpty) {
      throw Exception('API key is missing. Please configure the API key.');
    }
    try {
      final response = await http.get(Uri.parse("$url?apikey=$_apiKey"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        if (!decodedJson.containsKey('data')) {
          throw const FormatException('Invalid API response');
        }
        final CurrencyResponse data = CurrencyResponse.fromJson(decodedJson);

        return data.rates;
      } else {
        print("Failed to load currencies: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
    return {};
  }
}
