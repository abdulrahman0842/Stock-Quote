import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stock_quote/core/api/api_endpoints.dart';
import 'package:http/http.dart' as http;
import '../model/intraday_data.dart';

class ApiService {
  static http.Client client = http.Client();

  static Future<List<IntradayData>> getQuoteBySymbol(String symbol) async {
    final apikey = dotenv.env["API_KEY"] ?? "";

    final url = ApiEndpoints.timeSeriesIntraday(
        symbol: symbol, interval: "5min", apikey: apikey);

    try {
      // Due to API Rate Limit issue, DEMO API KEY is hardcoded
      // To use real API replace the Hardcoded API with above declared url;
      final response = await client.get(Uri.parse(
          "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=5min&apikey=demo"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final timeSeries = data["Time Series (5min)"] as Map<String, dynamic>;
        final quotes = timeSeries.entries
            .map((element) => IntradayData.fromJson(element.key, element.value))
            .toList();
        return quotes;
      } else {
        throw Exception("${response.statusCode}:${response.body}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> getSymbolsList() async {
    final apikey = dotenv.env["API_KEY"] ?? "";
    final url = ApiEndpoints.symbolList(apikey: apikey);
    try {
      
      // Due to API Rate Limit issue, DEMO API KEY is hardcoded
      // To use real API replace the Hardcoded API with above declared url;
      final response = await client.get(Uri.parse(
          "https://www.alphavantage.co/query?function=LISTING_STATUS&apikey=demo"));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception("${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<double> fetchUsdToInrRate() async {
    final apikey = dotenv.env["API_KEY"] ?? "";
    final url = ApiEndpoints.usdToInr(apikey: apikey);

    final response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return double.parse(
        data["Realtime Currency Exchange Rate"]["5. Exchange Rate"],
      );
    } else {
      throw Exception("Failed to fetch USD → INR rate");
    }
  }
}
