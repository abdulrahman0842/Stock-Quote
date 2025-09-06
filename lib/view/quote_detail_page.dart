import 'package:flutter/material.dart';
import 'package:stock_quote/service/api_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../core/currency_handler.dart';
import '../model/intraday_data.dart';

class QuoteDetailPage extends StatefulWidget {
  const QuoteDetailPage({super.key, required this.symbol});
  final String symbol;

  @override
  State<QuoteDetailPage> createState() => _QuoteDetailPageState();
}

class _QuoteDetailPageState extends State<QuoteDetailPage> {
  double? usdInrRate;

  @override
  void initState() {
    super.initState();
    _loadExchangeRate();
  }

  void _loadExchangeRate() async {
    try {
      final rate = await CurrencyHandler().getUsdToInrRate();
      setState(() => usdInrRate = rate);
    } catch (e) {
      debugPrint("Error fetching exchange rate: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.symbol} (₹)",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<IntradayData>>(
        future: ApiService.getQuoteBySymbol(widget.symbol),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              usdInrRate == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            var data = snapshot.data!;
            final rate = usdInrRate!;

            return Column(
              children: [
                // Chart
                Expanded(
                  flex: 2,
                  child: Card(
                    margin: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SfCartesianChart(
                        primaryXAxis: DateTimeAxis(
                          intervalType: DateTimeIntervalType.minutes,
                          dateFormat: DateFormat("HH:mm"),
                          majorGridLines: const MajorGridLines(width: 0),
                        ),
                        primaryYAxis: NumericAxis(
                          opposedPosition: true,
                          majorGridLines: const MajorGridLines(width: 0.2),
                          numberFormat: NumberFormat.simpleCurrency(
                            locale: "en_IN",
                            name: "₹",
                          ),
                        ),
                        zoomPanBehavior: ZoomPanBehavior(
                          enablePinching: true,
                          enablePanning: true,
                        ),
                        trackballBehavior: TrackballBehavior(
                          enable: true,
                          activationMode: ActivationMode.singleTap,
                          tooltipSettings: const InteractiveTooltip(
                            enable: true,
                            color: Colors.black87,
                            textStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                        series: <CandleSeries>[
                          CandleSeries<IntradayData, DateTime>(
                            dataSource: data,
                            xValueMapper: (d, _) => d.time,
                            lowValueMapper: (d, _) => d.low * rate,
                            highValueMapper: (d, _) => d.high * rate,
                            openValueMapper: (d, _) => d.open * rate,
                            closeValueMapper: (d, _) => d.close * rate,
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                // Quotes List 
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var quote = data[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            "Open: ₹${(quote.open * rate).toStringAsFixed(2)}  |  Close: ₹${(quote.close * rate).toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "High: ₹${(quote.high * rate).toStringAsFixed(2)}   Low: ₹${(quote.low * rate).toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: Text(
                            DateFormat("HH:mm").format(quote.time),
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }
}
