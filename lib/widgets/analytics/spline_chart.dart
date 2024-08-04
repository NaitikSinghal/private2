import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SplineChart extends StatefulWidget {
  const SplineChart({super.key});

  @override
  State<SplineChart> createState() => _SplineChartState();
}

class _SplineChartState extends State<SplineChart> {
  List<ChartSampleData>? chartData;
  @override
  void initState() {
    chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Jan', y: 120, secondSeriesYValue: 99, thirdSeriesYValue: 120),
      ChartSampleData(
          x: 'Feb', y: 210, secondSeriesYValue: 89, thirdSeriesYValue: 100),
      ChartSampleData(
          x: 'Mar', y: 140, secondSeriesYValue: 130, thirdSeriesYValue: 70),
      ChartSampleData(
          x: 'Apr', y: 160, secondSeriesYValue: 190, thirdSeriesYValue: 52),
      ChartSampleData(
          x: 'May', y: 190, secondSeriesYValue: 110, thirdSeriesYValue: 57),
      ChartSampleData(
          x: 'Jun', y: 220, secondSeriesYValue: 210, thirdSeriesYValue: 61),
      ChartSampleData(
          x: 'Jul', y: 240, secondSeriesYValue: 250, thirdSeriesYValue: 200),
      ChartSampleData(
          x: 'Aug', y: 250, secondSeriesYValue: 230, thirdSeriesYValue: 120),
      ChartSampleData(
          x: 'Sep', y: 230, secondSeriesYValue: 280, thirdSeriesYValue: 170),
      ChartSampleData(
          x: 'Oct', y: 220, secondSeriesYValue: 300, thirdSeriesYValue: 190),
      ChartSampleData(
          x: 'Nov', y: 180, secondSeriesYValue: 270, thirdSeriesYValue: 240),
      ChartSampleData(
          x: 'Dec', y: 165, secondSeriesYValue: 268, thirdSeriesYValue: 250)
    ];
    super.initState();
  }

  SfCartesianChart _buildDefaultSplineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: 'Orders vs Sale',
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
      legend: Legend(isVisible: true, position: LegendPosition.bottom),
      primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelPlacement: LabelPlacement.onTicks),
      primaryYAxis: NumericAxis(
          minimum: 50,
          maximum: 300,
          axisLine: const AxisLine(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelFormat: '{value}',
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultSplineSeries(),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        color: HexColor('#4318FF'),
      ),
    );
  }

  List<SplineSeries<ChartSampleData, String>> _getDefaultSplineSeries() {
    return <SplineSeries<ChartSampleData, String>>[
      SplineSeries<ChartSampleData, String>(
        dataSource: chartData!,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        markerSettings: const MarkerSettings(isVisible: true),
        name: 'Sale(k)',
      ),
      SplineSeries<ChartSampleData, String>(
        dataSource: chartData!,
        name: 'Orders',
        markerSettings: const MarkerSettings(isVisible: true),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
      )
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: _buildDefaultSplineChart(),
    );
  }
}

class ChartSampleData {
  final String x;
  final int y;
  final int secondSeriesYValue;
  final int thirdSeriesYValue;
  ChartSampleData(
      {required this.x,
      required this.y,
      required this.secondSeriesYValue,
      required this.thirdSeriesYValue});
}
