import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:stock_quote/core/csv_handler.dart';
import 'package:stock_quote/service/api_service.dart';

Future<void> saveToJson(List<Map<String, dynamic>> csvData) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File("${dir.path}/symbols.json");
  await file.writeAsString(jsonEncode(csvData));
}

Future<List<Map<String, dynamic>>> loadFromJson() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File("${dir.path}/symbols.json");
  if (await file.exists()) {
    final data = await file.readAsString();
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }
  return [];
}

Future<void> initSymbols() async {
  final csvData = await ApiService.getSymbolsList();
  final parsedCsv = await parseCsv(csvData);
  final symbolsList = await filterStocks(parsedCsv);
  await saveToJson(symbolsList);
}
