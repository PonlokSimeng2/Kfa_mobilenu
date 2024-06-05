import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/contants.dart';

// ignore: camel_case_types, must_be_immutable
class Detialbody_screen extends ConsumerStatefulWidget {
  Detialbody_screen({super.key, required this.list});
  var list;
  @override
  HomeViewState createState() => HomeViewState();
}

int Total_page = 0;
List data = [];

class HomeViewState extends ConsumerState<Detialbody_screen> {
  @override
  void initState() {
    super.initState();
    setState(() {
      //print('dsddssd${list}');
    });
    // "ref" can be used in all life-cycles of a StatefulWidget.
  }

  @override
  Widget build(BuildContext context) {
    // // We can also use "ref" to listen to a provider inside the build method
    // final counter = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kwhite_new,
        centerTitle: true,
        title: const Text("Report"),
      ),
      body: PaginatedDataTable(
        horizontalMargin: 10.0,
        arrowHeadColor: Colors.blueAccent[300],
        columns: const [
          DataColumn(
            label: Text(
              'Verbal ID',
              style: TextStyle(color: Colors.green),
            ),
          ),
          DataColumn(
            label: Text(
              'Address',
              style: TextStyle(color: Colors.green),
            ),
          ),
          // DataColumn(
          //   label: Text(
          //     'Bank',
          //     style: TextStyle(color: Colors.green),
          //   ),
          // ),
          // DataColumn(
          //   label: Text(
          //     'Bank',
          //     style: TextStyle(color: Colors.green),
          //   ),
          // ),
          // DataColumn(
          //   label: Text(
          //     'Bank',
          //     style: TextStyle(color: Colors.green),
          //   ),
          // )
        ],
        // dataRowHeight: 50,
        //rowsPerPage: on_row,
        onRowsPerPageChanged: (value) {
          setState(() {
            //on_row = value!;
          });
        },
        source: _DataSource(data, Total_page, context),
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  final List data;
  final int count_row;
  final BuildContext context;
  _DataSource(this.data, this.count_row, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];
    return const DataRow(
      selected: true,
      cells: [
        DataCell(
          Text(
            'Address',
            style: TextStyle(color: Colors.green),
          ),
        ),
        DataCell(
          Text(
            'Address',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => count_row;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
