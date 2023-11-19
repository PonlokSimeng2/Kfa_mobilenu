import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final TextEditingController idText = TextEditingController();
  final TextEditingController keyText = TextEditingController();
  final TextEditingController nameText = TextEditingController();
  final TextEditingController amountText = TextEditingController();
  final TextEditingController orderIdText = TextEditingController();
  final TextEditingController usdText = TextEditingController();
  final TextEditingController versionText = TextEditingController();
  final TextEditingController notifyText = TextEditingController();
  final TextEditingController returnText = TextEditingController();
  final TextEditingController signText = TextEditingController();
  final TextEditingController langText = TextEditingController();
  // final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
  var loading = false;
  @override
  void initState() {
    super.initState();

    //My data model
    idText.text = '1674724041055870978';
    keyText.text = '3142e7549635d1661121992cfaafe17e';
    // nameText.text = '0001';
    // amountText.text = '10';
    // usdText.text = 'USD';
    // versionText.text = 'V1';
    // notifyText.text =
    //     'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/call_back_upay/58/8899';
    // returnText.text = 'https://itckfa.page.link/kfalink';
    // langText.text = 'EN';

    //U_Pay data model
    // idText.text = '1427830347298627585';
    // keyText.text = '6c509474001d099e8ee25540cb5ad0a8';
    nameText.text = '0001';
    amountText.text = '10';
    usdText.text = 'USD';
    versionText.text = 'V1';
    notifyText.text = 'https://dev-upayapi.u-pay.com/upayApi/test/notify';
    returnText.text = 'usimple://demo';
    langText.text = 'EN';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildInput(labelText: 'Merchant ID', controller: idText),
                  divider(),
                  buildInput(labelText: 'Merchant Key', controller: keyText),
                  divider(),
                  buildInput(labelText: 'Product name', controller: nameText),
                  divider(),
                  buildInput(
                  labelText: 'The amount of goods', controller: amountText),
                  divider(),
                  buildInput(
                  labelText: 'Order ID(Custom random generation)',
                  controller: orderIdText),
                  divider(),
                  buildInput(labelText: 'USD', controller: usdText),
                  divider(),
                  buildInput(labelText: 'Version(V1)', controller: versionText),
                  divider(),
                  buildInput(labelText: 'Notify Url', controller: notifyText),
                  divider(),
                  buildInput(labelText: 'Return Url', controller: returnText),
                  divider(),
                  buildInput(labelText: 'Sign', controller: signText),
                  divider(),
                  buildInput(labelText: 'Language', controller: langText),
                  divider(),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        // createOrder();
                      },
                      child: const Text('Create Order to APP')),
                  TextButton(
                      onPressed: () {
                        createOrderQR();
                      },
                      child: const Text('Create Order show KHQR'))
                ],
              )
              ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Visibility(
                  visible: loading == true,
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  )))
        ],
      ),
    );
  }

  static String baseUrl2 = 'https://dev-upayapi.u-pay.com/upayApi/mc/mcOrder';
  var appUrl = '$baseUrl2/appCreate';
  var qrUrl = '$baseUrl2/create/qrcode';
  void showErrorDialog(String error) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('title'),
          content: Text(error),
          actions: <Widget>[
            TextButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget divider() {
    return const Divider(
      height: 10,
    );
  }

  //Create Order QR
  void createOrderQR() async {
    if (loading) {
      return;
    }
    loading = true;
    setState(() {});
    var merchantId = idText.text;
    var merchantKey = keyText.text;
    var goods = nameText.text;
    var amount = amountText.text;
    var ccy = usdText.text;
    var v = versionText.text;
    var notifyUrl = notifyText.text;
    var returnUrl = returnText.text;
    var language = langText.text;
    var orderId = SignUtil.RandomString(10);
    orderIdText.text = orderId;
    Map<String, String> map = {
      'currency': ccy,
      'goodsDetail': goods,
      'lang': language,
      'mcAbridge': 'test',
      'mcId': merchantId,
      'mcOrderId': orderId,
      'money': amount,
      'notifyUrl': notifyUrl,
      'version': v,
    };
    var sign = SignUtil.getSign(map, merchantKey);
    map['sign'] = sign;
    // print(jsonEncode(map));
    signText.text = sign;

    try {
      var response = await Dio().post(qrUrl, data: map);
      if (response.statusCode == 200) {
        var data = response.data;
        var d1 = jsonEncode(data['data']);
        setState(() {
          var d2 = json.decode(d1);
          print(data);
        });
        // ignore: use_build_context_synchronously
        // showModalBottomSheet(
        //     context: context,
        //     isScrollControlled: true,
        //     builder: (context) {
        //       return Center(
        //         child: BarcodeWidget(
        //           barcode: Barcode.qrCode(),
        //           data: json.encode(data["data"]),
        //         ),
        //       );
        //     });
      } else {
        showErrorDialog(response.statusMessage ?? '');
      }
    } catch (e) {
      showErrorDialog(e.toString());
    }
    loading = false;
    setState(() {});
  }

  // void createOrder() async {
  //   if (loading) {
  //     return;
  //   }
  //   loading = true;
  //   setState(() {});
  //   var merchantId = idText.text;
  //   var merchantKey = keyText.text;
  //   var goods = nameText.text;
  //   var amount = amountText.text;
  //   var ccy = usdText.text;
  //   var v = versionText.text;
  //   var notifyUrl = notifyText.text;
  //   var returnUrl = returnText.text;
  //   var language = langText.text;
  //   var orderId = SignUtil.RandomString(10);
  //   orderIdText.text = orderId;
  //   var map = {
  //     'currency': ccy,
  //     'goodsDetail': goods,
  //     'lang': language,
  //     'mcAbridge': 'test',
  //     'mcId': merchantId,
  //     'mcOrderId': orderId,
  //     'money': amount,
  //     'notifyUrl': notifyUrl,
  //     'returnUrl': returnUrl,
  //     'version': v,
  //   };
  //   var sign = SignUtil.getSign(map, merchantKey);
  //   map['sign'] = sign;
  //   signText.text = sign;

  //   try {
  //     var response = await Dio().post(appUrl, data: map);
  //     if (response.statusCode == 200) {
  //       var data = response.data;
  //       var model = JsonConvert.fromJsonAsT<CreateOrderModel>(data['data']);

  //       showModalBottomSheet(
  //           context: context,
  //           isScrollControlled: true,
  //           builder: (context) {
  //             return QRCodeDialog(
  //               qrCode: model?.khqrCode ?? '',
  //               onTap: () {
  //                 _launch(model);
  //               },
  //             );
  //           });
  //     } else {
  //       showErrorDialog(response.statusMessage ?? '');
  //     }
  //   } catch (e) {
  //     showErrorDialog(e.toString());
  //   }
  //   loading = false;
  //   setState(() {});
  // }

  // void _launch(CreateOrderModel? model) async {
  //   var deepLink = model?.upayDeeplink ?? '';
  //   // var deepLink =
  //   //     'devupay://u-pay.com/toPay?p=eyJhbW91bnQiOiI1LjU2Iiwib3JkZXJJZCI6IjE1NjIzMjIwMDI3MzIxOTU4NDIiLCJzaWduIjoiNDFFMkU3OEE1RTJEOURFNDI2ODFERDc2NTBBMkEwQjIiLCJtY0FicmlkZ2UiOiJFLUdFVFMiLCJleHBpcmVUaW1lIjoiMTY2MTMyMjc2NiIsImNjeSI6IlVTRCIsIm1jTmFtZSI6IkUtR0VUUyBURUNITk9MT0dZIENPLiwgTFRELiIsImxhbmciOiJFTiIsInJldHVyblVybCI6ImVnZXRzYXBwOi8vcmVkaXJlY3QvYmFjaz9jdXJyZW5jeT1VU0QmbWNJZD0xNDcwNjk5NDYxODAwMDMwMjA5Jm1jT3JkZXJJZD0xMjIwODI0OTA4MTk1NDEzMDMyJm1vbmV5PTUuNTYmb3JkZXJJZD0xNTYyMzIyMDAyNzMyMTk1ODQyJnNpZ249MkQ5MTMzRjgxQjA3Q0RFQTQ2RkU1OTQ0M0YxOEYyODQmdmVyc2lvbj1WMSJ9';
  //   var deep = Uri.parse(deepLink);

  //   if (Platform.isAndroid) {
  //     var canLaunch = await canLaunchUrl(deep);
  //     if (canLaunch) {
  //       launchUrl(deep);
  //     } else {
  //       launchUrl(Uri.parse('market://details?id=com.upay.upaypoint'));
  //     }
  //   } else if (Platform.isIOS) {
  //     try {
  //       launchUrl(deep);
  //     } catch (e) {
  //       launchUrl(Uri.parse(model?.appStore ?? ''));
  //     }
  //   }
  // }
}

class SignUtil {
  static StringBuffer getKeys(Map<String, String> inMap, List<String> keys) {
    StringBuffer sbf = StringBuffer();
    for (var i = 0; i < keys.length; i++) {
      var key = keys[i];
      if (key != 'sign' && key.isNotEmpty) {
        var value = inMap[key];
        if (value == '' || value == null) {
          continue;
        }
        sbf
          ..write(key)
          ..write('=')
          ..write(value);
        if (i != (keys.length - 1)) {
          sbf.write('&');
        }
      }
    }
    return sbf;
  }

  static String generateMD5(String data) {
    print(data);
    Uint8List content = const Utf8Encoder().convert(data);
    Digest digest = md5.convert(content);
    return digest.toString();
  }

  static String getSign(Map<String, String> inMap, String secretKey) {
    var keys = <String>[];
    keys.addAll(inMap.keys);
    keys.sort();
    var sbf = getKeys(inMap, keys);
    sbf.write(secretKey);
    print(sbf.toString());
    return generateMD5(sbf.toString()).toUpperCase();
  }

  static String RandomString(int strlen) {
    var chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }
}

class buildInput extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  const buildInput({
    Key? key,
    required this.labelText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57,
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelText: labelText,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
