import 'package:flutter/material.dart';

class WatchlistProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _watchlist = [];

  List<Map<String, dynamic>> get watchlist => _watchlist;

  void toggleWatchlist(Map<String, dynamic> item) {
    if (_watchlist.contains(item)) {
      _watchlist.remove(item);
    } else {
      _watchlist.add(item);
    }
    notifyListeners();
  }

  bool isInWatchlist(Map<String, dynamic> item) {
    return _watchlist.contains(item);
  }
}
