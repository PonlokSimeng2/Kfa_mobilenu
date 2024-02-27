// // ignore_for_file: unused_import, prefer_const_constructors
// import 'dart:io';
// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:kfa_mobilenu/screen/Home/Home.dart';

// import 'graph.dart';
// import 'graph_report.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();

//   print("Handling a background message: ${message.messageId}");
// }

// void main() async {
//   if (Platform.isIOS) {
//     WidgetsFlutterBinding.ensureInitialized();
//     // await Firebase.initializeApp(
//     //     // options: DefaultFirebaseOptions.currentPlatform,
//     //     );
//   }
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(debugShowCheckedModeBanner: false, home: HomePage1()
//         //home:Body (email: '', first_name: '', from: '', gender: '', id: '', last_name: '', lat: null, log: null, tel: '', user: '',),
//         //home: HomePage(child: Container(),)
//         //home: Body(email: '', first_name: '', from: '', gender: '', id: '', last_name: '', lat: null, log: null, tel: '', user: '',),
//         );
//   }
// }

// class PhoneAuth extends StatefulWidget {
//   const PhoneAuth({super.key});

//   @override
//   // ignore: no_logic_in_create_state
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }
// }
// Import the generated file
// Import the generated file
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kfa_mobilenu/homescreen.dart';
import 'firebase_options.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  if (Platform.isIOS) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PhoneAuthScreen(),
    );
  }
}

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

final TextEditingController _phoneNumberController = TextEditingController();
final TextEditingController _smsCodeController = TextEditingController();

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _verificationId = '';

  // Future<void> _verifyPhoneNumber(String number) async {
  //   try {
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: _phoneNumberController.text,
  //       verificationCompleted: (auth.AuthCredential credential) async {
  //         auth.UserCredential userCredential =
  //             await auth.FirebaseAuth.instance.signInWithCredential(credential);
  //         //onCompleted(userCredential.user);
  //         print("Phone number automatically verified");
  //       },
  //       verificationFailed: (auth.FirebaseAuthException ex) async {
  //         print("Verification failed: ${ex.message}");
  //         //onCompleted(null);
  //       },
  //       codeSent: (String verId, [int forceResendingToken]) async {
  //         _verificationId = verId;
  //         auth.User user = await showDialog(
  //             context: context, builder: (context) => _alertDialog);
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         print("Auto retrieval timeout, verificationId: $verificationId");
  //       },
  //       timeout: Duration(seconds: 60),
  //     );
  //   } catch (e) {
  //     print("Error during phone number verification: $e");
  //   }
  // }
  _verifyPhoneNumber(String number) {
    // ignore: prefer_function_declarations_over_variables
    final verificationCompleted = (auth.AuthCredential credential) async {
      auth.UserCredential userCredential =
          await auth.FirebaseAuth.instance.signInWithCredential(credential);
      //onCompleted(userCredential.user);
    };
    // ignore: prefer_function_declarations_over_variables
    final verificationFailed = (auth.FirebaseAuthException ex) async {
      print('Error ${ex.message}');
      //onCompleted(null);
    };
    // ignore: prefer_function_declarations_over_variables
    final codeSent = (String verId, [int? forceResendingToken]) async {
      _verificationId = verId;
      auth.User user = await showDialog(
          context: context, builder: ((context) => _alertDialog)
          // onCompleted(user);
          );
    };
    // ignore: prefer_function_declarations_over_variables
    final codeAutoRetrievalTimeout = (String verId) async {
      _verificationId = verId;
      //onCompleted(null);
    };
    // ignore: prefer_function_declarations_over_variables
    final codeAutoRetrievevalTimeout = (String verId) async {
      _verificationId = verId;
      //onCompleted(null);
    };
    auth.FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<void> _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsCodeController.text,
      );

      await _auth.signInWithCredential(credential);
      print("User signed in");
    } catch (e) {
      print("Error during phone number sign in: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Phone Auth Example'),
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: _buildBody,
      ),
    );
    // Padding(
    //   padding: const EdgeInsets.all(16.0),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       TextField(
    //         controller: _phoneNumberController,
    //         keyboardType: TextInputType.phone,
    //         decoration: InputDecoration(
    //           labelText: 'Phone Number',
    //         ),
    //       ),
    //       SizedBox(height: 16.0),
    //       ElevatedButton(
    //         onPressed: _verifyPhoneNumber,
    //         child: Text('Verify Phone Number'),
    //       ),
    //       SizedBox(height: 16.0),
    //       TextField(
    //         controller: _smsCodeController,
    //         keyboardType: TextInputType.number,
    //         decoration: InputDecoration(
    //           labelText: 'SMS Code',
    //         ),
    //       ),
    //       SizedBox(height: 16.0),
    //       ElevatedButton(
    //         onPressed: _signInWithPhoneNumber,
    //         child: Text('Sign In'),
    //       ),
    //       //TextEditingControllerExampleApp(),
    //     ],
    //   ),
    // ),
    //);
  }

  get _buildBody {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSendCodeButton,
          _buildPhoneText,
        ],
      ),
    );
  }

  get _buildPhoneText {
    return ElevatedButton(
      child: Text("Send Code"),
      onPressed: () {
        String number =
            "+855" + getOnlyPhoneNumber(_phoneNumberController.text);
        print("number:$number");
        _verifyPhoneNumber(number);
      },
    );
  }

  String getOnlyPhoneNumber(String fullNumber) {
    if (fullNumber[0] == '0') {
      return fullNumber.substring(1, fullNumber.length);
    }
    return fullNumber;
  }

  get _buildSendCodeButton {
    return TextField(
      keyboardType: TextInputType.number,
      autocorrect: false,
      controller: _phoneNumberController,
      decoration: InputDecoration(
        prefixText: "+855",
        hintText: "Enter phone",
      ),
    );
  }

  onCompleted(auth.User user) {
    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Feed_back_11(
                user: user,
              )));
    } else {
      print('Error Login');
    }
  }

  get _alertDialog {
    return AlertDialog(
      title: Text("Enter Code"),
      content: TextField(
        controller: _smsCodeController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: "Enter code"),
      ),
      actions: [
        ElevatedButton(
          child: Text("Done"),
          onPressed: () async {
            auth.AuthCredential credential = auth.PhoneAuthProvider.credential(
                verificationId: _verificationId,
                smsCode: _smsCodeController.text.trim());
            auth.UserCredential userCredential =
                await _auth.signInWithCredential(credential);
            Navigator.of(context).pop(userCredential.user);
          },
        )
      ],
    );
  }
}
