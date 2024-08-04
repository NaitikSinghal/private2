import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ViewsChart extends StatefulWidget {
  const ViewsChart({super.key});

  @override
  State<ViewsChart> createState() => _ViewsChartState();
}

class _ViewsChartState extends State<ViewsChart> {
  late List<_ChartData> data;

  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('Sun', 12),
      _ChartData('Mon', 15),
      _ChartData('Tue', 30),
      _ChartData('Wed', 6.4),
      _ChartData('Thu', 14),
      _ChartData('Fri', 14),
      _ChartData('Sat', 14),
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Daily clickies views : 4.2k',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 40,
              interval: 10,
              majorGridLines: const MajorGridLines(width: 0),
            ),
            tooltipBehavior: _tooltip,
            series: <ChartSeries<_ChartData, String>>[
              ColumnSeries<_ChartData, String>(
                dataSource: data,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                name: 'Gold',
                color: Colors.blue,
                width: 0.35,
                gradient: LinearGradient(colors: [
                  HexColor('#F582FF'),
                  HexColor('#ED18FF'),
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
