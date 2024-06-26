import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:io';

Future<void> generateAndSharePdf() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text(
            'Hello World',
            style: pw.TextStyle(fontSize: 24),
          ),
        );
      },
    ),
  );

  // Get the temporary directory
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/Verbalform.pdf");

  // Save the PDF file
  await file.writeAsBytes(await pdf.save());
  print('PDF saved to ${file.path}');

  // Share the PDF file
  // ignore: deprecated_member_use
  await Share.shareFiles([file.path], text: 'Check out this PDF file!');
}

class MyAppTestPDF extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('PDF Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: generateAndSharePdf,
            child: Text('Generate and Share PDF'),
          ),
        ),
      ),
    );
  }
}
