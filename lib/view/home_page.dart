import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_quote/core/widgets/stock_card_widget.dart';
import '../../provider/symbol_provider.dart';
import '../../provider/watchlist_provider.dart';
import '../core/symbol_list_handler.dart';
import '../service/api_service.dart';
import 'watchlist_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _debounce;

  void _onSearchChanged(String query, SymbolProvider provider) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      provider.search(query);
    });
  }

  @override
  void initState() {
    super.initState();
    ApiService.getSymbolsList();
  }

  @override
  Widget build(BuildContext context) {
    final watchlistProvider = Provider.of<WatchlistProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Quote"),
        actions: [
          IconButton(
              onPressed: () {
                SymbolHandler.getSymbols();
              },
              icon: Icon(Icons.add)),
          IconButton(
            icon: Icon(
              Icons.star,
              color: Theme.of(context).primaryColor,
            ),
            tooltip: "Watchlist",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WatchlistPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(12),
          child: Consumer<SymbolProvider>(
              builder: (context, symbolProvider, child) {
            return Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Search by symbol or name",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (val) => _onSearchChanged(val, symbolProvider),
                ),
                const SizedBox(height: 12),
                if (symbolProvider.isLoading) const LinearProgressIndicator(),
                Expanded(
                  child: symbolProvider.results.isEmpty
                      ? const Center(child: Text("No results"))
                      : ListView.builder(
                          itemCount: symbolProvider.results.length,
                          itemBuilder: (context, index) {
                            final item = symbolProvider.results[index];
                            final isInWatchlist =
                                watchlistProvider.isInWatchlist(item);

                            return StockCardWidget(
                                item: item,
                                isInWatchlist: isInWatchlist,
                                watchlistProvider: watchlistProvider);
                          },
                        ),
                ),
              ],
            );
          })),
    );
  }
}
