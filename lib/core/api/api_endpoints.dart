class ApiEndpoints {
  static const baseUrl = "https://www.alphavantage.co/query";
  static String timeSeriesIntraday(
      {required String symbol,
      required String interval,
      required String apikey}) {
    return "$baseUrl?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=$interval&apikey=$apikey";
  }
  static String symbolList({required String apikey}){
    return "$baseUrl?function=LISTING_STATUS&apikey=$apikey";
  }
}
