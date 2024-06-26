import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kfa_mobilenu/afa/screens/Auth/register.dart';
import 'package:kfa_mobilenu/providers/cache_provider.dart';
import 'package:kfa_mobilenu/screen/Home/Home.dart';
import 'package:kfa_mobilenu/testpdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharePref = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharePrefProvider.overrideWithValue(sharePref)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: MyAppTestPDF(),
      home: const HomePage1(),
      //home: RegisterPage(),
      //home: MyDataTablePage(),
      // home: const save_image_after_add_verbal(
      //   set_data_verbal: '219K591F219Aacxfdiqmu',
      // ),
      // home: detail_verbal(
      //   set_data_verbal: '219K591F219Aacxfdiqmu',
      // ),
      // home:
      builder: BotToastInit(),
      //home: MyHomePageMeng()
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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
