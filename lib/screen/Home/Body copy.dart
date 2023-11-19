// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, non_constant_identifier_names, deprecated_member_use, unused_local_variable, prefer_typing_uninitialized_variables, sized_box_for_whitespace

// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';

// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';

// import 'package:kfa_project/afa/components/contants.dart';
// import 'package:kfa_project/afa/screens/AutoVerbal/Add.dart';
// import 'package:kfa_project/screen/Account/account.dart';
// import 'package:kfa_project/screen/Home/Customs/Model-responsive.dart';
// import 'package:kfa_project/screen/Promotion/membership_real.dart';
// import 'package:kfa_project/screen/Promotion/partnerList_real.dart';

// // import 'package:kfa_project/screen/Home/Customs/MenuCard.dart';
// import 'package:http/http.dart' as http;
// import 'package:kfa_project/screen/Promotion/Title_promo.dart';
// import 'package:kfa_project/screen/Promotion/promotion.dart';
// import 'package:kfa_project/screen/Home/Customs/titleBar.dart';
// import 'package:kfa_project/screen/components/map_all/map_in_add_body.dart';
// // import 'package:kfa_project/screen/components/map_all/map_in_add_verbal.dart';

// // import '../../afa/components/slideUp.dart';
// import '../../models/autoVerbal.dart';
// import '../Promotion/bannerslide.dart';
// import 'newbanner.dart';

// // import 'Customs/googlemapkfa/detailmap.dart';
// final imgList = [
// 'assets/images/banners/BannerKFA.jpg',
// 'assets/images/banners/Service.jpg',
// ];

// int _current = 0;
//   final CarouselController _controller = CarouselController();
// final List<Widget> imageSliders = imgList
//     .map((item) => ClipRRect(
//         borderRadius: BorderRadius.all(Radius.circular(5.0)),
//         child: Stack(
//           children: <Widget>[
//             Image.asset(item, fit: BoxFit.cover, width: 1000.0),
//             Positioned(
//               bottom: 0.0,
//               left: 0.0,
//               right: 0.0,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Color.fromARGB(200, 0, 0, 0),
//                       Color.fromARGB(0, 0, 0, 0)
//                     ],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                   ),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                     vertical: 10.0, horizontal: 20.0),
//               ),
//             ),
//           ],
//         )))
//     .toList();
// class Body extends StatefulWidget {
//   final String user;
//   final String first_name;
//   final String last_name;
//   final String email;
//   final String gender;
//   final String from;
//   final String tel;
//   final String id;
//   final double? lat;
//   final double? log;
//   // final String? c_id;
//   // final String? district;
//   // final String? commune;
//   // final String? province;
//   // final String? log;
//   // final String? lat;

//   const Body({
//     Key? key,
//     // required this.c_id,
//     // required this.commune,
//     // required this.district,
//     // required this.province,
//     // required this.log,
//     // required this.lat,

//     required this.lat,
//     required this.log,
//     required this.user,
//     required this.first_name,
//     required this.last_name,
//     required this.email,
//     required this.gender,
//     required this.from,
//     required this.tel,
//     required this.id,
//   }) : super(key: key);

//   @override
//   State<Body> createState() => _BodyState();
// }

// class _BodyState extends State<Body> {
//   late AutoVerbalRequestModel requestModelAuto;
//   String? _currentAddress;
//   Position? _currentPosition;
//   Uint8List? get_bytes;
//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//               'Location services are disabled. Please enable the services'),
//         ),
//       );
//       return false;
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions are denied')));
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//               'Location permissions are permanently denied, we cannot request permissions.')));
//       return false;
//     }
//     _getCurrentPosition();
//     return true;
//   }

//   Future<void> _getCurrentPosition() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     setState(() {
//       lat = position.latitude;
//       log = position.longitude;
//       Find_by_piont(lat, log);
//     });
//   }

//   var maxSqm1, minSqm1;
//   var maxSqm2, minSqm2;
//   var formatter = NumberFormat("##,###,###,##0.00", "en_US");
//   Future<void> Find_by_piont(double la, double lo) async {
//     final response = await http.get(Uri.parse(
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=${la},${lo}&key=AIzaSyAJt0Zghbk3qm_ZClIQOYeUT0AaV5TeOsI'));

//     if (response.statusCode == 200) {
//       var jsonResponse = json.decode(response.body);
//       List ls = jsonResponse['results'];
//       List ac;
//       bool check_sk = false, check_kn = false;
//       for (int j = 0; j < ls.length; j++) {
//         ac = jsonResponse['results'][j]['address_components'];
//         for (int i = 0; i < ac.length; i++) {
//           if (check_kn == false || check_sk == false) {
//             if (jsonResponse['results'][j]['address_components'][i]['types']
//                     [0] ==
//                 "political") {
//               setState(() {
//                 check_kn = true;
//                 district = (jsonResponse['results'][j]['address_components'][i]
//                     ['short_name']);
//               });
//             }
//             if (jsonResponse['results'][j]['address_components'][i]['types']
//                     [0] ==
//                 "administrative_area_level_3") {
//               setState(() {
//                 check_sk = true;
//                 commune = (jsonResponse['results'][j]['address_components'][i]
//                     ['short_name']);
//               });
//             }
//           }
//         }
//       }
//       final response_rc = await http.get(Uri.parse(
//           'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/map/check_price?Khan_Name=${district.toString()}&Sangkat_Name=${commune.toString()}'));
//       var jsonResponse_rc = json.decode(response_rc.body);
//       setState(() {
//         maxSqm1 = jsonResponse_rc['residential'][0]['Min_Value'].toString();
//         minSqm1 = jsonResponse_rc['residential'][0]['Max_Value'].toString();
//         maxSqm2 = jsonResponse_rc['commercial'][0]['Min_Value'].toString();
//         minSqm2 = jsonResponse_rc['commercial'][0]['Max_Value'].toString();
//         R_avg = (double.parse(maxSqm1.toString()) +
//                 double.parse(minSqm1.toString())) /
//             2;
//         C_avg = (double.parse(maxSqm2.toString()) +
//                 double.parse(minSqm2.toString())) /
//             2;
//       });
//     } else {
//       print(response.statusCode);
//     }
//   }

//   double? R_avg;
//   double? C_avg;
//   Future<void> change_price() async {
//     final response_rc = await http.get(Uri.parse(
//         'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/map/check_price?Khan_Name=${district.toString()}&Sangkat_Name=${commune.toString()}'));
//     var jsonResponse_rc = json.decode(response_rc.body);
//     setState(() {
//       maxSqm1 = jsonResponse_rc['residential'][0]['Min_Value'].toString();
//       minSqm1 = jsonResponse_rc['residential'][0]['Max_Value'].toString();
//       maxSqm2 = jsonResponse_rc['commercial'][0]['Min_Value'].toString();
//       minSqm2 = jsonResponse_rc['commercial'][0]['Max_Value'].toString();
//       R_avg = (double.parse(maxSqm1.toString()) +
//               double.parse(minSqm1.toString())) /
//           2;
//       C_avg = (double.parse(maxSqm2.toString()) +
//               double.parse(minSqm2.toString())) /
//           2;
//     });
//   }

//   @override
//   void initState() {
//     _handleLocationPermission();
//     super.initState();

//     requestModelAuto = AutoVerbalRequestModel(
//       property_type_id: "",
//       lat: "",
//       lng: "",
//       address: '',
//       approve_id: "", agent: "",
//       bank_branch_id: "",
//       bank_contact: "",
//       bank_id: "",
//       bank_officer: "",
//       code: "",
//       comment: "",
//       contact: "",
//       date: "",
//       image: "",
//       option: "",
//       owner: "",
//       user: "10",
//       verbal_com: '',
//       verbal_con: "",
//       verbal: [],
//       verbal_id: "0", verbal_khan: '',

//       // autoVerbal: [requestModelVerbal],
//       // data: requestModelVerbal,
//     );
//     // Future.delayed(const Duration(seconds: 5), () {
//     //   if (maxSqm1 == null) {
//     //     _getCurrentPosition();
//     //   }
//     // });
//   }

//   var lat;
//   var log;
//   var district;
//   double? wth;
//   double? wth2;
//   @override
//   Widget build(BuildContext context) {
//     var w = MediaQuery.of(context).size.width;
//     if (w < 600) {
//       wth = w * 0.6;
//       wth2 = w * 0.3;
//     } else {
//       wth = w * 0.5;
//       wth2 = w * 0.3;
//     }
//     DateTime timeNow = DateTime.now();

//     String formattedDate = DateFormat('dd MM yyyy').format(timeNow);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kwhite_new,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Scaffold.of(context).openDrawer();
//           },
//           icon: Icon(Icons.menu),
//         ),
//         title: TitleBar(),    
//       ),
//       backgroundColor: kwhite_new,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 5,),
//           Padding(
//             padding: const EdgeInsets.all(3.0),
//             child: Container(
//               decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: Colors.white,
//                     border: Border.all()
//                   ),
//                   height: 320,
//                   child: Column(
//                     children: [
//                     CarouselSlider(
//             items: imageSliders,
//             carouselController: _controller,
//             options: CarouselOptions(
//                 autoPlay: true,
//                 enlargeCenterPage: true,
//                 aspectRatio: 1.25,
//                 onPageChanged: (index, reason) {
//                   setState(() {
//                     _current = index;
//                   });
//                 }),
//                     ),
//                     Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: imgList.asMap().entries.map((entry) {
//               return GestureDetector(
//                 onTap: () => _controller.animateToPage(entry.key),
//                 child: Container(
//                   width: 12.0,
//                   height: 12.0,
//                   margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: (Theme.of(context).brightness == Brightness.dark
//                               ? Colors.white
//                               : Colors.black)
//                           .withOpacity(_current == entry.key ? 0.9 : 0.4)),
//                 ),
//               );
//             }).toList(),
//                     ),
//                   ]),
//                 ),
//           ),
//         //  Newbanner(),
//         //  SizedBox(height: 200,),
//         //   BannerSlide(),
//           Title_promotion2(
//             title_promo: 'Our Partners',
//             title_promo1: 'Show all',
//           ),
//           // Divider(
//           //   color: Colors.black,
//           //   thickness: 0.5,
//           // ),
//           Screen_slider(),
//           // SizedBox(
//           //   height: 15,
//           // ),
//           Title_promotion(
//             title_promo: 'Our Membership',
//             title_promo1: 'Show all',
//           ),
//           // Divider(
//           //   color: Colors.blueAccent,
//           //   thickness: 0.5,
//           // ),
//           Membership_real(),
//           // SizedBox(
//           //   height: 15,
//           // ),
//           //Title_promo(),
//          // Promotion(),
//         ],
//       ),
//     );
//   }

//   String? options;
//   String? commune;

//   var id_Sangkat;
//   List<dynamic> list_sangkat = [];
//   void Load_sangkat(String id) async {
//     setState(() {});
//     var rs = await http.get(Uri.parse(
//         'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/sangkat?Sangkat_Name=${id}'));
//     if (rs.statusCode == 200) {
//       var jsonData = jsonDecode(rs.body);
//       setState(() {
//         list_sangkat = jsonData;
//         id_Sangkat = int.parse(list_sangkat[0]['Sangkat_ID']);
//       });
//     }
//   }

//   String? province;

//   late List<dynamic> list_Khan;

//   int id_khan = 0;
//   void Load_khan(String district) async {
//     setState(() {});
//     var rs = await http.get(Uri.parse(
//         'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/khan?Khan_Name=${district}'));
//     if (rs.statusCode == 200) {
//       var jsonData = jsonDecode(rs.body);
//       setState(() {
//         list_Khan = jsonData;
//         id_khan = int.parse(list_Khan[0]['Khan_ID']);
//       });
//     }
//   }
// }
