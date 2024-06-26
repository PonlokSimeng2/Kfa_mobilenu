// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:readmore/readmore.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../widgets/auth_wrapper_widget.dart';
// import 'Contacts/ContactUs_sidebar.dart';

// // ignore: camel_case_types, must_be_immutable
// class Detialbody_screen extends ConsumerStatefulWidget {
//   Detialbody_screen({super.key, required this.list});
//   var list;
//   @override
//   HomeViewState createState() => HomeViewState();
// }

// var textstyleblackbold = const TextStyle(
//     color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
// var textstyleblack = const TextStyle(
//   color: Colors.black,
//   fontSize: 18,
// );

// class HomeViewState extends ConsumerState<Detialbody_screen> {
//   @override
//   void initState() {
//     super.initState();
//     // "ref" can be used in all life-cycles of a StatefulWidget.
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ignore: no_leading_underscores_for_local_identifiers
//     Future<void> _makePhoneCall(String url) async {
//       // ignore: deprecated_member_use
//       await launch(
//         url,
//         forceSafariVC: false,
//         forceWebView: false,
//       );
//     }

//     return AuthWrapperWidget(
//       child: Scaffold(
//         // appBar: AppBar(
//         //   leading: InkWell(
//         //       onTap: () {
//         //         Navigator.pop(context);
//         //       },
//         //       child: Icon(Icons.backspace_outlined, color: Colors.black)),
//         //   backgroundColor: Colors.white,
//         //   centerTitle: true,
//         //   title: const Text(
//         //     "Properties",
//         //     style: TextStyle(color: Colors.black),
//         //   ),
//         // ),
//         body: Stack(
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 children: [
//                   // const SizedBox(
//                   //   height: 30,
//                   // ),
//                   Expanded(
//                     flex: 2,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           CachedNetworkImage(
//                             imageUrl: widget.list['url'].toString(),
//                             fit: BoxFit.cover,
//                             progressIndicatorBuilder: (
//                               context,
//                               url,
//                               downloadProgress,
//                             ) =>
//                                 Center(
//                               child: CircularProgressIndicator(
//                                 value: downloadProgress.progress,
//                               ),
//                             ),
//                             errorWidget: (context, url, error) =>
//                                 const Icon(Icons.error),
//                           ),
//                           CachedNetworkImage(
//                             imageUrl: widget.list['url'].toString(),
//                             fit: BoxFit.cover,
//                             progressIndicatorBuilder: (
//                               context,
//                               url,
//                               downloadProgress,
//                             ) =>
//                                 Center(
//                               child: CircularProgressIndicator(
//                                 value: downloadProgress.progress,
//                               ),
//                             ),
//                             errorWidget: (context, url, error) =>
//                                 const Icon(Icons.error),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 3,
//                     child: SingleChildScrollView(
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         decoration: const BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(30.0),
//                             topLeft: Radius.circular(30.0),
//                           ),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Column(
//                               children: [
//                                 SizedBox(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.07,
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.9,
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             widget.list['type'].toString(),
//                                             style: const TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             widget.list['hometype'].toString(),
//                                           ),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.only(right: 5, left: 5),
//                                   child: Container(
//                                     decoration: const BoxDecoration(
//                                       color: Color.fromARGB(255, 237, 232, 232),
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(10)),
//                                     ),
//                                     height: MediaQuery.of(context).size.height *
//                                         0.09,
//                                     child: ListView(
//                                       scrollDirection: Axis.horizontal,
//                                       children: [
//                                         SizedBox(
//                                           //color: Colors.amber,
//                                           height: MediaQuery.of(context)
//                                               .size
//                                               .height,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.2,
//                                           child: Column(
//                                             children: [
//                                               const Icon(
//                                                 Icons.bathtub,
//                                                 size: 45,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   Text(
//                                                     '${widget.list['floor']}',
//                                                     style: textstyleblackbold,
//                                                   ),
//                                                   const SizedBox(
//                                                     width: 5,
//                                                   ),
//                                                   Text(
//                                                     'Floor',
//                                                     style: textstyleblackbold,
//                                                   ),
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 10,
//                                         ),
//                                         SizedBox(
//                                           // color: Colors.amber,
//                                           height: MediaQuery.of(context)
//                                               .size
//                                               .height,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.3,
//                                           child: Column(
//                                             children: [
//                                               const Icon(
//                                                 Icons.bed,
//                                                 size: 45,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   Text(
//                                                     '${widget.list['bed']}',
//                                                     style: textstyleblackbold,
//                                                   ),
//                                                   const SizedBox(
//                                                     width: 5,
//                                                   ),
//                                                   Text(
//                                                     'Bed',
//                                                     style: textstyleblackbold,
//                                                   ),
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 10,
//                                         ),
//                                         SizedBox(
//                                           //color: Colors.amber,
//                                           height: MediaQuery.of(context)
//                                               .size
//                                               .height,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.2,
//                                           child: Column(
//                                             children: [
//                                               const Icon(
//                                                 Icons.bathtub,
//                                                 size: 45,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   Text(
//                                                     '${widget.list['bath']}',
//                                                     style: textstyleblackbold,
//                                                   ),
//                                                   const SizedBox(
//                                                     width: 5,
//                                                   ),
//                                                   Text(
//                                                     'Bath',
//                                                     style: textstyleblackbold,
//                                                   ),
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 4,
//                                         ),
//                                         SizedBox(
//                                           // color: Colors.amber,
//                                           height: MediaQuery.of(context)
//                                               .size
//                                               .height,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.4,
//                                           child: Column(
//                                             children: [
//                                               const Icon(
//                                                 Icons.bathtub,
//                                                 size: 45,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   Text(
//                                                     '${widget.list['Livingroom']}',
//                                                     style: textstyleblackbold,
//                                                   ),
//                                                   const SizedBox(
//                                                     width: 5,
//                                                   ),
//                                                   Text(
//                                                     'Living Room',
//                                                     style: textstyleblackbold,
//                                                   ),
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SingleChildScrollView(
//                               child: Column(
//                                 children: [
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   SizedBox(
//                                     // height: MediaQuery.of(context).size.height * 0.09,
//                                     width:
//                                         MediaQuery.of(context).size.width * 0.9,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Description',
//                                           style: textstyleblackbold,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                       right: 4.0,
//                                       left: 4.0,
//                                     ),
//                                     child: SizedBox(
//                                       height:
//                                           MediaQuery.of(context).size.height *
//                                               0.13,
//                                       child: const SingleChildScrollView(
//                                         reverse: false,
//                                         child: ReadMoreText(
//                                           // get api description
//                                           // (('${widget.list['description']}') ==
//                                           //         'null')
//                                           //     ? ''
//                                           //     : '${widget.list['description']}',
//                                           'This may seem like a no-brainer, but your real estate listing description should be accurate. If the house is barely 900 square feet, writing that the space is “sprawling” is dishonest. When you say a home is in “excellent condition” and there is water damage throughout the house and the back deck is rotting, a potential buyer will be turned off by seeing this on arrival. Setting unrealistic expectations helps no one.',
//                                           trimMode: TrimMode.Line,
//                                           trimLines: 3,
//                                           colorClickableText: Colors.pink,
//                                           trimCollapsedText: 'Show more',
//                                           trimExpandedText: 'Show less',
//                                           moreStyle: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                           style: TextStyle(fontSize: 17),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Center(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             "Contact",
//                                             style: textstyleblackbold,
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width *
//                                                 0.9,
//                                         child: Container(
//                                           height: 110,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.9,
//                                           decoration: const BoxDecoration(
//                                             //color: Colors.amber,
//                                             borderRadius: BorderRadius.all(
//                                               Radius.circular(10),
//                                             ),
//                                           ),
//                                           child: Column(
//                                             children: [
//                                               Hotline(
//                                                 onPress: () => setState(() {
//                                                   _makePhoneCall(
//                                                     'tel:096 670 5117',
//                                                   );
//                                                 }),
//                                                 icon: Icons.phone,
//                                                 phone: '(855) 96 670 5117',
//                                               ),
//                                               Hotline(
//                                                 onPress: () => setState(() {
//                                                   _makePhoneCall(
//                                                     'tel:077 216 168',
//                                                   );
//                                                 }),
//                                                 icon: Icons.phone,
//                                                 phone: '(855) 77 216 168',
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 320,
//               right: 5,
//               child: Container(
//                 height: 30,
//                 width: 100,
//                 decoration: const BoxDecoration(
//                   color: Color.fromARGB(255, 159, 111, 69),
//                   borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "${widget.list['price'].toString()} \$",
//                     style: const TextStyle(
//                       color: Color.fromARGB(255, 17, 19, 20),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 20,
//               left: 5,
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     color: Color.fromARGB(255, 185, 43, 43),
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                   ),
//                   height: 30,
//                   width: 50,
//                   child: const Icon(
//                     weight: 100.0,
//                     Icons.arrow_back_ios_new_rounded,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
