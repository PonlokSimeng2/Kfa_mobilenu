// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, non_constant_identifier_names, camel_case_types, avoid_print, unused_field, prefer_final_fields, prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps, equal_keys_in_map, unrelated_type_equality_checks, body_might_complete_normally_nullable, unused_element, await_only_futures, unnecessary_string_interpolations, unnecessary_cast, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_is_empty, unnecessary_null_comparison, unused_local_variable, unused_catch_clause, depend_on_referenced_packages, use_build_context_synchronously, sort_child_properties_last, no_leading_underscores_for_local_identifiers
import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../Pov_Test/map_in_add_verbal.dart';
import '../../../../contants.dart';
import '../Getx_api/vetbal_controller.dart';
import '../Model/Autho_verbal.dart';
import 'building.dart';

typedef OnChangeCallback = void Function(dynamic value);

// ignore: must_be_immutable
class Add_verbal_property extends StatefulWidget {
  Add_verbal_property({super.key, required this.refresh_homeScreen});
  OnChangeCallback? refresh_homeScreen;

  @override
  State<Add_verbal_property> createState() => _Add_verbal_saleState();
}

class _Add_verbal_saleState extends State<Add_verbal_property> {
  late AutoVerbal_property_a requestAutoVerbal_property;
  final List<String> _items_2 = [
    'For Sale',
    'For Rent',
  ];

  int? index_Sale;
  int? index_Rent;
  late String branchvalue;
  bool _isLoading = true;
  var _items = [];
  var last_verbal_id;
  @override
  void initState() {
    _initData();
    _getCurrentPosition();
    super.initState();
  }

  int? hometype_api_index;

  bool? index12 = true;

  var khan;
  var songkat;
  var provice_map;
  Future<void> _initData() async {
    await Future.wait([
      controller_verbal.verbal_last_ID(),
      controller_verbal.verbal_Hometype(),
      controller_verbal.verbal_Commune_25_all(),
    ]);

    setState(() {
      _isLoading = false;
    });
  }

  String? commune;
  String? district;
  Future<void> _getCurrentPosition() async {
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,);

    setState(() {
      lat = position.latitude;
      log = position.longitude;
    });
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${log}&key=AIzaSyAJt0Zghbk3qm_ZClIQOYeUT0AaV5TeOsI',),);

    if (response.statusCode == 200) {
      // Successful response
      final jsonResponse = json.decode(response.body);

      final List ls = jsonResponse['results'];
      List ac;
      bool check_sk = false, check_kn = false;
      for (int j = 0; j < ls.length; j++) {
        ac = jsonResponse['results'][j]['address_components'];
        for (int i = 0; i < ac.length; i++) {
          if (check_kn == false || check_sk == false) {
            if (jsonResponse['results'][j]['address_components'][i]['types']
                    [0] ==
                "political") {
              setState(() {
                check_kn = true;
                district = (jsonResponse['results'][j]['address_components'][i]
                    ['short_name']);
              });
            }
            if (jsonResponse['results'][j]['address_components'][i]['types']
                    [0] ==
                "administrative_area_level_3") {
              setState(() {
                check_sk = true;
                commune = (jsonResponse['results'][j]['address_components'][i]
                    ['short_name']);
              });
            }
          }
        }
      }
    }
  }

  String? Name_cummune;
  var controller_verbal = Controller_verbal();
  bool switchValue = false;
  String _switchValue = 'Switch';
  bool way = false;
  TextEditingController address1 = TextEditingController();

  var id_ptys;
  String urgent = 'N/A';
  String? get_re = '202301';
  String? await_functino;
  var _size_10 = SizedBox(height: 10);
  Widget _text(text) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30, bottom: 5),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.height * 0.02,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
           leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);Navigator.pop(context);
          },
        ),
          title: Text('$type'),
          backgroundColor: Color.fromARGB(255, 20, 20, 163),
          centerTitle: true,
          actions: <Widget>[
            InkWell(
              onTap: () async {
                setState(() {
                  address = '${khan} / ${provice_map}';
                  type;
                  urgent;
                });
                if (type == 'For Sale' &&
                    _imageFile != null &&
                    // _images.length == 2 &&
                    lat != null) {
                  print('For Sale');
                  await_functino = '1';
                  // await _uploadImag_Multiple('mutiple_image_post');
                  _latlog('lat_log_post');
                  ID();
                  Urgent('Urgent_Post');
                  value_property('2_property');
                  await _upload_Image_Sale('Image_ptys_post');
                } else if (type == 'For Rent' &&
                    _imageFile != null &&
                    // _images.length == 2 &&
                    lat != null) {
                  print('For Rent');
                  await_functino = '1';
                  //  await _uploadImag_Multiple('mutiple_imageR_post');
                  _latlog('lat_log_post_rent');
                  ID();
                  Urgent('Urgen_rent');
                  value_property('rent/more');
                  await _upload_Image_rent('rent_post_image');
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: 80,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 30, 98, 4),
                    borderRadius: BorderRadius.circular(15),),
                child: Text(
                  'Save',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white,),
                ),
              ),
            )
          ],
        ),
        body: (await_functino == '1')
            ? LiquidLinearProgressIndicator(
                value: 0.25, // Defaults to 0.5.
                valueColor:
                    AlwaysStoppedAnimation(Color.fromARGB(255, 53, 33, 207)),
                backgroundColor: Colors.white,
                borderColor: Colors.white,
                borderWidth: 5.0,
                borderRadius: 12.0,
                direction: Axis.vertical,
                center: Text(
                  "Please waiting...!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.025,),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30, left: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 21, 105, 6),
                                // border: Border.all(width: 2),
                              ),
                              height: MediaQuery.of(context).size.width * 0.11,
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Text(
                                'Code : ${controller_verbal.id_last.toString()}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.37,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 6, 25, 121),
                                  borderRadius: BorderRadius.circular(10),),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Switch(
                                    autofocus: false,
                                    activeColor:
                                        Color.fromARGB(255, 253, 253, 253),
                                    value: switchValue,
                                    onChanged: (value) {
                                      setState(() {
                                        switchValue = value;
                                        if (value == true) {
                                          urgent = 'Urgent';
                                        } else {
                                          urgent = 'N/A';
                                        }
                                        print(switchValue);
                                      });
                                    },
                                  ),
                                  Text(
                                    '$urgent',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _getImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 30, left: 30, top: 10, bottom: 10,),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1),),
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                              child: (_imageFile != null)
                                  ? Image.file(
                                      _imageFile!,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.19,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Stack(children: [
                                      CachedNetworkImage(
                                        imageUrl:
                                            'https://as1.ftcdn.net/v2/jpg/01/80/31/10/1000_F_180311099_Vlj8ufdHvec4onKSDLxxdrNiP6yX4PnP.jpg',
                                        fit: BoxFit.cover,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.19,
                                        width: double.infinity,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress,),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      Positioned(
                                        left:
                                            MediaQuery.of(context).size.height *
                                                0.09,
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: GFShimmer(
                                          child: Text(
                                            'Select Image',
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w700,),
                                          ),
                                          showGradient: true,
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomRight,
                                            end: Alignment.centerLeft,
                                            stops: const <double>[
                                              0.2,
                                              0.7,
                                              0.8,
                                              0.9,
                                              1
                                            ],
                                            colors: [
                                              Color.fromARGB(255, 5, 10, 159)
                                                  .withOpacity(0.1),
                                              Color.fromARGB(255, 5, 9, 114),
                                              Color.fromARGB(255, 4, 8, 103),
                                              Color.fromARGB(255, 5, 8, 93),
                                              Color.fromARGB(255, 4, 6, 82),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(Map_verbal_address_Sale(
                            get_province: (value) {
                              setState(() {
                                songkat = value.toString();
                              });
                            },
                            get_district: (value) {
                              setState(() {
                                provice_map = value.toString();
                              });
                            },
                            get_commune: (value) {
                              setState(() {
                                khan = value.toString();
                              });
                            },
                            get_log: (value) {
                              setState(() {
                                log = double.parse(value);
                              });
                            },
                            get_lat: (value) {
                              lat = double.parse(value);
                            },
                          ),);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30, left: 30),
                          child: Container(
                            decoration:
                                BoxDecoration(border: Border.all(width: 1)),
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholderFit: BoxFit.contain,
                              placeholder: 'assets/earth.gif',
                              image:
                                  "https://maps.googleapis.com/maps/api/staticmap?center=${lat.toString()},${log.toString()}&zoom=20&size=1080x920&maptype=hybrid&markers=color:red%7C%7C${lat.toString()},${log.toString()}&key=AIzaSyAJt0Zghbk3qm_ZClIQOYeUT0AaV5TeOsI",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 30, left: 30, top: 10),
                        child: Container(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            //value: genderValue,
                            onChanged: (newValue) {
                              setState(() {
                                hometype = newValue;
                              });
                            },
                            value: hometype,
                            items: controller_verbal.list_hometype
                                .map<DropdownMenuItem<String>>(
                                  (value) => DropdownMenuItem<String>(
                                    value: value["hometype"],
                                    child: Text(
                                      value['hometype'],
                                      style: TextStyle(
                                          fontSize:
                                              MediaQuery.textScaleFactorOf(
                                                      context,) *
                                                  13,
                                          height: 0.1,),
                                    ),
                                  ),
                                )
                                .toList(),
                            // add extra sugar..
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: kImageColor,
                            ),

                            decoration: InputDecoration(
                              fillColor: kwhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                              labelText: 'Hometype',
                              hintText: 'Hometype',
                              prefixIcon: Icon(
                                Icons.app_registration_sharp,
                                color: kImageColor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: kPrimaryColor, width: 2.0,),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: kPrimaryColor,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 30, left: 30, top: 10),
                        child: Container(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,

                            onChanged: (newValue) {
                              setState(() {
                                property_type_id =
                                    int.parse(newValue.toString());
                              });
                            },
                            value: Name_cummune,
                            items: controller_verbal.list_cummone
                                .map<DropdownMenuItem<String>>(
                                  (value) => DropdownMenuItem<String>(
                                    value: value["property_type_id"].toString(),
                                    child: Text(
                                      value['Name_cummune'],
                                      style: TextStyle(
                                          fontSize:
                                              MediaQuery.textScaleFactorOf(
                                                      context,) *
                                                  13,
                                          height: 0.1,),
                                    ),
                                  ),
                                )
                                .toList(),
                            // add extra sugar..
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: kImageColor,
                            ),

                            decoration: InputDecoration(
                              fillColor: kwhite,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                              labelText: 'Province*',
                              hintText: 'Select',
                              prefixIcon: Icon(
                                Icons.app_registration_sharp,
                                color: kImageColor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: kPrimaryColor, width: 2.0,),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: kPrimaryColor,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 30, left: 30, top: 10),
                        child: Row(children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  price = double.parse(value);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8),
                                prefixIcon: Icon(
                                  Icons.feed_outlined,
                                  color: kImageColor,
                                ),
                                hintText: 'Price*',
                                fillColor: kwhite,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kPrimaryColor,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: kPrimaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  requestAutoVerbal_property.sqm =
                                      double.parse(value).toStringAsFixed(5);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8),
                                prefixIcon: Icon(
                                  Icons.feed_outlined,
                                  color: kImageColor,
                                ),
                                hintText: 'Sqm*',
                                fillColor: kwhite,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kPrimaryColor,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: kPrimaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 30, left: 30, top: 10),
                        child: Row(children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  bed = int.parse(value);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8),
                                prefixIcon: Icon(
                                  Icons.bed_outlined,
                                  color: kImageColor,
                                ),
                                hintText: 'bed',
                                fillColor: kwhite,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kPrimaryColor,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: kPrimaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  bath = int.parse(value);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8),
                                prefixIcon: Icon(
                                  Icons.feed_outlined,
                                  color: kImageColor,
                                ),
                                hintText: 'bath',
                                fillColor: kwhite,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kPrimaryColor,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: kPrimaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],),
                      ),
                      _size_10,
                      _text('Size Land*'),
                      Building(
                        l: (value) {
                          setState(() {
                            land_l = int.parse(value);
                          });
                        },
                        w: (value) {
                          setState(() {
                            land_w = int.parse(value);
                          });
                        },
                        total: (value) {
                          setState(() {
                            land = double.parse(value.toString());
                          });
                        },
                      ),
                      _size_10,
                      _text('Size House'),
                      Building(
                        l: (value) {
                          setState(() {
                            size_l = int.parse(value);
                          });
                        },
                        w: (value) {
                          setState(() {
                            size_w = int.parse(value);
                          });
                        },
                        total: (value) {
                          setState(() {
                            size_house = double.parse(value.toString());
                          });
                        },
                      ),
                      _size_10,
                      Padding(
                        padding: EdgeInsets.only(right: 30, left: 30, top: 10),
                        child: Row(children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  floor = int.parse(value);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8),
                                prefixIcon: Icon(
                                  Icons.bed_outlined,
                                  color: kImageColor,
                                ),
                                hintText: 'floor',
                                fillColor: kwhite,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kPrimaryColor,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: kPrimaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  Parking = int.parse(value);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8),
                                prefixIcon: Icon(
                                  Icons.feed_outlined,
                                  color: kImageColor,
                                ),
                                hintText: 'parking',
                                fillColor: kwhite,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kPrimaryColor,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: kPrimaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 30, left: 30, top: 10),
                        child: Row(children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  total_area = double.parse(value);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8),
                                prefixIcon: Icon(
                                  Icons.bed_outlined,
                                  color: kImageColor,
                                ),
                                hintText: 'Total Area',
                                fillColor: kwhite,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kPrimaryColor,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: kPrimaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  price_sqm = double.parse(value);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8),
                                prefixIcon: Icon(
                                  Icons.feed_outlined,
                                  color: kImageColor,
                                ),
                                hintText: 'Price(sqm)*',
                                fillColor: kwhite,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kPrimaryColor,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: kPrimaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 30, left: 30, top: 10),
                        child: Row(children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  Livingroom = int.parse(value);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8),
                                prefixIcon: Icon(
                                  Icons.bed_outlined,
                                  color: kImageColor,
                                ),
                                hintText: 'LivingRoom',
                                fillColor: kwhite,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kPrimaryColor,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: kPrimaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  aircon = int.parse(value);
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8),
                                prefixIcon: Icon(
                                  Icons.feed_outlined,
                                  color: kImageColor,
                                ),
                                hintText: 'Aricon',
                                fillColor: kwhite,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kPrimaryColor,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: kPrimaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 30, left: 30, top: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.015,
                                  fontWeight: FontWeight.bold,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    Private_Area = double.parse(value);
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 8),
                                  prefixIcon: Icon(
                                    Icons.bed_outlined,
                                    color: kImageColor,
                                  ),
                                  hintText: 'Private Area',
                                  fillColor: kwhite,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: kPrimaryColor,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: kPrimaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 30, left: 30, top: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    type = newValue;
                                  });
                                  if (type == 'For Sale') {
                                    index_Sale = _items_2.indexOf('For Sale');
                                  } else if (type == 'For Rent') {
                                    index_Rent = _items_2.indexOf('For Rent');
                                  }
                                },
                                validator: (String? value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please select bank';
                                  }
                                  return null;
                                },
                                items: _items_2
                                    .map<DropdownMenuItem<String>>(
                                      (value) => DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize:
                                                  MediaQuery.textScaleFactorOf(
                                                          context,) *
                                                      13,
                                              height: 1,),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                // add extra sugar..
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: kImageColor,
                                ),

                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 8),
                                  prefixIcon: Icon(
                                    Icons.bed_outlined,
                                    color: kImageColor,
                                  ),
                                  hintText: 'Type*',
                                  fillColor: kwhite,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: kPrimaryColor,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: kPrimaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    land = double.parse(value);
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 8),
                                  prefixIcon: Icon(
                                    Icons.landscape_outlined,
                                    color: kImageColor,
                                  ),
                                  hintText: 'land',
                                  fillColor: kwhite,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: kPrimaryColor,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: kPrimaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                Title = value;
                              });
                            },
                            maxLines: 3,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Title',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                description = value;
                              });
                            },
                            maxLines: 3,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Description',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),);
  }

  Future<void> ID() async {
    Map<String, int> payload = {
      'id_ptys': int.parse(controller_verbal.id_last.toString()),
      'property': 0,
    };

    final url = Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/post_id_sale_last',);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      print('success');
    } else {
      print('Error: ${response.reasonPhrase}');
    }
  }

  File? _imageFile;
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        print(_imageFile);
      });
    }
  }

  Future<File?> _upload_Image_Sale(_url) async {
    if (_imageFile == null) {
      return _imageFile;
    }

    final url = Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/$_url',);

    final request = http.MultipartRequest('POST', url);
    request.fields['id_image'] = controller_verbal.id_last.toString();
    request.fields['hometype'] = hometype.toString();
    request.fields['property_type_id'] = property_type_id.toString();
    if (_imageFile != null) {
      final String targetPath = '${_imageFile!.path}_compressed.jpg';

      try {
        File? compressedFile =
            await testCompressAndGetFile(_imageFile!, targetPath);

        setState(() {
          _compressedImage_only = compressedFile;
        });
      } catch (e) {
        print('Error compressing image: $e');
      }
    }
    request.files.add(await http.MultipartFile.fromPath(
        'image_name_sale', _compressedImage_only!.path,),);

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded!');
      AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: false,
          title: 'Succesfully',
          autoHide: Duration(seconds: 3),
          onDismissCallback: (type) {
            setState(() {
              get_re;
              widget.refresh_homeScreen!(get_re);
            });
            Navigator.pop(context);
          },).show();
    } else {
      print('Error uploading image: ${response.reasonPhrase}');
    }
  }

  Future<File?> _upload_Image_rent(_url) async {
    if (_imageFile == null) {
      return _imageFile;
    }

    final url = Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/$_url',);

    final request = http.MultipartRequest('POST', url);
    request.fields['id_image'] = controller_verbal.id_last.toString();
    request.fields['hometype'] = hometype.toString();
    request.fields['property_type_id'] = property_type_id.toString();
    if (_imageFile != null) {
      final String targetPath = '${_imageFile!.path}_compressed.jpg';

      try {
        File? compressedFile =
            await testCompressAndGetFile(_imageFile!, targetPath);

        setState(() {
          _compressedImage_only = compressedFile;
        });
      } catch (e) {
        print('Error compressing image: $e');
      }
    }
    request.files.add(await http.MultipartFile.fromPath(
        'image_name_rent', _compressedImage_only!.path,),);

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded!');
      AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: false,
          title: 'Succesfully',
          autoHide: Duration(seconds: 3),
          onDismissCallback: (type) {
            setState(() {
              get_re;
              widget.refresh_homeScreen!(get_re);
            });
            Navigator.pop(context);
          },).show();
    } else {
      print('Error uploading image: ${response.reasonPhrase}');
    }
  }

  List<File> _images = [];
  Future<void> pickImages() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 2,
        enableCamera: true,
      );
    } on Exception catch (e) {
      // Handle exception
    }
    // setState(() {
    //   _images;
    // });

    List<File> files = [];
    for (final asset in resultList) {
      final ByteData byteData = await asset.getByteData();
      final tempDir = await getTemporaryDirectory();

      final file = File('${tempDir.path}/${asset.name}');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      files.add(file);
    }

    setState(() {
      _images = files;
    });
  }

  void _latlog(_url) async {
    Map<String, dynamic> payload = await {
      'id_ptys': controller_verbal.id_last.toString(),
      'property_type_id': property_type_id,
      'lat': lat.toString(),
      'log': log.toString(),
    };

    final url = await Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/$_url',);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      print('Success latlog');
    } else {
      print('Error Latlog: ${response.reasonPhrase}');
    }
  }

  int? property_type_id;
  double? price;
  double? sqm;
  int? bed;
  int? bath;
  String? type = '';
  double? land;
  String? address = '';
  String? Title;
  String? description;
  String? hometype;
  //proeperty_2
  double? Private_Area;
  int? Livingroom;
  int? Parking;
  int? size_w;
  int? size_l;
  int? floor;
  int? land_l;
  int? land_w;
  double? size_house;
  double? total_area;
  double? price_sqm;
  int? aircon;
  void value_property(_url) async {
    Map<String, dynamic> payload = await {
      'id_ptys': controller_verbal.id_last.toString(),
      'property_type_id': property_type_id,
      'price': price,
      'sqm': sqm,
      'bed': bed,
      'bath': bath,
      'type': type.toString(),
      'land': land,
      // 'land': 12.2,
      'address': address,
      'Title': Title,
      'description': description,
      'hometype': hometype,

      'property_two': [
        {
          "id_ptys": controller_verbal.id_last.toString(),
          "Private_Area": Private_Area,
          "Livingroom": Livingroom,
          "Parking": Parking,
          "size_w": size_w,
          "Size_l": size_l,
          "floor": floor,
          "land_l": land_l,
          "land_w": land_w,
          "size_house": size_house,
          "total_area": total_area,
          "price_sqm": price_sqm,
          "aircon": aircon,
        }
      ]
    };

    final url = await Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/$_url',);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      print('Success value Sale');
    } else {
      print('Error Sale: ${response.reasonPhrase}');
    }
  }

  Future<File?> testCompressAndGetFile(File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 88,
      rotate: 180,
      autoCorrectionAngle: false,
      keepExif: true,
    );

    // Reverse the image horizontally
    if (result != null) {
      final image = img.decodeImage(result.readAsBytesSync());
      // var reversedImage = img.flipHorizontal(image!);
      final reversedImage = img.flipHorizontalVertical(image!);
      result.writeAsBytesSync(img.encodeJpg(reversedImage));
    }
    return result;
  }

  double? lat = 0, log = 0;
  File? _compressedImage;
  File? _compressedImages;
  File? _compressedImage_only;
  File? result;
  void Urgent(_url) async {
    Map<String, dynamic> payload = await {
      'id_ptys': controller_verbal.id_last.toString(),
      'property_type_id': property_type_id,
      'hometype': hometype.toString(),
      'urgent': urgent.toString(),
    };

    final url = await Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/$_url',);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      print('Success urgent_Sale');
    } else {
      print('Error Rent: ${response.reasonPhrase}');
    }
  }

  Future<void> _uploadImag_Multiple(_url) async {
    final url = Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/',);

    final request = http.MultipartRequest('POST', url);
    request.fields['id_ptys'] = controller_verbal.id_last.toString();
    request.fields['property_type_id'] = property_type_id.toString();
    if (_images != null) {
      final String targetPath = '${_images[0].path}_compressed.jpg';
      final String targetPaths = '${_images[1].path}_compressed.jpg';

      try {
        File? compressedFile =
            await testCompressAndGetFile(_images[0], targetPath);
        File? compressedFiles =
            await testCompressAndGetFile(_images[1], targetPaths);

        setState(() {
          _compressedImage = compressedFile;
          _compressedImages = compressedFiles;
        });
      } catch (e) {
        print('Error compressing image: $e');
      }
    }

    request.files.add(
        await http.MultipartFile.fromPath('image', _compressedImage!.path),);
    request.files.add(
        await http.MultipartFile.fromPath('images', _compressedImages!.path),);

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded! ');
    } else {
      print('Error uploading image: ${response.reasonPhrase} ');
    }
  }
}
