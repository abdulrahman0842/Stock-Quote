import 'package:flutter/material.dart';
import '../core/symbol_list_handler.dart';

class SymbolProvider with ChangeNotifier {
  List<Map<String, dynamic>> _symbols = [];
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get results => _results;
  bool get isLoading => _isLoading;

  Future<void> loadSymbols() async {
    _symbols = await SymbolHandler.getSymbols();
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _results = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    final filtered = _symbols.where((row) {
      return row['symbol']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          row['name'].toString().toLowerCase().contains(query.toLowerCase());
    }).toList();
    _results = filtered.toSet().toList();
    _isLoading = false;
    notifyListeners();
  }
}
