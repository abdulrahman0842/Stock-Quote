import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_quote/core/widgets/stock_card_widget.dart';
import '../../provider/watchlist_provider.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final watchlistProvider = Provider.of<WatchlistProvider>(context);

    return Scaffold(
        appBar: AppBar(title: const Text("My Watchlist")),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: watchlistProvider.watchlist.isEmpty
              ? const Center(child: Text("No stocks in your watchlist"))
              : ListView.builder(
                  itemCount: watchlistProvider.watchlist.length,
                  itemBuilder: (context, index) {
                    final item = watchlistProvider.watchlist[index];
                    return StockCardWidget(
                        item: item,
                        isInWatchlist: watchlistProvider.isInWatchlist(item),
                        watchlistProvider: watchlistProvider);
                  },
                ),
        ));
  }
}
