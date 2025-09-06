class IntradayData {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  IntradayData({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory IntradayData.fromJson(String time,Map<String, dynamic> json) {
    return IntradayData(
      time:DateTime.parse(time),
        open: double.parse(json["1. open"]),
        high: double.parse(json["2. high"]),
        low: double.parse(json["3. low"]),
        close: double.parse(json["4. close"]),
        volume: double.parse(json["5. volume"]));
  }
}
