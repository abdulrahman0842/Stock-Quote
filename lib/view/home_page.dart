import 'package:flutter/material.dart';
import 'package:stock_quote/core/symbol_list_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _isLoading = true);
    final res = await search(query);
    setState(() {
      _results = res;
      _isLoading = false;
    });
  }

  late List<Map<String, dynamic>> symbols;
  @override
  void initState() {
    super.initState();
    loadJson();
  }

  void loadJson() async {
    symbols = await loadFromJson();
  }

  Future<List<Map<String, dynamic>>> search(String symbol) async {
    var filtered = symbols.where((row) {
      return row['symbol']
          .toString()
          .toLowerCase()
          .contains(symbol.toLowerCase());
    }).toList();
    filtered.addAll(symbols.where((row) {
      return row['name']
          .toString()
          .toLowerCase()
          .contains(symbol.toLowerCase());
    }).toList());
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stock Quote")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Search by symbol or name",
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 12),
            if (_isLoading) const LinearProgressIndicator(),
            if (_results.isEmpty) const Center(child: Text("No Result")),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final item = _results[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ListTile(
                      title: Text(item["name"] ?? ""),
                      trailing: Text(
                        item["symbol"] ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      onTap: () {
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Selected ${item["symbol"]}")),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
