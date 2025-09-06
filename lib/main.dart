import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../view/home_page.dart';
import 'provider/symbol_provider.dart';
import 'provider/watchlist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'lib/core/api/.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SymbolProvider()..loadSymbols()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stockify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
