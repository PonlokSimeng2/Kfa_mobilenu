import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyHomePageReport extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyHomePageReport({
    Key? key,
    required this.datavalue,
    required this.datavaluejan,
    required this.datavaluefeb,
    required this.datavaluemar,
    required this.datavalueapr,
    required this.datavaluemay,
    required this.datavaluejun,
    required this.datavaluejul,
    required this.datavalueaug,
    required this.datavaluesep,
    required this.datavalueoct,
    required this.datavaluenov,
    required this.datavaluedec,
  }) : super(key: key);
  final double? datavalue;
  final double? datavaluejan;
  final double? datavaluefeb;
  final double? datavaluemar;
  final double? datavalueapr;
  final double? datavaluemay;
  final double? datavaluejun;
  final double? datavaluejul;
  final double? datavalueaug;
  final double? datavaluesep;
  final double? datavalueoct;
  final double? datavaluenov;
  final double? datavaluedec;
  @override
  MyHomePageReportState createState() => MyHomePageReportState();
}

class MyHomePageReportState extends State<MyHomePageReport> {
  List<_SalesData>? data;
  @override
  void initState() {
    data = [
      _SalesData('Jan', widget.datavaluejan ?? 0),
      _SalesData('Feb', widget.datavaluefeb ?? 0),
      _SalesData('Mar', widget.datavaluemar ?? 0),
      _SalesData('Apr', widget.datavalueapr ?? 0),
      _SalesData('May', widget.datavaluemay ?? 0),
      _SalesData('Jun', widget.datavaluejun ?? 0),
      _SalesData('Jul', widget.datavaluejul ?? 0),
      _SalesData('Aug', widget.datavalueaug ?? 0),
      _SalesData('Sep', widget.datavaluesep ?? 0),
      _SalesData('Oct', widget.datavalueoct ?? 0),
      _SalesData('Nov', widget.datavaluenov ?? 0),
      _SalesData('Dec', widget.datavaluedec ?? 0),
    ];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        legend: Legend(isVisible: true),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<_SalesData, String>>[
          ColumnSeries<_SalesData, String>(
            dataSource: data!,
            xValueMapper: (_SalesData sales, _) => sales.year,
            yValueMapper: (_SalesData sales, _) => sales.sales,
            name: 'Verbal',
            // Enable data label
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
