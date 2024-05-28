import 'package:flutter/material.dart';

class MyDataList extends StatefulWidget {
  const MyDataList({super.key});

  @override
  _MyDataListState createState() => _MyDataListState();
}

class _MyDataListState extends State<MyDataList> {
  final List<Map<String, dynamic>> _listData = [
    {'id': 1, 'name': 'oukpov'},
    {'id': 2, 'name': 'ouk'},
  ];

  void deleteItem(int id) {
    setState(() {
      _listData.removeWhere((item) => item['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Data List'),
      ),
      body: ListView.builder(
        itemCount: _listData.length,
        itemBuilder: (context, index) {
          final item = _listData[index];
          return ListTile(
            title: Text(item['name']),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteItem(item['id']),
            ),
          );
        },
      ),
    );
  }
}
