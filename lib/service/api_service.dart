import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stock_quote/core/api/api_endpoints.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<void> getQuoteBySymbol(String symbol) async {
    final apikey = dotenv.env["API_KEY"] ?? "";

    final url = ApiEndpoints.timeSeriesIntraday(
        symbol: symbol, interval: "5min", apikey: apikey);

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        log(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

static Future<String> getSymbolsList() async {
    final apikey = dotenv.env["API_KEY"] ?? "";
    final url = ApiEndpoints.symbolList(apikey: apikey);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception("${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
