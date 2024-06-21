import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kfa_mobilenu/widgets/auth_wrapper_widget.dart';
import '../components/contants.dart';
import 'AutoVerbal/Detail.dart';

// ignore: must_be_immutable
class MyDataTablePage extends StatefulWidget {
  const MyDataTablePage({
    super.key,
  });
  //String? name;

  @override
  State<MyDataTablePage> createState() => _MyDataTablePageState();
}

List list = [];

class _MyDataTablePageState extends State<MyDataTablePage> {
  // ignore: non_constant_identifier_names
  Future<void> ComparableList_search_data() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/autoverbal/list_new?verbal_user=219K591F219A',
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonBody = jsonDecode(response.body);
        list = jsonBody;
        setState(() {
          list;
        });
      } else {
        print('Error Comparable Date');
      }
    } catch (e) {
      print('Error value_all_list $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      ComparableList_search_data();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthWrapperWidget(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kwhite_new,
          elevation: 15,
          shadowColor: Colors.grey,
          centerTitle: true,
          title: const Text('Report'),
        ),
        body: SingleChildScrollView(
          child: PaginatedDataTable(
              showFirstLastButtons: true,
              actions: const [
                Column(
                  children: [
                    Text('Total='),
                  ],
                ),
              ],
              header: Text(""),
              columns: const [
                // DataColumn(label: Text('Auto Verbal Id')),
                DataColumn(label: Text('Auto Verbal Id')),
                DataColumn(label: Text('Owner')),
                DataColumn(label: Text('Property type')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('Date')),
              ],
              source: MyDataSource(list, context),
              rowsPerPage: 15,
              //columnSpacing: 50,
              horizontalMargin: 54.0,
              dataRowHeight: 60),
        ),
      ),
    );
  }
}

class MyDataSource extends DataTableSource {
  List list;
  final BuildContext context;
  MyDataSource(this.list, this.context);
  @override
  DataRow getRow(int index) {
    final data = list[index];
    return DataRow(
      cells: [
        // DataCell(Text(data['comparable_id'].toString())),
        DataCell(
          Text(data['verbal_id'].toString()),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const detail_verbal(
                  set_data_verbal: '219K591F219Aacxfdiqmu',
                ),
              ),
            );
          },
        ),
        DataCell(Text(data['verbal_owner'].toString())),
        DataCell(Text(data['property_type_name'].toString())),
        DataCell(Text(data['verbal_contact'].toString())),
        DataCell(Text(data['verbal_created_date'].toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => list.length;
  @override
  int get selectedRowCount => 0;
}
