// import 'dart:convert';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:kfa_mobilenu/phone_otp/passcode_screen.dart';
// import 'package:pinput/pinput.dart';
// import 'package:dio/dio.dart';
// import '../Memory_local/database.dart';
// import '../afa/components/contants.dart';
// import 'package:http/http.dart' as http;
// import '../api/api_service.dart';
// import '../models/register_model.dart';

// class MyPhone extends StatefulWidget {
//   const MyPhone({Key? key, this.phonenumber}) : super(key: key);
//   final String? phonenumber;
//   @override
//   State<MyPhone> createState() => _MyPhoneState();
// }

// class _MyPhoneState extends State<MyPhone> {
//   bool validateAndSave() {
//     final form = _formKey.currentState;
//     if (form!.validate()) {
//       form.save();
//       return true;
//     }
//     return false;
//   }

//   MyDb mydb = MyDb();
//   TextEditingController countryController = TextEditingController();
//   TextEditingController numberController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     // TODO: implement initState
//     countryController.text = "+855";
//     super.initState();
//   }

//   RegisterRequestModel requestModel = RegisterRequestModel(
//     phonenumber: '',
//     otp: '',
//     passcode: '',
//   );
//   @override
//   Widget build(BuildContext context) {
//     var otp, field_otp;
//     Future<void> getOTP() async {
//       var request = http.Request(
//           'GET',
//           Uri.parse(
//               'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/getotp/user?tel_num=${requestModel.phonenumber}'));

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(await response.stream.bytesToString());
//         setState(() {
//           otp = jsonResponse['otp'].toString();
//           print("\nkokokok $otp\n");
//         });
//       } else {
//         print(response.reasonPhrase);
//       }
//     }

//     setState(() {
//       numberController;
//       print(numberController);
//     });
//     return Scaffold(
//       body: Form(
//         key: _formKey,
//         child: Container(
//           margin: EdgeInsets.only(left: 25, right: 25),
//           alignment: Alignment.center,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/img1.png',
//                   width: 150,
//                   height: 150,
//                 ),
//                 const SizedBox(
//                   height: 25,
//                 ),
//                 const Text(
//                   "Phone Verification",
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const Text(
//                   "We need to register your phone without getting started!",
//                   style: TextStyle(
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 TextFormField(
//                   // controller: Email,
//                   onSaved: (input) => requestModel.phonenumber = input!,
//                   keyboardAppearance: Brightness.light,
//                   keyboardType: TextInputType.emailAddress,
//                   scrollPadding: const EdgeInsets.only(top: 5000),
//                   decoration: InputDecoration(
//                     fillColor: Color.fromARGB(255, 255, 255, 255),
//                     filled: true,
//                     labelText: 'Phone',
//                     prefixIcon: Icon(
//                       Icons.phone,
//                       color: kPrimaryColor,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                   validator: (input) {
//                     if (input == null || input.isEmpty) {
//                       return 'require *';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 SizedBox(
//                   width: 150,
//                   child: AnimatedButton(
//                     text: 'Send Verify Code',
//                     color: kwhite_new,
//                     pressEvent: () async {
//                       if (validateAndSave()) {
//                         //if (otp == 1234) {
//                         //បិទសិន
//                         if (otp == null || otp != field_otp) {
//                           await getOTP();
//                           //ignore: use_build_context_synchronously
//                           AwesomeDialog(
//                             context: context,
//                             animType: AnimType.scale,
//                             dialogType: DialogType.info,
//                             keyboardAware: true,
//                             body: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 children: <Widget>[
//                                   Text(
//                                     'Enter OTP Code',
//                                     style:
//                                         Theme.of(context).textTheme.titleLarge,
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   // Material(
//                                   //   elevation: 0,
//                                   //   color: Colors.blueGrey.withAlpha(40),
//                                   //   child: TextFormField(
//                                   //     autofocus: true,
//                                   //     minLines: 1,
//                                   //     onChanged: (value) {
//                                   //       setState(() {
//                                   //         field_otp = value;
//                                   //         requestModel.OTP_Code = value;
//                                   //         if (otp == field_otp) {
//                                   //           Navigator.pop(context);
//                                   //           ScaffoldMessenger.of(context)
//                                   //               .showSnackBar(
//                                   //             SnackBar(
//                                   //                 content: Text(
//                                   //               "Correct OTP",
//                                   //             )),
//                                   //           );
//                                   //         }
//                                   //       });
//                                   //     },
//                                   //     decoration: const InputDecoration(
//                                   //       border: InputBorder.none,
//                                   //     ),
//                                   //   ),
//                                   // ),
//                                   Pinput(
//                                     length: 6,
//                                     showCursor: true,
//                                     senderPhoneNumber: requestModel.phonenumber,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         field_otp = value;
//                                         requestModel.otp = value;
//                                         if (otp == field_otp) {
//                                           Navigator.push<void>(
//                                             context,
//                                             MaterialPageRoute<void>(
//                                               builder: (BuildContext context) =>
//                                                   const MyPasscodeHomePage(),
//                                             ),
//                                           );
//                                           // Navigator.pop(context);
//                                           // ScaffoldMessenger.of(context)
//                                           //     .showSnackBar(
//                                           //   SnackBar(
//                                           //       content: Text(
//                                           //     "Correct OTP",
//                                           //   )),
//                                           // );
//                                         }
//                                       });
//                                     },
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   AnimatedButton(
//                                     isFixedHeight: false,
//                                     text: 'Close',
//                                     pressEvent: () {
//                                       Navigator.pop(context);
//                                     },
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ).show();
//                         } else if (otp == field_otp) {
//                           setState(() {
//                             // isApiCallProcess = true;
//                             // requestModel.control_user = set_id_user.toString();
//                           });
//                           // if (get_bytes != null || _byesData != null) {
//                           //   await uploadImage();
//                           // }
//                           APIservice apIservice = APIservice();
//                           apIservice.register(requestModel).then((value) async {
//                             setState(() {
//                               // isApiCallProcess = false;
//                             });
//                             if (value.message ==
//                                 "User successfully registered") {
//                               await mydb.open_user();
//                               await mydb.db.rawInsert(
//                                   "INSERT INTO user (tel_num) VALUES (?);", [
//                                 requestModel.phonenumber,
//                               ]);
//                               // ignore: use_build_context_synchronously
//                               AwesomeDialog(
//                                 context: context,
//                                 animType: AnimType.leftSlide,
//                                 headerAnimationLoop: false,
//                                 dialogType: DialogType.success,
//                                 showCloseIcon: false,
//                                 title: value.message,
//                                 autoHide: Duration(seconds: 3),
//                                 onDismissCallback: (type) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text("New User Added")),
//                                   );
//                                   Get.to(() => MyPasscodeHomePage());
//                                 },
//                               ).show();
//                             } else if (value.message ==
//                                 "User unsuccessfully registered") {
//                               AwesomeDialog(
//                                 context: context,
//                                 dialogType: DialogType.error,
//                                 animType: AnimType.rightSlide,
//                                 headerAnimationLoop: false,
//                                 title: 'Error',
//                                 desc: "This Email is already registered",
//                                 btnOkOnPress: () {},
//                                 btnOkIcon: Icons.cancel,
//                                 btnOkColor: Colors.red,
//                               ).show();
//                               // print(value.message);
//                             }
//                           });
//                         }
//                       }
//                     },
//                   ),
//                 )
//                 // SizedBox(
//                 //   width: double.infinity,
//                 //   height: 45,
//                 //   child: ElevatedButton(
//                 //       style: ElevatedButton.styleFrom(
//                 //           backgroundColor: Colors.green.shade600,
//                 //           shape: RoundedRectangleBorder(
//                 //               borderRadius: BorderRadius.circular(10))),
//                 //       onPressed: () {
//                 //         if (validateAndSave()) {
//                 //           Navigator.pushNamed(context, 'verify');
//                 //         }
//                 //       },
//                 //       child: const Text("Send the code")),
//                 // )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
