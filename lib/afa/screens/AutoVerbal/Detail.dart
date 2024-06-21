// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import '../../../models/autoVerbal.dart';
import '../../components/contants.dart';

class detail_verbal extends StatefulWidget {
  const detail_verbal({super.key, required this.set_data_verbal});
  final String set_data_verbal;
  @override
  State<detail_verbal> createState() => _detail_searchingState();
}

var formatter1 = NumberFormat("###.#####", "en_US");

class _detail_searchingState extends State<detail_verbal> {
  List list = [];

  void get_all_autoverbal_by_id() async {
    var rs = await http.get(
      Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/autoverbal/list_new?verbal_id=${widget.set_data_verbal.toString()}',
      ),
    );

    if (rs.statusCode == 200) {
      setState(() {
        list = jsonDecode(rs.body);
        Land_building();
        image_m =
            'https://maps.googleapis.com/maps/api/staticmap?center=${list[0]["latlong_log"]},${list[0]["latlong_la"]}&zoom=20&size=1080x920&maptype=hybrid&markers=color:red%7C%7C${list[0]["latlong_log"]},${list[0]["latlong_la"]}&key=AIzaSyAJt0Zghbk3qm_ZClIQOYeUT0AaV5TeOsI';
        image_i = list[0]['verbal_image'].toString();
      });
    }
  }

  var image_i, get_image = [];
  // Future<void> getimage() async {
  //   final rs = await http.get(
  //     Uri.parse(
  //       'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/get_image/${widget.set_data_verbal.toString()}',
  //     ),
  //   );
  //   if (rs.statusCode == 200) {
  //     final jsonData = jsonDecode(rs.body);
  //     setState(() {
  //       get_image = jsonData;
  //       image_i = get_image[0]['url'];
  //     });
  //   }
  // }

  var image_m;

  double? total_MIN = 0;
  double? total_MAX = 0;
  List<AutoVerbal_List> data_pdf = [];
  List land = [];
  double? fsvM, fsvN, fx, fn;
  Future<void> Land_building() async {
    double x = 0, n = 0;
    final rs = await http.get(
      Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/autoverbal/list_land?verbal_landid=${widget.set_data_verbal.toString()}',
      ),
    );
    if (rs.statusCode == 200) {
      land = jsonDecode(rs.body);
      for (int i = 0; i < land.length; i++) {
        total_MIN = total_MIN! +
            double.parse(land[i]["verbal_land_minvalue"].toString());
        total_MAX = total_MAX! +
            double.parse(land[i]["verbal_land_maxvalue"].toString());
        // address = land[i]["address"];
        x = x + double.parse(land[i]["verbal_land_maxsqm"].toString());
        n = n + double.parse(land[i]["verbal_land_minsqm"].toString());
      }
      setState(() {
        final double c1 =
            (total_MAX! * double.parse(list[0]["verbal_con"].toString())) / 100;
        fsvM = (total_MAX! - c1);
        final double c2 =
            (total_MIN! * double.parse(list[0]["verbal_con"].toString())) / 100;
        fsvN = (total_MIN! - c2);

        if (land.isEmpty) {
          total_MIN = 0;
          total_MAX = 0;
        } else {
          fx = x * (double.parse(list[0]["verbal_con"].toString()) / 100);
          fn = n * (double.parse(list[0]["verbal_con"].toString()) / 100);
        }
        for (int i = 0; i < land.length - 1; i++) {
          for (int j = i + 1; j < land.length; j++) {
            if (land[i]['verbal_land_type'] == 'LS') {
              final t = land[i];
              land[i] = land[j];
              land[j] = t;
            }
          }
        }
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {});
  }

  void generatePdf() async {
    setState(() {
      Future.delayed(const Duration(seconds: 2), () {
        Printing.layoutPdf(onLayout: (format) => _generatePdf(format));
      });
    });
  }

  Future<void> shareImage(GlobalKey globalKey, context) async {
    try {
      final RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = File('${(await getTemporaryDirectory()).path}/share.png');
      imgFile.writeAsBytesSync(pngBytes);
      final RenderBox box = context.findRenderObject() as RenderBox;
      Share.shareXFiles(
        [XFile(imgFile.path)],
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    get_all_autoverbal_by_id();

    // TODO: implement initState
    super.initState();
  }

  final GlobalKey _globalKeyScreenShot = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detail Verbal"),
        backgroundColor: kwhite_new,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_sharp)),
        elevation: 15,
        shadowColor: Color.fromARGB(255, 34, 34, 35),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: InkWell(
              child: Icon(Icons.share),
              onTap: () {
                shareImage(_globalKeyScreenShot, context);
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blue[50],
      body: (list.isNotEmpty)
          ? SafeArea(
              child: RepaintBoundary(
                key: _globalKeyScreenShot,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      Container(
                        height: 70,
                        margin: EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 75,
                                height: 50,
                                child: Image.asset(
                                    'assets/images/New_KFA_Logo_pdf.png')),
                            const Text("VERBAL CHECK",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                )),
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        BarcodeWidget(
                                          barcode: Barcode.qrCode(
                                            errorCorrectLevel:
                                                BarcodeQRCorrectionLevel.high,
                                          ),
                                          data:
                                              "https://www.oneclickonedollar.com/#/${list[0]["verbal_id"]}",
                                          width: 50,
                                          height: 50,
                                        ),
                                        Container(
                                          color: Colors.white,
                                          width: 10,
                                          height: 10,
                                          child: Image.asset(
                                            'assets/images/New_KFA_Logo.png',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      'verifications PNG',
                                      style: TextStyle(
                                        fontSize: 6,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        BarcodeWidget(
                                          barcode: Barcode.qrCode(
                                            errorCorrectLevel:
                                                BarcodeQRCorrectionLevel.high,
                                          ),
                                          data:
                                              'https://www.latlong.net/c/?lat=${list[0]['latlong_log']}&long=${list[0]['latlong_la']}',
                                          width: 50,
                                          height: 50,
                                        ),
                                        Container(
                                          color: Colors.white,
                                          width: 10,
                                          height: 10,
                                          child: Image.asset(
                                            'assets/images/New_KFA_Logo.png',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      'location map',
                                      style: TextStyle(
                                        fontSize: 6,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(children: [
                        Row(children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              alignment: Alignment.centerLeft,
                              decoration:
                                  BoxDecoration(border: Border.all(width: 0.4)),
                              height: 18,
                              //color: Colors.red,
                              child: Text(
                                  "DATE: ${list[0]['verbal_created_date'].toString()}",
                                  style: const TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.bold)),
                              //color: Colors.white,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              alignment: Alignment.centerLeft,
                              decoration:
                                  BoxDecoration(border: Border.all(width: 0.4)),
                              height: 18,
                              child: Text(
                                  "CODE: ${list[0]['verbal_id'].toString()}",
                                  style: const TextStyle(
                                    fontSize: 7,
                                    fontWeight: FontWeight.bold,
                                  )),
                              //color: Colors.yellow,
                            ),
                          ),
                        ])
                      ]),
                      SizedBox(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                height: 18,
                                child: Text(
                                    "Requested Date :${list[0]['verbal_created_date'].toString()} ",
                                    style: const TextStyle(
                                      fontSize: 7,
                                    )),
                                //color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        alignment: Alignment.topLeft,
                        decoration:
                            BoxDecoration(border: Border.all(width: 0.4)),
                        height: 25,
                        child: Text(
                            "Referring to your request letter for verbal check by ${list[0]['bank_name'].toString()}, we estimated the value of property as below.",
                            overflow: TextOverflow.clip,
                            style: const TextStyle(fontSize: 6)),
                        //color: Colors.blue,
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                height: 18,
                                child: const Text("Property Information: ",
                                    style: TextStyle(
                                      fontSize: 7,
                                    )),
                                //color: Colors.blue,
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                height: 18,
                                child: Text(
                                    " ${list[0]['property_type_name'] ?? ''}",
                                    style: const TextStyle(
                                      fontSize: 7,
                                    )),
                                //color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                height: 18,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                child: const Text("Address : ",
                                    style: TextStyle(
                                      fontSize: 7,
                                    )),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                height: 18,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                child: Text(
                                    " ${list[0]['verbal_address'] ?? ""}.${list[0]['verbal_khan'] ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 7,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                height: 18,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                child: const Text("Owner Name ",
                                    style: TextStyle(
                                      fontSize: 7,
                                    )),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                height: 18,
                                child: Text(" ${list[0]['verbal_owner'] ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 7,
                                    )),

                                //color: Colors.blue,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                height: 18,
                                // name rest with api
                                child: Text(
                                    "Contact No : ${list[0]['verbal_contact'] ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 7,
                                    )),
                                //color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                height: 30,
                                child: const Text("Bank Officer ",
                                    style: TextStyle(
                                      fontSize: 7,
                                    )),
                                //color: Colors.blue,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                height: 30,
                                child: Text(" ${list[0]['bank_name'] ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 7,
                                    )),
                                //color: Colors.blue,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                height: 30,
                                child: Text(
                                    "Contact No : ${list[0]['verbal_bank_contact'] ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 7,
                                    )),
                                //color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                height: 18,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                child: Text(
                                    "Latitude: ${formatter1.format(list[0]['latlong_log'])}",
                                    style: const TextStyle(
                                      fontSize: 7,
                                    )),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                height: 18,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                child: Text(
                                    "Longtitude: ${formatter1.format(list[0]['latlong_la'])}",
                                    style: const TextStyle(fontSize: 7)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text("ESTIMATED VALUE OF THE VERBAL CHECK PROPERTY",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 7,
                          )),
                      const SizedBox(height: 6),
                      if (image_i != null || image_i != "No")
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://maps.googleapis.com/maps/api/staticmap?center=${list[0]["latlong_log"]},${list[0]["latlong_la"]}&zoom=20&size=1080x920&maptype=hybrid&markers=color:red%7C%7C${list[0]["latlong_log"]},${list[0]["latlong_la"]}&key=AIzaSyAJt0Zghbk3qm_ZClIQOYeUT0AaV5TeOsI',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(base64Decode(image_i)),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://maps.googleapis.com/maps/api/staticmap?center=${list[0]["latlong_log"]},${list[0]["latlong_la"]}&zoom=20&size=1080x920&maptype=hybrid&markers=color:red%7C%7C${list[0]["latlong_log"]},${list[0]["latlong_la"]}&key=AIzaSyAJt0Zghbk3qm_ZClIQOYeUT0AaV5TeOsI',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(height: 5),
                      Row(children: [
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              alignment: Alignment.center,
                              decoration:
                                  BoxDecoration(border: Border.all(width: 0.4)),
                              height: 18,
                              child: const Text("DESCRIPTION ",
                                  style: TextStyle(
                                    fontSize: 7,
                                    fontWeight: FontWeight.bold,
                                  )),
                            )),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            alignment: Alignment.center,
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.4)),
                            height: 18,
                            child: const Text("AREA/sqm ",
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                )),
                            //color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            alignment: Alignment.center,
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.4)),
                            height: 18,
                            child: const Text("MIN/sqm ",
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                )),
                            //color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            alignment: Alignment.center,
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.4)),
                            height: 18,
                            child: const Text("MAX/sqm ",
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                )),
                            //color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            alignment: Alignment.center,
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.4)),
                            height: 18,
                            child: const Text("MIN-VALUE ",
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                )),
                            //color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            alignment: Alignment.center, height: 18,
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.4)),
                            child: const Text("MAX-VALUE ",
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                )),

                            //color: Colors.blue,
                          ),
                        ),
                      ]),

                      for (int index = land.length - 1; index >= 0; index--)
                        SizedBox(
                          height: 18,
                          child: Row(children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                height: 18,
                                child:
                                    Text(land[index]["verbal_land_type"] ?? "",
                                        style: const TextStyle(
                                          fontSize: 5,
                                          fontWeight: FontWeight.bold,
                                        )),
                                //color: Colors.blue,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                height: 18,
                                child: Text(
                                    '${formatter.format(double.parse(land[index]["verbal_land_area"].toString()))}/sqm',
                                    style: const TextStyle(
                                      fontSize: 5,
                                      fontWeight: FontWeight.bold,
                                    )),
                                //color: Colors.blue,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                height: 18,
                                child: Text(
                                    'USD ${formatter.format(double.parse(land[index]["verbal_land_minsqm"].toString()))}',
                                    style: const TextStyle(
                                      fontSize: 5,
                                      fontWeight: FontWeight.bold,
                                    )),
                                //color: Colors.blue,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                height: 18,
                                child: Text(
                                    'USD ${formatter.format(double.parse(land[index]["verbal_land_maxsqm"].toString()))}',
                                    style: const TextStyle(
                                        fontSize: 5,
                                        fontWeight: FontWeight.bold)),
                                //color: Colors.blue,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                height: 18,
                                child: Text(
                                    'USD ${formatter.format(double.parse(land[index]["verbal_land_minvalue"].toString()))}',
                                    style: const TextStyle(
                                      fontSize: 5,
                                      fontWeight: FontWeight.bold,
                                    )),
                                //color: Colors.blue,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.4)),
                                height: 18,
                                child: Text(
                                    'USD ${formatter.format(double.parse(land[index]["verbal_land_maxvalue"].toString()))}',
                                    style: const TextStyle(
                                      fontSize: 5,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ]),
                        ),
                      Row(children: [
                        Expanded(
                          flex: 9,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            alignment: Alignment.centerRight,
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.4)),
                            height: 18,
                            child: const Text("Property Value(Estimate) ",
                                style: TextStyle(
                                  fontSize: 6,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            alignment: Alignment.centerLeft,
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.4)),
                            height: 18,
                            child: Text(
                                'USD ${formatter.format(double.parse(total_MIN.toString()))}',
                                style: const TextStyle(
                                  fontSize: 6,
                                )),
                            //color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            alignment: Alignment.centerLeft,
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.4)),
                            height: 18,
                            child: Text(
                                'USD ${formatter.format(double.parse(total_MAX.toString()))}',
                                style: const TextStyle(
                                  fontSize: 6,
                                )),
                            //color: Colors.blue,
                          ),
                        ),
                      ]),
                      Container(
                        child: Row(children: [
                          Expanded(
                            flex: 9,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              alignment: Alignment.centerLeft,
                              decoration:
                                  BoxDecoration(border: Border.all(width: 0.4)),
                              // ទាយយក forceSale from  ForceSaleAndValuation
                              child: Text(
                                  "Force Sale Value ${list[0]['verbal_con'].toString()}% ",
                                  style: TextStyle(
                                    fontSize: 6,
                                    fontWeight: FontWeight.bold,
                                  )),
                              height: 18,
                              //color: Colors.blue,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              alignment: Alignment.centerLeft,
                              decoration:
                                  BoxDecoration(border: Border.all(width: 0.4)),
                              height: 18,
                              child: Text(
                                  "USD ${formatter.format(fsvN ?? double.parse('0.00'))}",
                                  style: const TextStyle(
                                    fontSize: 6,
                                  )),
                              //color: Colors.blue,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              alignment: Alignment.centerLeft,
                              decoration:
                                  BoxDecoration(border: Border.all(width: 0.4)),
                              child: Text(
                                  'USD ${formatter.format(fsvM ?? double.parse('0.00'))}',
                                  style: TextStyle(
                                    fontSize: 6,
                                  )),
                              height: 18,
                              //color: Colors.blue,
                            ),
                          ),
                        ]),
                      ),
                      //  ដកចេញសិន
                      // Container(
                      //   child: Row(children: [
                      //     Expanded(
                      //       flex: 6,
                      //       child: Container(
                      //         padding: const EdgeInsets.all(2),
                      //         alignment: Alignment.centerLeft,
                      //         decoration: BoxDecoration(border: Border.all( width:0.4)),
                      //         child: Text("Force Sale Value: ",
                      //             style: TextStyle(
                      //               fontSize: 6,
                      //               ,
                      //               fontWeight: FontWeight.bold,
                      //             )),
                      //         height: 18,
                      //         //color: Colors.blue,
                      //       ),
                      //     ),
                      //     Expanded(
                      //       flex: 2,
                      //       child: Container(
                      //         padding: const EdgeInsets.all(2),
                      //         alignment: Alignment.centerLeft,
                      //         decoration: BoxDecoration(border: Border.all( width:0.4)),
                      //         child: Text("${fn ?? '0.00'}",
                      //             style: TextStyle(fontSize: 6, )),
                      //         height: 18,
                      //         //color: Colors.blue,
                      //       ),
                      //     ),
                      //     Expanded(
                      //       flex: 2,
                      //       child: Container(
                      //         padding: const EdgeInsets.all(2),
                      //         alignment: Alignment.centerLeft,
                      //         decoration: BoxDecoration(border: Border.all( width:0.4)),
                      //         child: Text("${fx ?? '0.00'}",
                      //             style: TextStyle(fontSize: 6, )),
                      //         height: 18,
                      //         //color: Colors.blue,
                      //       ),
                      //     ),
                      //     Expanded(
                      //       flex: 4,
                      //       child: Container(
                      //         padding: EdgeInsets.all(2),
                      //         alignment: Alignment.centerLeft,
                      //         decoration: BoxDecoration(border: Border.all( width:0.4)),
                      //         height: 18,
                      //         //color: Colors.blue,
                      //       ),
                      //     ),
                      //   ]),
                      // ),
                      Container(
                        child: Row(children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              alignment: Alignment.centerLeft,
                              decoration:
                                  BoxDecoration(border: Border.all(width: 0.4)),
                              child: Text(
                                  "COMMENT: ${list[0]['verbal_comment'] ?? ''}",
                                  style: TextStyle(
                                    fontSize: 6,
                                    fontWeight: FontWeight.bold,
                                  )),
                              height: 18,
                              //color: Colors.blue,
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        alignment: Alignment.centerLeft,
                        decoration:
                            BoxDecoration(border: Border.all(width: 0.4)),
                        height: 18,
                        child: const Text("Valuation fee : ",
                            style: TextStyle(
                              fontSize: 6,
                              fontWeight: FontWeight.bold,
                            )),
                        //color: Colors.blue,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                          '*Note: It is only first price which you took from this verbal check data. The accurate value of property when we have the actual site property inspection.We are not responsible for this case when you provided the wrong land and building size or any fraud.',
                          style: TextStyle(
                            fontSize: 5,
                          )),
                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      'Verbal Check Replied By:${list[0]['username'].toString()} ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 6,
                                      ),
                                      textAlign: TextAlign.right),
                                  const SizedBox(height: 4),
                                  Text(' ${list[0]['tel_num'].toString()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 6,
                                      ),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ],
                          ),
                          const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('KHMER FOUNDATION APPRAISALS Co.,Ltd',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 6,
                                    )),
                              ]),
                          const SizedBox(height: 6),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Hotline: 099 283 388',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 6,
                                        )),
                                    Row(children: [
                                      Text(
                                          'H/P : (+855)23 988 855/(+855)23 999 761',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 6,
                                          )),
                                    ]),
                                    Row(children: [
                                      Text('Email : info@kfa.com.kh',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 6,
                                          )),
                                    ]),
                                    Row(children: [
                                      Text('Website: www.kfa.com.kh',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 6,
                                          )),
                                    ]),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Villa #36A, Street No4, (Borey Peng Hout The Star',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 6,
                                        )),
                                    Text(
                                        'Natural 371) Sangkat Chak Angrae Leu,',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 6,
                                        )),
                                    Text(
                                        'Khan Mean Chey, Phnom Penh City, Cambodia,',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 6,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.deepOrange,
        elevation: 12,
        onPressed: () async {
          await Printing.layoutPdf(
            onLayout: (format) => _generatePdf(format),
            format: PdfPageFormat.a4,
          );
        },
        child: const Icon(Icons.print_outlined),
      ),
    );
  }

  TextStyle Label() {
    return TextStyle(color: kPrimaryColor, fontSize: 12);
  }

  TextStyle Name() {
    return TextStyle(
      color: kImageColor,
      fontSize: 13,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle NameProperty() {
    return TextStyle(
      color: kImageColor,
      fontSize: 11,
      fontWeight: FontWeight.bold,
    );
  }

  var formatter = NumberFormat("##,###,###,###", "en_US");
  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    // Create a new PDF document
    final pdf = pw.Document(version: PdfVersion.pdf_1_4, compress: true);
    final font = await PdfGoogleFonts.robotoSlabBlack();
    final font1 = await PdfGoogleFonts.tinosRegular();
    final ByteData bytes =
        await rootBundle.load('assets/images/New_KFA_Logo_pdf.png');
    final Uint8List byteList = bytes.buffer.asUint8List();
    final Uint8List bytes1 =
        (await NetworkAssetBundle(Uri.parse('$image_m')).load('$image_m'))
            .buffer
            .asUint8List();
    Uint8List? bytes2;
    if (image_i != null || image_i != "No") {
      bytes2 = base64Decode(image_i);
      // (await NetworkAssetBundle(Uri.parse('$image_i')).load('$image_i'))
      //     .buffer
      //     .asUint8List();
    }

    final pageTheme = await _myPageTheme(format);
    // Add a page to the PDF document
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (context) {
          return [
            pw.Column(
              children: [
                pw.Column(
                  children: [
                    pw.Container(
                      height: 70,
                      margin: pw.EdgeInsets.only(bottom: 5),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            width: 75,
                            height: 50,
                            child: pw.Image(
                              pw.MemoryImage(
                                byteList,
                                // bytes1,
                              ),
                              fit: pw.BoxFit.fill,
                            ),
                          ),
                          pw.Text(
                            "VERBAL CHECK",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12,
                              font: font,
                            ),
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Column(
                                children: [
                                  pw.Container(
                                    height: 50,
                                    width: 79,
                                    child: pw.BarcodeWidget(
                                      barcode: pw.Barcode.qrCode(),
                                      data:
                                          "https://www.oneclickonedollar.com/#/${list[0]["verbal_id"]}",
                                    ),
                                  ),
                                  pw.Text(
                                    'verifications PDF',
                                    style:
                                        pw.TextStyle(fontSize: 7, font: font1),
                                  )
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Container(
                                    height: 50,
                                    width: 79,
                                    child: pw.BarcodeWidget(
                                      barcode: pw.Barcode.qrCode(),
                                      data:
                                          "https://www.latlong.net/c/?lat=${list[0]['latlong_log']}&long=${list[0]['latlong_la']}",
                                    ),
                                  ),
                                  pw.Text(
                                    'location map',
                                    style:
                                        pw.TextStyle(fontSize: 7, font: font1),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      child: pw.Column(
                        children: [
                          pw.Column(
                            children: [
                              pw.Container(
                                child: pw.Row(
                                  children: [
                                    pw.Expanded(
                                      flex: 4,
                                      child: pw.Container(
                                        padding: pw.EdgeInsets.all(2),
                                        alignment: pw.Alignment.centerLeft,
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border.all()),
                                        //color: Colors.red,
                                        child: pw.Text(
                                          "DATE: ${list[0]['verbal_created_date'].toString()}",
                                          style: pw.TextStyle(
                                            fontSize: 11,
                                            font: font1,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                        height: 20,
                                        //color: Colors.white,
                                      ),
                                    ),
                                    pw.Expanded(
                                      flex: 4,
                                      child: pw.Container(
                                        padding: pw.EdgeInsets.all(2),
                                        alignment: pw.Alignment.centerLeft,
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border.all()),
                                        child: pw.Text(
                                          "CODE: ${list[0]['verbal_id'].toString()}",
                                          style: pw.TextStyle(
                                            fontSize: 11,
                                            fontWeight: pw.FontWeight.bold,
                                            font: font1,
                                          ),
                                        ),
                                        height: 20,
                                        //color: Colors.yellow,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 11,
                            child: pw.Container(
                              padding: pw.EdgeInsets.all(2),
                              alignment: pw.Alignment.centerLeft,
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Text(
                                "Requested Date :${list[0]['verbal_created_date'].toString()} ",
                                style: pw.TextStyle(fontSize: 11, font: font1),
                              ),
                              height: 20,
                              //color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.all(2),
                      alignment: pw.Alignment.centerLeft,
                      decoration: pw.BoxDecoration(border: pw.Border.all()),
                      child: pw.Text(
                        "Referring to your request letter for verbal check by ${list[0]['bank_name'].toString()} ${list[0]['bank_branch_name'] ?? ""}, we estimated the value of property as below.",
                        overflow: pw.TextOverflow.clip,
                        style: pw.TextStyle(font: font1, fontSize: 11),
                      ),
                      height: 34,
                      //color: Colors.blue,
                    ),
                    pw.SizedBox(
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Container(
                              padding: pw.EdgeInsets.all(2),
                              alignment: pw.Alignment.centerLeft,
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Text(
                                "Property Information: ",
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  font: font1,
                                ),
                              ),
                              height: 20,
                              //color: Colors.blue,
                            ),
                          ),
                          pw.Expanded(
                            flex: 6,
                            child: pw.Container(
                              padding: pw.EdgeInsets.all(2),
                              alignment: pw.Alignment.centerLeft,
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Text(
                                " ${list[0]['property_type_name'] ?? ''}",
                                style: pw.TextStyle(fontSize: 11, font: font1),
                              ),
                              height: 20,
                              //color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(2),
                              alignment: pw.Alignment.centerLeft,
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Text(
                                "Address : ",
                                style: pw.TextStyle(fontSize: 11, font: font1),
                              ),
                              height: 20,
                              //color: Colors.blue,
                            ),
                          ),
                          pw.Expanded(
                            flex: 6,
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(2),
                              alignment: pw.Alignment.centerLeft,
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Text(
                                " ${list[0]['verbal_address'] ?? ""}.${list[0]['verbal_khan'] ?? ""}",
                                style: pw.TextStyle(fontSize: 11, font: font1),
                              ),
                              height: 20,
                              //color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(2),
                              alignment: pw.Alignment.centerLeft,
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Text(
                                "Owner Name ",
                                style: pw.TextStyle(fontSize: 11, font: font1),
                              ),
                              height: 20,
                              //color: Colors.blue,
                            ),
                          ),
                          pw.Expanded(
                            flex: 3,
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(2),
                              alignment: pw.Alignment.centerLeft,
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child:
                                  // name rest with api
                                  pw.Text(
                                "${list[0]['verbal_owner'] ?? ""}",
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  font: font1,
                                ),
                              ),
                              height: 20,
                              //color: Colors.blue,
                            ),
                          ),
                          pw.Expanded(
                            flex: 3,
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(2),
                              alignment: pw.Alignment.centerLeft,
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              // name rest with api
                              child: pw.Text(
                                "Contact No : ${list[0]['verbal_contact'] ?? ""}",
                                style: pw.TextStyle(fontSize: 11, font: font1),
                              ),
                              height: 20,
                              //color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(2),
                              alignment: pw.Alignment.centerLeft,
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Text(
                                "Bank Officer ",
                                style: pw.TextStyle(fontSize: 11, font: font1),
                              ),
                              height: 30,
                              //color: Colors.blue,
                            ),
                          ),
                          pw.Expanded(
                            flex: 3,
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(2),
                              alignment: pw.Alignment.centerLeft,
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Text(
                                " ${list[0]['bank_name'] ?? ""}",
                                style: pw.TextStyle(fontSize: 11, font: font1),
                              ),
                              height: 30,
                              //color: Colors.blue,
                            ),
                          ),
                          pw.Expanded(
                            flex: 3,
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(2),
                              alignment: pw.Alignment.centerLeft,
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Text(
                                "Contact No : ${list[0]['verbal_bank_contact'] ?? ""}",
                                style: pw.TextStyle(fontSize: 11, font: font1),
                              ),
                              height: 30,
                              //color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(2),
                              alignment: pw.Alignment.center,
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Text(
                                "Latitude: ${list[0]['latlong_log'].toString()}",
                                style: pw.TextStyle(fontSize: 11, font: font1),
                              ),
                              height: 20,
                              //color: Colors.blue,
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Container(
                              padding: pw.EdgeInsets.all(2),
                              alignment: pw.Alignment.center,
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Text(
                                "Longtitude: ${list[0]['latlong_la'].toString()}",
                                style: pw.TextStyle(fontSize: 11, font: font1),
                              ),
                              height: 20,
                              //color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      "ESTIMATED VALUE OF THE VERBAL CHECK PROPERTY",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 11, font: font1),
                    ),
                    pw.SizedBox(height: 5),
                    if (image_i != null || image_i != "No")
                      pw.Container(
                        height: 110,
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Container(
                              width: 240,
                              child: pw.Image(
                                pw.MemoryImage(
                                  bytes1,
                                ),
                                fit: pw.BoxFit.fitWidth,
                              ),
                            ),
                            pw.SizedBox(width: 0.1),
                            pw.Container(
                              width: 240,
                              child: pw.Image(
                                pw.MemoryImage(
                                  bytes2!,
                                ),
                                fit: pw.BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (image_i == null || image_i == "No")
                      pw.Container(
                        width: 240,
                        height: 110,
                        alignment: pw.Alignment.center,
                        child: pw.Image(
                          pw.MemoryImage(
                            bytes1,
                          ),
                          fit: pw.BoxFit.fitWidth,
                        ),
                      ),
                    pw.SizedBox(height: 5),
                    pw.Container(
                      child: pw.Column(
                        children: [
                          pw.Container(
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 3,
                                  child: pw.Container(
                                    padding: const pw.EdgeInsets.all(2),
                                    alignment: pw.Alignment.center,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all()),
                                    child: pw.Text(
                                      "DESCRIPTION ",
                                      style: pw.TextStyle(
                                        fontSize: 11,
                                        fontWeight: pw.FontWeight.bold,
                                        font: font1,
                                      ),
                                    ),
                                    height: 20,
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: const pw.EdgeInsets.all(2),
                                    alignment: pw.Alignment.center,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all()),
                                    child: pw.Text(
                                      "AREA/sqm ",
                                      style: pw.TextStyle(
                                        fontSize: 11,
                                        fontWeight: pw.FontWeight.bold,
                                        font: font1,
                                      ),
                                    ),
                                    height: 20,
                                    //color: Colors.blue,
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: const pw.EdgeInsets.all(2),
                                    alignment: pw.Alignment.center,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all()),
                                    child: pw.Text(
                                      "MIN/sqm ",
                                      style: pw.TextStyle(
                                        fontSize: 11,
                                        fontWeight: pw.FontWeight.bold,
                                        font: font1,
                                      ),
                                    ),
                                    height: 20,
                                    //color: Colors.blue,
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: const pw.EdgeInsets.all(2),
                                    alignment: pw.Alignment.center,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all()),
                                    child: pw.Text(
                                      "MAX/sqm ",
                                      style: pw.TextStyle(
                                        fontSize: 11,
                                        fontWeight: pw.FontWeight.bold,
                                        font: font1,
                                      ),
                                    ),
                                    height: 20,
                                    //color: Colors.blue,
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: const pw.EdgeInsets.all(2),
                                    alignment: pw.Alignment.center,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all()),
                                    child: pw.Text(
                                      "MIN-VALUE ",
                                      style: pw.TextStyle(
                                        fontSize: 11,
                                        fontWeight: pw.FontWeight.bold,
                                        font: font1,
                                      ),
                                    ),
                                    height: 20,
                                    //color: Colors.blue,
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: const pw.EdgeInsets.all(2),
                                    alignment: pw.Alignment.center,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all()),
                                    child: pw.Text(
                                      "MAX-VALUE ",
                                      style: pw.TextStyle(
                                        fontSize: 11,
                                        fontWeight: pw.FontWeight.bold,
                                        font: font1,
                                      ),
                                    ),
                                    height: 20,
                                    //color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (land.isNotEmpty)
                            for (int index = land.length - 1;
                                index >= 0;
                                index--)
                              pw.Row(
                                children: [
                                  pw.Expanded(
                                    flex: 3,
                                    child: pw.Container(
                                      padding: pw.EdgeInsets.all(2),
                                      alignment: pw.Alignment.centerLeft,
                                      decoration: pw.BoxDecoration(
                                          border: pw.Border.all()),
                                      child: pw.Text(
                                        land[index]["verbal_land_type"] ?? "",
                                        style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold,
                                          font: font1,
                                        ),
                                      ),
                                      height: 20,
                                      //color: Colors.blue,
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 2,
                                    child: pw.Container(
                                      padding: pw.EdgeInsets.all(2),
                                      alignment: pw.Alignment.centerLeft,
                                      decoration: pw.BoxDecoration(
                                          border: pw.Border.all()),
                                      child: pw.Text(
                                        '${formatter.format(double.parse(land[index]["verbal_land_area"].toString()))}/sqm',
                                        style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold,
                                          font: font1,
                                        ),
                                      ),
                                      height: 20,
                                      //color: Colors.blue,
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 2,
                                    child: pw.Container(
                                      padding: pw.EdgeInsets.all(2),
                                      alignment: pw.Alignment.centerLeft,
                                      decoration: pw.BoxDecoration(
                                          border: pw.Border.all()),
                                      child: pw.Text(
                                        'USD ${formatter.format(double.parse(land[index]["verbal_land_minsqm"].toString()))}',
                                        style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold,
                                          font: font1,
                                        ),
                                      ),
                                      height: 20,
                                      //color: Colors.blue,
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 2,
                                    child: pw.Container(
                                      padding: pw.EdgeInsets.all(2),
                                      alignment: pw.Alignment.centerLeft,
                                      decoration: pw.BoxDecoration(
                                          border: pw.Border.all()),
                                      child: pw.Text(
                                        'USD ${formatter.format(double.parse(land[index]["verbal_land_maxsqm"].toString()))}',
                                        style: pw.TextStyle(
                                          fontSize: 10,
                                          font: font1,
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                      height: 20,
                                      //color: Colors.blue,
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 2,
                                    child: pw.Container(
                                      padding: pw.EdgeInsets.all(2),
                                      alignment: pw.Alignment.centerLeft,
                                      decoration: pw.BoxDecoration(
                                          border: pw.Border.all()),
                                      child: pw.Text(
                                        'USD ${formatter.format(double.parse(land[index]["verbal_land_minvalue"].toString()))}',
                                        style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold,
                                          font: font1,
                                        ),
                                      ),
                                      height: 20,
                                      //color: Colors.blue,
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 2,
                                    child: pw.Container(
                                      padding: pw.EdgeInsets.all(2),
                                      alignment: pw.Alignment.centerLeft,
                                      decoration: pw.BoxDecoration(
                                          border: pw.Border.all()),
                                      child: pw.Text(
                                        'USD ${formatter.format(double.parse(land[index]["verbal_land_maxvalue"].toString()))}',
                                        style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold,
                                          font: font1,
                                        ),
                                      ),
                                      height: 20,
                                      //color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                          pw.Container(
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 9,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(2),
                                    alignment: pw.Alignment.centerRight,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all()),
                                    child: pw.Text(
                                      "Property Value(Estimate) ",
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                        font: font1,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                    height: 20,
                                    //color: Colors.blue,
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(2),
                                    alignment: pw.Alignment.centerLeft,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all()),
                                    child: pw.Text(
                                      'USD ${formatter.format(double.parse(total_MIN.toString()))}',
                                      style: pw.TextStyle(
                                          fontSize: 10, font: font1),
                                    ),
                                    height: 20,
                                    //color: Colors.blue,
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(2),
                                    alignment: pw.Alignment.centerLeft,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all()),
                                    child: pw.Text(
                                      'USD ${formatter.format(double.parse(total_MAX.toString()))}',
                                      style: pw.TextStyle(
                                          fontSize: 10, font: font1),
                                    ),
                                    height: 20,
                                    //color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          pw.Container(
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 9,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(2),
                                    alignment: pw.Alignment.centerLeft,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all()),
                                    // ទាយយក forceSale from  ForceSaleAndValuation
                                    child: pw.Text(
                                      "Force Sale Value ${list[0]['verbal_con'].toString()}% ",
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                        font: font1,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                    height: 20,
                                    //color: Colors.blue,
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(2),
                                    alignment: pw.Alignment.centerLeft,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all()),
                                    child: pw.Text(
                                      "USD ${formatter.format(fsvN ?? double.parse('0.00'))}",
                                      style: pw.TextStyle(
                                          fontSize: 10, font: font1),
                                    ),
                                    height: 20,
                                    //color: Colors.blue,
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(2),
                                    alignment: pw.Alignment.centerLeft,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all()),
                                    child: pw.Text(
                                      'USD ${formatter.format(fsvM ?? double.parse('0.00'))}',
                                      style: pw.TextStyle(
                                          fontSize: 10, font: font1),
                                    ),
                                    height: 20,
                                    //color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //  ដកចេញសិន
                          // pw.Container(
                          //   child: pw.Row(children: [
                          //     pw.Expanded(
                          //       flex: 5,
                          //       child: pw.Container(
                          //         padding: const pw.EdgeInsets.all(2),
                          //         alignment: pw.Alignment.centerLeft,
                          //         decoration: pw.BoxDecoration(border: pw.Border.all()),
                          //         child: pw.Text("Force Sale Value: ",
                          //             style: pw.TextStyle(
                          //               fontSize: 11,
                          //               font: font1,
                          //               fontWeight: pw.FontWeight.bold,
                          //             )),
                          //         height: 20,
                          //         //color: Colors.blue,
                          //       ),
                          //     ),
                          //     pw.Expanded(
                          //       flex: 2,
                          //       child: pw.Container(
                          //         padding: const pw.EdgeInsets.all(2),
                          //         alignment: pw.Alignment.centerLeft,
                          //         decoration: pw.BoxDecoration(border: pw.Border.all()),
                          //         child: pw.Text("${fn ?? '0.00'}",
                          //             style: pw.TextStyle(fontSize: 11, font: font1)),
                          //         height: 20,
                          //         //color: Colors.blue,
                          //       ),
                          //     ),
                          //     pw.Expanded(
                          //       flex: 2,
                          //       child: pw.Container(
                          //         padding: const pw.EdgeInsets.all(2),
                          //         alignment: pw.Alignment.centerLeft,
                          //         decoration: pw.BoxDecoration(border: pw.Border.all()),
                          //         child: pw.Text("${fx ?? '0.00'}",
                          //             style: pw.TextStyle(fontSize: 11, font: font1)),
                          //         height: 20,
                          //         //color: Colors.blue,
                          //       ),
                          //     ),
                          //     pw.Expanded(
                          //       flex: 4,
                          //       child: pw.Container(
                          //         padding: pw.EdgeInsets.all(2),
                          //         alignment: pw.Alignment.centerLeft,
                          //         decoration: pw.BoxDecoration(border: pw.Border.all()),
                          //         height: 20,
                          //         //color: Colors.blue,
                          //       ),
                          //     ),
                          //   ]),
                          // ),
                          pw.Container(
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 11,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(2),
                                    alignment: pw.Alignment.centerLeft,
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border.all()),
                                    child: pw.Text(
                                      "COMMENT: ${list[0]['verbal_comment'] ?? ''}",
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold,
                                        font: font1,
                                      ),
                                    ),
                                    height: 20,
                                    //color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(2),
                            alignment: pw.Alignment.centerLeft,
                            decoration:
                                pw.BoxDecoration(border: pw.Border.all()),
                            child: pw.Text(
                              "Valuation fee : ",
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                font: font1,
                              ),
                            ),
                            height: 20,
                            //color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      '*Note: It is only first price which you took from this verbal check data. The accurate value of property when we have the actual site property inspection.We are not responsible for this case when you provided the wrong land and building size or any fraud.',
                      style: pw.TextStyle(fontSize: 6, font: font1),
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              'Verbal Check Replied By:${list[0]['username'].toString()} ',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 7,
                                font: font1,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              ' ${list[0]['tel_num'].toString()}',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: font1,
                                fontSize: 11,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Text(
                          'KHMER FOUNDATION APPRAISALS Co.,Ltd',
                          style: pw.TextStyle(
                            color: PdfColors.blue,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 11,
                            font: font1,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          flex: 1,
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Hotline: 099 283 388',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 7,
                                  font: font1,
                                ),
                              ),
                              pw.Row(
                                children: [
                                  pw.Text(
                                    'H/P : (+855)23 988 855/(+855)23 999 761',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 7,
                                      font: font1,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text(
                                    'Email : info@kfa.com.kh',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 7,
                                      font: font1,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Text(
                                    'Website: www.kfa.com.kh',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 7,
                                      font: font1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Villa #36A, Street No4, (Borey Peng Hout The Star',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 7,
                                  font: font1,
                                ),
                              ),
                              pw.Text(
                                'Natural 371) Sangkat Chak Angrae Leu,',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 7,
                                  font: font1,
                                ),
                              ),
                              pw.Text(
                                'Khan Mean Chey, Phnom Penh City, Cambodia,',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 7,
                                  font: font1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    // Get the bytes of the PDF document
    final pdfBytes = pdf.save();

    // Print the PDF document to the default printer
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
    return pdf.save();
  }
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final bgShape = await rootBundle.loadString('assets/images/Letter En-Kh.svg');

  format = format.applyMargin(
    left: 2.0 * PdfPageFormat.cm,
    top: 1.0 * PdfPageFormat.cm,
    right: 2.0 * PdfPageFormat.cm,
    bottom: 1.0 * PdfPageFormat.cm,
  );
  return pw.PageTheme(
    pageFormat: format,
    // theme: pw.ThemeData.withFont(
    //   base: await PdfGoogleFonts.openSansRegular(),
    //   bold: await PdfGoogleFonts.openSansBold(),
    //   icons: await PdfGoogleFonts.materialIcons(),
    // ),
    buildBackground: (pw.Context context) {
      return pw.FullPage(
        ignoreMargins: true,
        child: pw.SvgImage(svg: bgShape),
      );
    },
  );
}
