import 'package:shared_preferences/shared_preferences.dart';
import '../service/api_service.dart';

class CurrencyHandler {
  static const _exchangeKey = "usd_inr_rate";
  static const _timestampKey = "usd_inr_timestamp";

 
   Future<double> getUsdToInrRate() async {
    final prefs = await SharedPreferences.getInstance();

    final savedRate = prefs.getDouble(_exchangeKey);
    final savedTimestamp = prefs.getInt(_timestampKey);

    if (savedRate != null && savedTimestamp != null) {
      final lastFetched = DateTime.fromMillisecondsSinceEpoch(savedTimestamp);
      final now = DateTime.now();

      if (now.difference(lastFetched).inHours < 24) {
        return savedRate; 
      }
    }

    final freshRate = await ApiService.fetchUsdToInrRate();
    await prefs.setDouble(_exchangeKey, freshRate);
    await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
    return freshRate;
  }


}
