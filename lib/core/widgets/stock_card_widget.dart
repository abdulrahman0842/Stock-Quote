import 'package:flutter/material.dart';
import 'package:stock_quote/provider/watchlist_provider.dart';
import 'package:stock_quote/view/quote_detail_page.dart';

class StockCardWidget extends StatelessWidget {
  const StockCardWidget({
    super.key,
    required this.item,
    required this.isInWatchlist,
    required this.watchlistProvider,
  });

  final Map<String, dynamic> item;
  final bool isInWatchlist;
  final WatchlistProvider watchlistProvider;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(item["name"] ?? ""),
        subtitle: Text(item["symbol"] ?? ""),
        trailing: IconButton(
          icon: Icon(
            isInWatchlist ? Icons.star : Icons.star_border,
            color:
                isInWatchlist ? Colors.amber : Colors.grey,
          ),
          onPressed: () =>
              watchlistProvider.toggleWatchlist(item),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuoteDetailPage(
                  symbol: item["symbol"] ?? ""),
            ),
          );
        },
      ),
    );
  }
}
