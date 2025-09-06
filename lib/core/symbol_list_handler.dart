import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_quote/core/csv_handler.dart';
import 'package:stock_quote/service/api_service.dart';

class SymbolHandler {
  static const _lastUpdatedKey = "symbols_last_updated";

  /// Save parsed symbols to local file
  static Future<void> _saveToJson(List<Map<String, dynamic>> csvData) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/symbols.json");
    await file.writeAsString(jsonEncode(csvData));
  }

  /// Load cached symbols from local file
  static Future<List<Map<String, dynamic>>> _loadFromJson() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/symbols.json");
    if (await file.exists()) {
      final data = await file.readAsString();
      return List<Map<String, dynamic>>.from(jsonDecode(data));
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> getSymbols() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdatedMillis = prefs.getInt(_lastUpdatedKey);
    final now = DateTime.now();

    // Check if last update is within 24 hours
    if (lastUpdatedMillis != null) {
      final lastUpdated =
          DateTime.fromMillisecondsSinceEpoch(lastUpdatedMillis);
      if (now.difference(lastUpdated).inHours < 24) {
        return await _loadFromJson();
      }
    }

    final csvData = await ApiService.getSymbolsList();
    final parsedCsv = await parseCsv(csvData);
    final symbolsList = await filterStocks(parsedCsv);
    await _saveToJson(symbolsList);
    await prefs.setInt(_lastUpdatedKey, now.millisecondsSinceEpoch);
    return symbolsList;
  }
}
