import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomePage extends StatefulWidget {
  final Widget child;

   const HomePage({ Key? key, required this.child}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<charts.Series<Pollution, String>> _seriesData;
  late List<charts.Series<Task, String>> _seriesPieData;
  late List<charts.Series<Sales, int>> _seriesLineData;

  _generateData() {
    final data1 = [
      Pollution(1980, 'Jan', 3),
      Pollution(1980, 'Feb', 4),
      Pollution(1980, 'Mar', 10),
      Pollution(1980, 'Apr', 3),
      Pollution(1980, 'May', 4),
      Pollution(1980, 'Jun', 10),
      Pollution(1980, 'Jul', 3),
      Pollution(1980, 'Aug', 4),
      Pollution(1980, 'Sep', 10),
       Pollution(1980, 'Oct', 3),
      Pollution(1980, 'Nov', 4),
      Pollution(1980, 'Dec', 10),
    ];
    // var data2 = [
    //   new Pollution(1985, 'USA', 100),
    //   new Pollution(1980, 'Asia', 150),
    //   new Pollution(1985, 'Europe', 80),
    // ];
    // var data3 = [
    //   new Pollution(1985, 'USA', 200),
    //   new Pollution(1980, 'Asia', 300),
    //   new Pollution(1985, 'Europe', 180),
    // ];

    final piedata = [
      Task('Work', 35.8, const Color(0xff3366cc)),
      Task('Eat', 8.3, const Color(0xff990099)),
      Task('Commute', 10.8, const Color(0xff109618)),
      Task('TV', 15.6, const Color(0xfffdbe19)),
      Task('Sleep', 19.2, const Color(0xffff9900)),
      Task('Other', 10.3, const Color(0xffdc3912)),
    ];

    // var linesalesdata = [
    //   new Sales(0, 45),
    //   new Sales(1, 56),
    //   new Sales(2, 55),
    //   new Sales(3, 60),
    //   new Sales(4, 61),
    //   new Sales(5, 70),
    // ];
    final linesalesdata1 = [
      Sales(0, 35),
      Sales(1, 46),
      Sales(2, 45),
      Sales(3, 50),
      Sales(4, 51),
      Sales(5, 60),
    ];

    // var linesalesdata2 = [
    //   new Sales(0, 20),
    //   new Sales(1, 24),
    //   new Sales(2, 25),
    //   new Sales(3, 40),
    //   new Sales(4, 45),
    //   new Sales(5, 60),
    // ];

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2017',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(const Color.fromARGB(255, 41, 153, 0)),
      ), 
    );

    // _seriesData.add(
    //   charts.Series(
    //     domainFn: (Pollution pollution, _) => pollution.place,
    //     measureFn: (Pollution pollution, _) => pollution.quantity,
    //     id: '2018',
    //     data: data2,
    //     fillPatternFn: (_, __) => charts.FillPatternType.solid,
    //     fillColorFn: (Pollution pollution, _) =>
    //        charts.ColorUtil.fromDartColor(Color(0xff109618)),
    //   ),
    // );
    // _seriesData.add(
    //   charts.Series(
    //     domainFn: (Pollution pollution, _) => pollution.place,
    //     measureFn: (Pollution pollution, _) => pollution.quantity,
    //     id: '2019',
    //     data: data3,
    //     fillPatternFn: (_, __) => charts.FillPatternType.solid,
    //    fillColorFn: (Pollution pollution, _) =>
    //       charts.ColorUtil.fromDartColor(Color(0xffff9900)),
    //   ),
    // );

    // _seriesPieData.add(
    //   charts.Series(
    //     domainFn: (Task task, _) => task.task,
    //     measureFn: (Task task, _) => task.taskvalue,
    //     colorFn: (Task task, _) =>
    //         charts.ColorUtil.fromDartColor(task.colorval),
    //     id: 'Air Pollution',
    //     data: piedata,
    //      labelAccessorFn: (Task row, _) => '${row.taskvalue}',
    //   ),
    // );

    // _seriesLineData.add(
    //   charts.Series(
    //     colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
    //     id: 'Air Pollution',
    //     data: linesalesdata,
    //     domainFn: (Sales sales, _) => sales.yearval,
    //     measureFn: (Sales sales, _) => sales.salesval,
    //   ),
    // );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(const Color(0xff109618)),
        id: 'Air Pollution',
        data: linesalesdata1,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    // _seriesLineData.add(
    //   charts.Series(
    //     colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
    //     id: 'Air Pollution',
    //     data: linesalesdata2,
    //     domainFn: (Sales sales, _) => sales.yearval,
    //     measureFn: (Sales sales, _) => sales.salesval,
    //   ),
    // );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesData = <charts.Series<Pollution, String>>[];
    _seriesPieData = <charts.Series<Task, String>>[];
    _seriesLineData = <charts.Series<Sales, int>>[];
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff1976d2),
            //backgroundColor: Color(0xff308e1c),
            // bottom: TabBar(
            //   indicatorColor: Color(0xff9962D0),
            //   // tabs: [
            //   //   Tab(
            //   //     icon: Icon(FontAwesomeIcons.solidChartBar),
            //   //   ),
            //   //   // Tab(icon: Icon(FontAwesomeIcons.chartPie)),
            //   //   // Tab(icon: Icon(FontAwesomeIcons.chartLine)),
            //   // ],
            // ),
            title: const Text('Flutter Charts'),
          ),
          body: Container(
            color: Colors.amber,
            height: 200,
            child: Center(
              child: Column(
                children: <Widget>[
                  // Text(
                  //     'Report',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                  Expanded(
                    child: charts.BarChart(
                      _seriesData,
                      animate: true,
                      barGroupingType: charts.BarGroupingType.grouped,
                      //behaviors: [new charts.SeriesLegend()],
                      animationDuration: const Duration(seconds: 5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Pollution {
  String place;
  int year;
  int quantity;

  Pollution(this.year, this.place, this.quantity);
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}

// import 'package:flutter/material.dart';
// import 'package:pie_chart/pie_chart.dart';

// class HomePagePiechart extends StatelessWidget {
//   Map<String, double> dataMap = {
//     "Flutter": 5,
//     "React": 3,
//     "Xamarin": 2,
//     "Ionic": 2,
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Pie Chart"),
//         centerTitle: true,
//         backgroundColor: Colors.green[700],
//         brightness: Brightness.dark,
//       ),
//       body: Container(
//         child: Center(
//           child: PieChart(
//             dataMap: dataMap,
//             chartRadius: MediaQuery.of(context).size.width / 1.7,
//             legendOptions: LegendOptions(
//               legendPosition: LegendPosition.bottom,
//             ),
//             chartValuesOptions: ChartValuesOptions(
//               showChartValuesInPercentage: true,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }