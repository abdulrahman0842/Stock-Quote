import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stock_quote/service/api_service.dart';
import 'package:stock_quote/model/intraday_data.dart';

void main() async {
  await dotenv.load(fileName: 'lib/core/api/.env');
  group("ApiService", () {
    test("getQuoteBySymbol parses intraday data correctly", () async {
      final mockClient = MockClient((request) async {
        return http.Response(
            jsonEncode({
              "Time Series (5min)": {
                "2025-09-05 09:00:00": {
                  "1. open": "100.0",
                  "2. high": "105.0",
                  "3. low": "95.0",
                  "4. close": "102.0",
                  "5. volume": "5000"
                }
              }
            }),
            200);
      });

      ApiService.client = mockClient;

      final quotes = await ApiService.getQuoteBySymbol("IBM");

      expect(quotes, isA<List<IntradayData>>());
      expect(quotes.first.open, 100.0);
      expect(quotes.first.close, 102.0);
      expect(quotes.first.volume, 5000.0);
    });

    test("getSymbolsList returns raw CSV string", () async {
      final mockClient = MockClient((request) async {
        return http.Response("symbol,name\nIBM,IBM Corp", 200);
      });

      ApiService.client = mockClient;

      final result = await ApiService.getSymbolsList();
      expect(result, contains("IBM"));
    });

    test("fetchUsdToInrRate returns parsed exchange rate", () async {
      final mockClient = MockClient((request) async {
        return http.Response(
            jsonEncode({
              "Realtime Currency Exchange Rate": {"5. Exchange Rate": "83.25"}
            }),
            200);
      });

      ApiService.client = mockClient;

      final rate = await ApiService.fetchUsdToInrRate();
      expect(rate, isA<double>());
      expect(rate, 83.25);
    });
  });
}
