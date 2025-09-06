class ApiEndpoints {
  static const baseUrl = "https://www.alphavantage.co/query";
  static String timeSeriesIntraday(
      {required String symbol,
      required String interval,
      required String apikey}) {
    return "$baseUrl?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=$interval&apikey=$apikey";
  }

  static String symbolList({required String apikey}) {
    return "$baseUrl?function=LISTING_STATUS&apikey=$apikey";
  }

  static String usdToInr({required String apikey}) {
    return "$baseUrl?function=CURRENCY_EXCHANGE_RATE&from_currency=USD&to_currency=INR&apikey=$apikey";
  }


}
