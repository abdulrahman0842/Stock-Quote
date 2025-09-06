import 'package:csv/csv.dart';

Future<List<List<dynamic>>> parseCsv(String csvData) async {
  List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);
  return rows;
}

Future<List<Map<String, dynamic>>> filterStocks(
    List<List<dynamic>> rows) async {
  final dataRows = rows.skip(1);

  final filtered = dataRows.where((row) {
    final status = row[6];
    final exchange = row[2];
    final assetType = row[3];
    return (status == "Active" && exchange == "NASDAQ" && assetType == "Stock");
  });
  return filtered.map((row) {
    return {"symbol": row[0], "name": row[1], "exchange": row[2]};
  }).toList();
}
