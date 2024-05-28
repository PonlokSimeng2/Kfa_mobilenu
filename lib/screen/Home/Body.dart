// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, non_constant_identifier_names, deprecated_member_use, unused_local_variable, prefer_typing_uninitialized_variables, sized_box_for_whitespace

import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../afa/components/contants.dart';
import '../../models/autoVerbal.dart';
import '../propertype/Ppopertys/Getx_api/for_rent.dart';
import '../propertype/Ppopertys/verval_property/Verbal_add.dart';
import 'Customs/titleBar.dart';

final imgList = [
  'assets/images/banners/BannerKFA.jpg',
//'assets/images/banners/Service.jpg',
  'assets/images/banners/Awards2020s.jpg',
];
final controller_rent = controller_for_Rent();
int _current = 0;

final CarouselController _controller = CarouselController();
List list_value_all_2SR = [];
final List<Widget> imageSliders = imgList
    .map((item) => ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Image.asset(item, fit: BoxFit.cover, width: 1000.0),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
              ),
            ),
          ],
        )))
    .toList();

class Body extends StatefulWidget {
  final String user;
  final String first_name;
  final String last_name;
  final String email;
  final String gender;
  final String from;
  final String tel;
  final String id;
  final double? lat;
  final double? log;
  final String? c_id;
  final String? district;
  final String? commune;
  final String? province;

  const Body({
    Key? key,
    this.c_id,
    this.commune,
    this.district,
    this.province,
    required this.log,
    required this.lat,
    required this.user,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.gender,
    required this.from,
    required this.tel,
    required this.id,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late AutoVerbalRequestModel requestModelAuto;
  Uint8List? get_bytes;
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services'),
        ),
      );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    _getCurrentPosition();
    return true;
  }

  Future<void> _getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      lat = position.latitude;
      log = position.longitude;
      Find_by_piont(lat, log);
    });
  }

  Future<void> value_all_list_2() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/get_all_Sale_all_2'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonBody = jsonDecode(response.body);
        list_value_all_2SR = jsonBody;
        // print(list_value_all_2SR.toString());
      } else {
        print('Error value_all_list');
      }
    } catch (e) {
      print('Error value_all_list $e');
    }
  }

  var maxSqm1, minSqm1;
  var maxSqm2, minSqm2;
  var formatter = NumberFormat("##,###,###,##0.00", "en_US");
  Future<void> Find_by_piont(double la, double lo) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${la},${lo}&key=AIzaSyAJt0Zghbk3qm_ZClIQOYeUT0AaV5TeOsI'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List ls = jsonResponse['results'];
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
      final response_rc = await http.get(Uri.parse(
          'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/map/check_price?Khan_Name=${district.toString()}&Sangkat_Name=${commune.toString()}'));
      var jsonResponse_rc = json.decode(response_rc.body);
      setState(() {
        maxSqm1 = jsonResponse_rc['residential'][0]['Min_Value'].toString();
        minSqm1 = jsonResponse_rc['residential'][0]['Max_Value'].toString();
        maxSqm2 = jsonResponse_rc['commercial'][0]['Min_Value'].toString();
        minSqm2 = jsonResponse_rc['commercial'][0]['Max_Value'].toString();
        R_avg = (double.parse(maxSqm1.toString()) +
                double.parse(minSqm1.toString())) /
            2;
        C_avg = (double.parse(maxSqm2.toString()) +
                double.parse(minSqm2.toString())) /
            2;
      });
    } else {
      print(response.statusCode);
    }
  }

  double? R_avg;
  double? C_avg;
  Future<void> change_price() async {
    final response_rc = await http.get(Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/map/check_price?Khan_Name=${district.toString()}&Sangkat_Name=${commune.toString()}'));
    var jsonResponse_rc = json.decode(response_rc.body);
    setState(() {
      maxSqm1 = jsonResponse_rc['residential'][0]['Min_Value'].toString();
      minSqm1 = jsonResponse_rc['residential'][0]['Max_Value'].toString();
      maxSqm2 = jsonResponse_rc['commercial'][0]['Min_Value'].toString();
      minSqm2 = jsonResponse_rc['commercial'][0]['Max_Value'].toString();
      R_avg = (double.parse(maxSqm1.toString()) +
              double.parse(minSqm1.toString())) /
          2;
      C_avg = (double.parse(maxSqm2.toString()) +
              double.parse(minSqm2.toString())) /
          2;
    });
  }

  @override
  void initState() {
    _handleLocationPermission();
    value_all_list_2();
    super.initState();
    requestModelAuto = AutoVerbalRequestModel(
      property_type_id: "",
      lat: "",
      lng: "",
      address: '',
      approve_id: "", agent: "",
      bank_branch_id: "",
      bank_contact: "",
      bank_id: "",
      bank_officer: "",
      code: "",
      comment: "",
      contact: "",
      date: "",
      image: "",
      option: "",
      owner: "",
      user: "10",
      verbal_com: '',
      verbal_con: "",
      verbal: [],
      verbal_id: "0", verbal_khan: '',

      // autoVerbal: [requestModelVerbal],
      // data: requestModelVerbal,
    );
    // Future.delayed(const Duration(seconds: 5), () {
    //   if (maxSqm1 == null) {
    //     _getCurrentPosition();
    //   }
    // });
  }

  var lat;
  var log;
  var district;
  double? wth;
  double? wth2;
  static bool c = false;
  static int number = 0;
  static var password;
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    if (w < 600) {
      wth = w * 0.6;
      wth2 = w * 0.3;
    } else {
      wth = w * 0.5;
      wth2 = w * 0.3;
    }
    DateTime timeNow = DateTime.now();

    String formattedDate = DateFormat('dd MM yyyy').format(timeNow);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kwhite_new,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
        title: TitleBar(),
      ),
      backgroundColor: kwhite_new,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromARGB(54, 15, 179, 204),
                  border: Border.all()),
              height: 290,
              child: Column(children: [
                CarouselSlider(
                  items: imageSliders,
                  carouselController: _controller,
                  options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 1,
                      enlargeFactor: 0.3,
                      enlargeCenterPage: true,
                      aspectRatio: 1.8,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imgList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ]),
            ),
          ),
          //  Newbanner(),
          //  SizedBox(height: 200,),
          //   BannerSlide(),
          // Title_promotion2(
          //   title_promo: 'Our Partners',
          //   title_promo1: 'Show all',
          // ),
          // Divider(
          //   color: Colors.black,
          //   thickness: 0.5,
          // ),
          // Screen_slider(),
          // SizedBox(
          //   height: 15,
          // ),
          // Title_promotion(
          //   title_promo: 'Our Membership',
          //   title_promo1: 'Show all',
          // ),
          // Divider(
          //   color: Colors.blueAccent,
          //   thickness: 0.5,
          // ),
          // Membership_real(),
          // SizedBox(
          //   height: 15,
          // ),
          //Title_promo(),
          // Promotion(),
          // Divider(thickness: 5,color: Colors.white,),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: ListView(
                children: [
                  Wrap(
                    children: [
                      // for (int i = 0; i < 9; i++)
                      Container(
                        color: Color.fromARGB(54, 15, 179, 204),
                        height: 400,
                        child: GridView.builder(
                          itemCount: list_value_all_2SR.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2),
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (c == false && number == 0) {
                                        number = 0;
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return PasscodeScreen(
                                                passwordDigits: 4,
                                                title: Text("data"),
                                                isValidCallback: () {},
                                                passwordEnteredCallback: (Val) {
                                                  setState(() {
                                                    password = int.parse(Val);
                                                    if (password == 1234) {
                                                      c = true;
                                                      number = 4;
                                                      if (index == 0) {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Add_verbal_property(
                                                                          refresh_homeScreen:
                                                                              (value) {},
                                                                        )));
                                                      }
                                                      if (index == 1) {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Add_verbal_property(
                                                                          refresh_homeScreen:
                                                                              (value) {},
                                                                        )));
                                                      }
                                                      if (index == 2) {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Add_verbal_property(
                                                                          refresh_homeScreen:
                                                                              (value) {},
                                                                        )));
                                                      }
                                                      if (index == 3) {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Add_verbal_property(
                                                                          refresh_homeScreen:
                                                                              (value) {},
                                                                        )));
                                                      }
                                                      if (index == 4) {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Add_verbal_property(
                                                                          refresh_homeScreen:
                                                                              (value) {},
                                                                        )));
                                                      }
                                                      if (index == 5) {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Add_verbal_property(
                                                                          refresh_homeScreen:
                                                                              (value) {},
                                                                        )));
                                                      }
                                                    } else {
                                                      setState(() {
                                                        number = 0;
                                                        c = false;
                                                        Navigator.of(context)
                                                            .pop();
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                actions: [
                                                                  // FlatButton(
                                                                  //     textColor: Colors.white,
                                                                  //     color: Colors.red,
                                                                  //     onPressed: () {
                                                                  //       Navigator.pop(
                                                                  //           context);
                                                                  //     },
                                                                  //     child: Text("Okay!"))
                                                                ],
                                                                title: Text(
                                                                    "Error Password"),
                                                                content: Text(
                                                                    "Please try again later."),
                                                              );
                                                            });
                                                      });
                                                    }
                                                  });
                                                },
                                                cancelButton: Text('Cancel'),
                                                cancelCallback: () {
                                                  setState(() {
                                                    number = 0;
                                                    c = false;
                                                    password = null;
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                deleteButton: Text('Delete'),
                                                shouldTriggerVerification:
                                                    (_verificationNotifier)
                                                        .stream,
                                              );
                                            });
                                      }
                                      if (c == true && number > 0) {
                                        number -= 1;
                                        if (number == 0) {
                                          c = false;
                                        }
                                        if (index == 0) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Add_verbal_property(
                                                        refresh_homeScreen:
                                                            (value) {},
                                                      )));
                                        }
                                        if (index == 1) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Add_verbal_property(
                                                        refresh_homeScreen:
                                                            (value) {},
                                                      )));
                                        }
                                        if (index == 2) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Add_verbal_property(
                                                        refresh_homeScreen:
                                                            (value) {},
                                                      )));
                                        }
                                        if (index == 3) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Add_verbal_property(
                                                        refresh_homeScreen:
                                                            (value) {},
                                                      )));
                                        }
                                        if (index == 4) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Add_verbal_property(
                                                        refresh_homeScreen:
                                                            (value) {},
                                                      )));
                                        }
                                        if (index == 5) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Add_verbal_property(
                                                        refresh_homeScreen:
                                                            (value) {},
                                                      )));
                                        }
                                      }
                                    }); // setState(() {
                                    // //verbal_ID = controller_rent.list_value_pid[index]['id_ptys'].toString();
                                    //   Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //   builder: (context) => Detail_property_sale_all(
                                    //   price: list_value_all_2SR[index]['price'].toString(),
                                    //   type: list_value_all_2SR[index]['type']?? "N/A".toString(),
                                    //   image: list_value_all_2SR[index]['url'],
                                    //   ),
                                    //   ),
                                    //  );
                                    //   });// print(verbal_ID);
                                  },

                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: list_value_all_2SR[index]
                                                  ['url'] ??
                                              "N/A".toString(),
                                          fit: BoxFit.fill,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )),
                                  ),
                                  // Container(
                                  // decoration: BoxDecoration(
                                  // borderRadius:
                                  //                 BorderRadius.all(Radius.circular(10)),
                                  //                 image: DecorationImage(
                                  //                 image: NetworkImage(list_value_all_2SR[index]['url']?? "N/A".toString()),
                                  //                 fit: BoxFit.fill,
                                  //                 ),
                                  //                 ),
                                  //                 ),
                                ),
                                Positioned(
                                    left: 2,
                                    bottom: 5,
                                    child: Text(
                                      'Price: ${list_value_all_2SR[index]['price'] ?? "N/A".toString()} \$',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.white),
                                    )),
                                Positioned(
                                    right: 2,
                                    bottom: 5,
                                    child: Text(
                                      '${list_value_all_2SR[index]['type'] ?? "N/A".toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.white),
                                    ))
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String? options;
  String? commune;

  var id_Sangkat;
  List<dynamic> list_sangkat = [];
  void Load_sangkat(String id) async {
    setState(() {});
    var rs = await http.get(Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/sangkat?Sangkat_Name=${id}'));
    if (rs.statusCode == 200) {
      var jsonData = jsonDecode(rs.body);
      setState(() {
        list_sangkat = jsonData;
        id_Sangkat = int.parse(list_sangkat[0]['Sangkat_ID']);
      });
    }
  }

  // String? verbal_ID;
  // Future<void> detail_property_sale(index, widget_list) async {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Detail_property_sale_all(
  //         // verbal_ID: verbal_ID.toString(),
  //         //list_get_sale: widget_list,
  //       ),
  //     ),
  //   );
  // }
  String? province;

  late List<dynamic> list_Khan;

  int id_khan = 0;
  void Load_khan(String district) async {
    setState(() {});
    var rs = await http.get(Uri.parse(
        'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/khan?Khan_Name=${district}'));
    if (rs.statusCode == 200) {
      var jsonData = jsonDecode(rs.body);
      setState(() {
        list_Khan = jsonData;
        id_khan = int.parse(list_Khan[0]['Khan_ID']);
      });
    }
  }
}
