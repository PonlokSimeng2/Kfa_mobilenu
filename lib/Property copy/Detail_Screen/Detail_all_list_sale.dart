// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_typing_uninitialized_variables, body_might_complete_normally_nullable, sized_box_for_whitespace, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, avoid_print, unused_local_variable, must_be_immutable, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../screen/Contacts/ContactUs_sidebar.dart';
import '../../screen/Home/Body.dart';

class Detail_property_sale_all extends StatefulWidget {
    final String image;
    final String type;
    final String price;
  // final String? district;
  // final String? commune;
  // final String? province;
  // final String? log;
  // final String? lat;

  const Detail_property_sale_all({
    Key? key,
    required this.image,
    required this.type,
    required this.price,
   
  }) : super(key: key);

  @override
  State<Detail_property_sale_all> createState() => _Detail_propertyState();
}
class _Detail_propertyState extends State<Detail_property_sale_all> {
    Future<void> _makePhoneCall(String url) async {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  }
//List<String> list = json.decode(image).cast<String>().toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 51, 27, 185),
        centerTitle: true,
         //title: Text('${widget.id.toString()}')
        // title: Text('ID = ${widget.list_get_sale![indexN!]['id_ptys']}'),
      ),
      body:Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0,left: 8),
                  child: Container(
                                  height: 300,
                                  width: 350,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:widget.image.toString(),
                                        fit: BoxFit.fill,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )),)
                                      ),
                             
                          Padding(
                         padding: const EdgeInsets.only(right: 8.0,left: 8),
                        child: Container(
                                  height: 300,
                                  width: 350,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:widget.image.toString(),
                                        fit: BoxFit.fill,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )),)
                ),
              ],
            ),
          ),
            Container(
              height: 300,
              width: double.infinity,
                        // decoration: BoxDecoration(    
                          // color: Colors.amber,
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Column(
                               children: [
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     Text('${widget.type.toString()}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                   ],
                                 ),
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     Text('${widget.price.toString()} \$',style: TextStyle(fontWeight: FontWeight.bold),),
                                   ],
                                 ),
                                   Hotline(
                        onPress: () => setState(() {
                          _makePhoneCall('tel:077 216 168');
                        }),
                        icon: Icons.phone,
                        phone: '(855) 77 216 168',
                      ),
                       Hotline(
                        onPress: () => setState(() {
                          _makePhoneCall('tel:023 999 855');
                        }),
                        icon: Icons.phone,
                        phone: '(855) 23 999 855',
                      ),
                      Hotline(
                        onPress: () => setState(() {
                          _makePhoneCall('tel:023 988 911');
                        }),
                        icon: Icons.phone,
                        phone: '(855) 23 988 911',
                      ),
                      // Hotline(
                      //   onPress: () => setState(() {
                      //     // _launchEmail();
                      //   }),
                      //   icon: Icons.email,
                      //   phone: 'info@kfa.com.kh',
                      // ),
                               ],
                             ),
                           ),            
                        // borderRadius:
                        // BorderRadius.all(Radius.circular(10)),
                        // image: DecorationImage(
                        // image: NetworkImage(widget.image.toString()),
                        // fit: BoxFit.fill,
                        // ),
                        // ),
                        ),
        ],
      ),
    );
  }
}
