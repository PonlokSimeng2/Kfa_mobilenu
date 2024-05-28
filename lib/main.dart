// ignore_for_file: unused_import, prefer_const_constructors
import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kfa_mobilenu/afa/screens/Auth/login_page.dart';
import 'package:kfa_mobilenu/screen/Home/Home.dart';
import 'graph.dart';
import 'graph_report.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  // if (Platform.isIOS) {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   // await Firebase.initializeApp(
  //   //     // options: DefaultFirebaseOptions.currentPlatform,
  //   //     );
  // }
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      // home: HomePage1()
      //home:Body (email: '', first_name: '', from: '', gender: '', id: '', last_name: '', lat: null, log: null, tel: '', user: '',),
      //home: HomePage(child: Container(),)
      //home: Body(email: '', first_name: '', from: '', gender: '', id: '', last_name: '', lat: null, log: null, tel: '', user: '',),
    );
  }
}

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:kfa_mobilenu/homescreen.dart';
// import 'package:kfa_mobilenu/verify.dart';
// import 'firebase_options.dart';
// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// void main() async {
//   //if (Platform.isIOS) {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   // }
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: PhoneAuthScreen(),
//     );
//   }
// }

// class PhoneAuthScreen extends StatefulWidget {
//   const PhoneAuthScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
// }

// final TextEditingController _phoneNumberController = TextEditingController();
// final TextEditingController _smsCodeController = TextEditingController();

// class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   String _verificationId = '';

//   // Future<void> _verifyPhoneNumber(String number) async {
//   //   try {
//   //     await FirebaseAuth.instance.verifyPhoneNumber(
//   //       phoneNumber: _phoneNumberController.text,
//   //       verificationCompleted: (auth.AuthCredential credential) async {
//   //         auth.UserCredential userCredential =
//   //             await auth.FirebaseAuth.instance.signInWithCredential(credential);
//   //         //onCompleted(userCredential.user);
//   //         print("Phone number automatically verified");
//   //       },
//   //       verificationFailed: (auth.FirebaseAuthException ex) async {
//   //         print("Verification failed: ${ex.message}");
//   //         //onCompleted(null);
//   //       },
//   //       codeSent: (String verId, [int forceResendingToken]) async {
//   //         _verificationId = verId;
//   //         auth.User user = await showDialog(
//   //             context: context, builder: (context) => _alertDialog);
//   //       },
//   //       codeAutoRetrievalTimeout: (String verificationId) {
//   //         print("Auto retrieval timeout, verificationId: $verificationId");
//   //       },
//   //       timeout: Duration(seconds: 60),
//   //     );
//   //   } catch (e) {
//   //     print("Error during phone number verification: $e");
//   //   }
//   // }
//   _verifyPhoneNumber(String number) {
//     // ignore: prefer_function_declarations_over_variables
//     final verificationCompleted = (auth.AuthCredential credential) async {
//       auth.UserCredential userCredential =
//           await auth.FirebaseAuth.instance.signInWithCredential(credential);
//       //onCompleted(userCredential.user);
//     };
//     // ignore: prefer_function_declarations_over_variables
//     final verificationFailed = (auth.FirebaseAuthException ex) async {
//       print('Error ${ex.message}');
//       //onCompleted(null);
//     };
//     // ignore: prefer_function_declarations_over_variables
//     final codeSent = (String verId, [int? forceResendingToken]) async {
//       _verificationId = verId;
//       auth.User user = await showDialog(
//           context: context, builder: ((context) => _alertDialog)
//           // onCompleted(user);
//           );
//     };
//     // ignore: prefer_function_declarations_over_variables
//     final codeAutoRetrievalTimeout = (String verId) async {
//       _verificationId = verId;
//       //onCompleted(null);
//     };
//     // ignore: prefer_function_declarations_over_variables
//     final codeAutoRetrievevalTimeout = (String verId) async {
//       _verificationId = verId;
//       //onCompleted(null);
//     };
//     auth.FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: number,
//         timeout: Duration(seconds: 60),
//         verificationCompleted: verificationCompleted,
//         verificationFailed: verificationFailed,
//         codeSent: codeSent,
//         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
//   }

//   Future<void> _signInWithPhoneNumber() async {
//     try {
//       final AuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId,
//         smsCode: _smsCodeController.text,
//       );

//       await _auth.signInWithCredential(credential);
//       print("User signed in");
//     } catch (e) {
//       print("Error during phone number sign in: $e");
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     _phoneNumberController.text = "+855";
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Firebase Phone Auth Example'),
//       // ),
//       body: InkWell(
//         onTap: () {
//           FocusScope.of(context).requestFocus(FocusNode());
//         },
//         child: _buildBody,
//       ),
//     );
//     // Padding(
//     //   padding: const EdgeInsets.all(16.0),
//     //   child: Column(
//     //     mainAxisAlignment: MainAxisAlignment.center,
//     //     children: [
//     //       TextField(
//     //         controller: _phoneNumberController,
//     //         keyboardType: TextInputType.phone,
//     //         decoration: InputDecoration(
//     //           labelText: 'Phone Number',
//     //         ),
//     //       ),
//     //       SizedBox(height: 16.0),
//     //       ElevatedButton(
//     //         onPressed: _verifyPhoneNumber,
//     //         child: Text('Verify Phone Number'),
//     //       ),
//     //       SizedBox(height: 16.0),
//     //       TextField(
//     //         controller: _smsCodeController,
//     //         keyboardType: TextInputType.number,
//     //         decoration: InputDecoration(
//     //           labelText: 'SMS Code',
//     //         ),
//     //       ),
//     //       SizedBox(height: 16.0),
//     //       ElevatedButton(
//     //         onPressed: _signInWithPhoneNumber,
//     //         child: Text('Sign In'),
//     //       ),
//     //       //TextEditingControllerExampleApp(),
//     //     ],
//     //   ),
//     // ),
//     //);
//   }

//   get _buildBody {
//     return Container(
//       margin: EdgeInsets.only(left: 25, right: 25),
//       alignment: Alignment.center,
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/img1.png',
//               width: 150,
//               height: 150,
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             Text(
//               "Phone Verification",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Text(
//               "We need to register your phone without getting started!",
//               style: TextStyle(
//                 fontSize: 16,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Container(
//               height: 55,
//               decoration: BoxDecoration(
//                   border: Border.all(width: 1, color: Colors.grey),
//                   borderRadius: BorderRadius.circular(10)),
//               child: Expanded(
//                   child: TextField(
//                 keyboardType: TextInputType.number,
//                 autocorrect: false,
//                 controller: _phoneNumberController,
//                 decoration: InputDecoration(
//                   prefixText: "+855",
//                   hintText: "Enter phone",
//                 ),
//               )),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             SizedBox(
//               width: double.infinity,
//               height: 45,
//               child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       primary: Colors.green.shade600,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10))),
//                   onPressed: () {
//                     String number = "+855" +
//                         getOnlyPhoneNumber(_phoneNumberController.text);
//                     print("number:$number");
//                     _verifyPhoneNumber(number);
//                   },
//                   child: Text("Send the code")),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   get _buildPhoneText {
//     return ElevatedButton(
//       child: Text("Send Code"),
//       onPressed: () {
//         String number =
//             "+855" + getOnlyPhoneNumber(_phoneNumberController.text);
//         print("number:$number");
//         _verifyPhoneNumber(number);
//       },
//     );
//   }

//   String getOnlyPhoneNumber(String fullNumber) {
//     if (fullNumber[0] == '0') {
//       return fullNumber.substring(1, fullNumber.length);
//     }
//     return fullNumber;
//   }

//   get _buildSendCodeButton {
//     return TextField(
//       keyboardType: TextInputType.number,
//       autocorrect: false,
//       controller: _phoneNumberController,
//       decoration: InputDecoration(
//         prefixText: "+855",
//         hintText: "Enter phone",
//       ),
//     );
//   }

//   onCompleted(auth.User user) {
//     if (user != null) {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => Feed_back_11(
//                 user: user,
//               )));
//     } else {
//       print('Error Login');
//     }
//   }

//   get _alertDialog {
//     return AlertDialog(
//       title: Text("Enter Code"),
//       content: TextField(
//         controller: _smsCodeController,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(hintText: "Enter code"),
//       ),
//       actions: [
//         ElevatedButton(
//           child: Text("Done"),
//           onPressed: () async {
//             auth.AuthCredential credential = auth.PhoneAuthProvider.credential(
//                 verificationId: _verificationId,
//                 smsCode: _smsCodeController.text.trim());
//             auth.UserCredential userCredential =
//                 await _auth.signInWithCredential(credential);
//             Navigator.of(context).pop(userCredential.user);
//           },
//         )
//       ],
//     );
//   }
// }
//phone otp
// Import the generated file
// Import the generated file
// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:kfa_mobilenu/homescreen.dart';
// import 'firebase_options.dart';
// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// void main() async {
//   //if (Platform.isIOS) {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   //}
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: PhoneAuthScreen(),
//     );
//   }
// }

// class PhoneAuthScreen extends StatefulWidget {
//   const PhoneAuthScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
// }

// final TextEditingController _phoneNumberController = TextEditingController();
// final TextEditingController _smsCodeController = TextEditingController();

// class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   String _verificationId = '';

//   // Future<void> _verifyPhoneNumber(String number) async {
//   //   try {
//   //     await FirebaseAuth.instance.verifyPhoneNumber(
//   //       phoneNumber: _phoneNumberController.text,
//   //       verificationCompleted: (auth.AuthCredential credential) async {
//   //         auth.UserCredential userCredential =
//   //             await auth.FirebaseAuth.instance.signInWithCredential(credential);
//   //         //onCompleted(userCredential.user);
//   //         print("Phone number automatically verified");
//   //       },
//   //       verificationFailed: (auth.FirebaseAuthException ex) async {
//   //         print("Verification failed: ${ex.message}");
//   //         //onCompleted(null);
//   //       },
//   //       codeSent: (String verId, [int forceResendingToken]) async {
//   //         _verificationId = verId;
//   //         auth.User user = await showDialog(
//   //             context: context, builder: (context) => _alertDialog);
//   //       },
//   //       codeAutoRetrievalTimeout: (String verificationId) {
//   //         print("Auto retrieval timeout, verificationId: $verificationId");
//   //       },
//   //       timeout: Duration(seconds: 60),
//   //     );
//   //   } catch (e) {
//   //     print("Error during phone number verification: $e");
//   //   }
//   // }
//   _verifyPhoneNumber(String number) {
//     // ignore: prefer_function_declarations_over_variables
//     final verificationCompleted = (auth.AuthCredential credential) async {
//       auth.UserCredential userCredential =
//           await auth.FirebaseAuth.instance.signInWithCredential(credential);
//       //onCompleted(userCredential.user);
//     };
//     // ignore: prefer_function_declarations_over_variables
//     final verificationFailed = (auth.FirebaseAuthException ex) async {
//       print('Error ${ex.message}');
//       //onCompleted(null);
//     };
//     // ignore: prefer_function_declarations_over_variables
//     final codeSent = (String verId, [int? forceResendingToken]) async {
//       _verificationId = verId;
//       auth.User user = await showDialog(
//           context: context, builder: ((context) => _alertDialog)
//           // onCompleted(user);
//           );
//     };
//     // ignore: prefer_function_declarations_over_variables
//     final codeAutoRetrievalTimeout = (String verId) async {
//       _verificationId = verId;
//       //onCompleted(null);
//     };
//     // ignore: prefer_function_declarations_over_variables
//     final codeAutoRetrievevalTimeout = (String verId) async {
//       _verificationId = verId;
//       //onCompleted(null);
//     };
//     auth.FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: number,
//         timeout: Duration(seconds: 60),
//         verificationCompleted: verificationCompleted,
//         verificationFailed: verificationFailed,
//         codeSent: codeSent,
//         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
//   }

//   Future<void> _signInWithPhoneNumber() async {
//     try {
//       final AuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId,
//         smsCode: _smsCodeController.text,
//       );

//       await _auth.signInWithCredential(credential);
//       print("User signed in");
//     } catch (e) {
//       print("Error during phone number sign in: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Firebase Phone Auth Example'),
//       // ),
//       body: InkWell(
//         onTap: () {
//           FocusScope.of(context).requestFocus(FocusNode());
//         },
//         child: _buildBody,
//       ),
//     );
//     // Padding(
//     //   padding: const EdgeInsets.all(16.0),
//     //   child: Column(
//     //     mainAxisAlignment: MainAxisAlignment.center,
//     //     children: [
//     //       TextField(
//     //         controller: _phoneNumberController,
//     //         keyboardType: TextInputType.phone,
//     //         decoration: InputDecoration(
//     //           labelText: 'Phone Number',
//     //         ),
//     //       ),
//     //       SizedBox(height: 16.0),
//     //       ElevatedButton(
//     //         onPressed: _verifyPhoneNumber,
//     //         child: Text('Verify Phone Number'),
//     //       ),
//     //       SizedBox(height: 16.0),
//     //       TextField(
//     //         controller: _smsCodeController,
//     //         keyboardType: TextInputType.number,
//     //         decoration: InputDecoration(
//     //           labelText: 'SMS Code',
//     //         ),
//     //       ),
//     //       SizedBox(height: 16.0),
//     //       ElevatedButton(
//     //         onPressed: _signInWithPhoneNumber,
//     //         child: Text('Sign In'),
//     //       ),
//     //       //TextEditingControllerExampleApp(),
//     //     ],
//     //   ),
//     // ),
//     //);
//   }

//   get _buildBody {
//     return Container(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _buildSendCodeButton,
//           _buildPhoneText,
//         ],
//       ),
//     );
//   }

//   get _buildPhoneText {
//     return ElevatedButton(
//       child: Text("Send Code"),
//       onPressed: () {
//         String number =
//             "+855" + getOnlyPhoneNumber(_phoneNumberController.text);
//         print("number:$number");
//         _verifyPhoneNumber(number);
//       },
//     );
//   }

//   String getOnlyPhoneNumber(String fullNumber) {
//     if (fullNumber[0] == '0') {
//       return fullNumber.substring(1, fullNumber.length);
//     }
//     return fullNumber;
//   }

//   get _buildSendCodeButton {
//     return TextField(
//       keyboardType: TextInputType.number,
//       autocorrect: false,
//       controller: _phoneNumberController,
//       decoration: InputDecoration(
//         prefixText: "+855",
//         hintText: "Enter phone",
//       ),
//     );
//   }

//   onCompleted(auth.User user) {
//     if (user != null) {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => Feed_back_11(
//                 user: user,
//               )));
//     } else {
//       print('Error Login');
//     }
//   }

//   get _alertDialog {
//     return AlertDialog(
//       title: Text("Enter Code"),
//       content: TextField(
//         controller: _smsCodeController,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(hintText: "Enter code"),
//       ),
//       actions: [
//         ElevatedButton(
//           child: Text("Done"),
//           onPressed: () async {
//             auth.AuthCredential credential = auth.PhoneAuthProvider.credential(
//                 verificationId: _verificationId,
//                 smsCode: _smsCodeController.text.trim());
//             auth.UserCredential userCredential =
//                 await _auth.signInWithCredential(credential);
//             Navigator.of(context).pop(userCredential.user);
//           },
//         )
//       ],
//     );
//   }
// }


//sqlite
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Passcode Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: PasscodeScreen(),
//     );
//   }
// }

// class DatabaseHelper {
//   static Database? _database;

//   Future<Database> get database async {
//     _database ??= await initDatabase();
//     return _database!;
//   }

//   Future<Database> initDatabase() async {
//     String path = join(await getDatabasesPath(), 'passcode_database.db');
//     return openDatabase(path, version: 1, onCreate: (db, version) async {
//       await db.execute(
//         'CREATE TABLE passcode(id INTEGER PRIMARY KEY, passcode TEXT)',
//       );
//     });
//   }

//   Future<void> setPasscode(String passcode) async {
//     final Database db = await database;
//     await db.insert(
//       'passcode',
//       {'id': 1, 'passcode': passcode},
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<String?> getPasscode() async {
//     final Database db = await database;
//     final List<Map<String, dynamic>> maps =
//         await db.query('passcode', where: 'id = 1');
//     if (maps.isNotEmpty) {
//       return maps.first['passcode'];
//     }
//     return null;
//   }
// }

// class PasscodeScreen extends StatefulWidget {
//   @override
//   _PasscodeScreenState createState() => _PasscodeScreenState();
// }

// class _PasscodeScreenState extends State<PasscodeScreen> {
//   TextEditingController _passcodeController = TextEditingController();
//   DatabaseHelper _databaseHelper = DatabaseHelper();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Set Passcode'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextField(
//                 controller: _passcodeController,
//                 keyboardType: TextInputType.number,
//                 maxLength: 4,
//                 decoration: InputDecoration(
//                   labelText: 'Enter Passcode',
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () async {
//                   String passcode = _passcodeController.text;
//                   await _databaseHelper.setPasscode(passcode);
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PasscodeVerificationScreen(),
//                     ),
//                   );
//                 },
//                 child: Text('Set Passcode'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PasscodeVerificationScreen extends StatefulWidget {
//   @override
//   _PasscodeVerificationScreenState createState() =>
//       _PasscodeVerificationScreenState();
// }

// class _PasscodeVerificationScreen extends StatefulWidget {
//   @override
//   _PasscodeVerificationScreenState createState() =>
//       _PasscodeVerificationScreenState();
// }

// class _PasscodeVerificationScreenState
//     extends State<PasscodeVerificationScreen> {
//   TextEditingController _passcodeController = TextEditingController();
//   DatabaseHelper _databaseHelper = DatabaseHelper();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Verify Passcode'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextField(
//                 controller: _passcodeController,
//                 keyboardType: TextInputType.number,
//                 maxLength: 4,
//                 decoration: InputDecoration(
//                   labelText: 'Enter Passcode',
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () async {
//                   String? storedPasscode = await _databaseHelper.getPasscode();
//                   String enteredPasscode = _passcodeController.text;
//                   if (storedPasscode != null &&
//                       storedPasscode == enteredPasscode) {
//                     // Passcode matched
//                     // Navigate to home screen
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => HomeScreen(),
//                       ),
//                     );
//                   } else {
//                     // Passcode did not match
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: Text('Error'),
//                           content: Text('Passcode does not match.'),
//                           actions: <Widget>[
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text('OK'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   }
//                 },
//                 child: Text('Verify Passcode'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.logout),
//             tooltip: 'Logout',
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => HomeScreenLogin(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Text('Welcome!'),
//       ),
//     );
//   }
// }

// class HomeScreenLogin extends StatelessWidget {
//   TextEditingController _passcodeController = TextEditingController();
//   DatabaseHelper _databaseHelper = DatabaseHelper();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextField(
//                 controller: _passcodeController,
//                 keyboardType: TextInputType.number,
//                 maxLength: 4,
//                 decoration: InputDecoration(
//                   labelText: 'Enter Passcode',
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () async {
//                   String? storedPasscode = await _databaseHelper.getPasscode();
//                   String enteredPasscode = _passcodeController.text;
//                   if (storedPasscode != null &&
//                       storedPasscode == enteredPasscode) {
//                     // Passcode matched
//                     // Navigate to home screen
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => HomeScreen(),
//                       ),
//                     );
//                   } else {
//                     // Passcode did not match
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: Text('Error'),
//                           content: Text('Passcode does not match.'),
//                           actions: <Widget>[
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text('OK'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   }
//                 },
//                 child: Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
