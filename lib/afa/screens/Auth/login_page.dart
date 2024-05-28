// ignore_for_file: unused_import, non_constant_identifier_names, prefer_const_constructors, avoid_print, prefer_is_empty

import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:kfa_mobilenu/afa/screens/Auth/register.dart';
import '../../../Memory_local/Local_data.dart';
import '../../../Memory_local/show_data_saved_offline.dart';
import '../../../api/api_service.dart';
import '../../../models/login_model.dart';
import '../../../screen/Customs/responsive.dart';
import '../../../screen/Home/Home.dart';
import '../../components/contants.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({required this.lat, required this.log, Key? key, required thi})
      : super(key: key);
  double? lat;
  double? log;

  @override
  Widget build(BuildContext context) {
    return Login();
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool chec_internet = false;
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      if (result != ConnectivityResult.none) {
        setState(() {
          chec_internet = true;
        });
      } else {
        setState(() {
          chec_internet = false;
          final snackBar = SnackBar(
            backgroundColor: Color.fromARGB(255, 245, 245, 245),
            padding: EdgeInsets.all(0),
            content: GFCard(
              padding: EdgeInsets.all(0),
              boxFit: BoxFit.cover,
              title: GFListTile(
                avatar: Icon(
                  Icons.download_for_offline_outlined,
                  color: Colors.blue,
                  size: 50,
                  shadows: const [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 5,
                      offset: Offset(1, 0.5),
                    )
                  ],
                ),
                title: Text('You\'re offline'),
                subTitle: Text('Watch saved data in your Library'),
              ),
              content: Text("All data had save!"),
              buttonBar: GFButtonBar(
                children: <Widget>[
                  GFButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => data_verbal_saved(),),);
                    },
                    color: GFColors.SUCCESS,
                    text: 'Go to watch',
                  ),
                  GFButton(
                    onPressed: () {},
                    color: GFColors.DANGER,
                    text: '\tCancel\t',
                  ),
                ],
              ),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        break;
      default:
        setState(() {
          final snackBar = SnackBar(
            backgroundColor: Colors.black12,
            content: const Text('Offline'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        break;
    }
  }

  bool _isObscure = true;
  late LoginRequestModel requestModel;
  bool isApiCallProcess = false;
  late int id = 0;
  late String username = "";
  late String first_name = "";
  late String last_name = "";
  late String email = "";
  late String gender = "";
  late String from = "";
  late String tel = "";
  static List<PeopleModel> list = [];
  static bool status = false;
  PeopleModel? peopleModel;
  late TextEditingController Email;
  late TextEditingController Password;
  selectPeople() async {
    list = await PeopleController().selectPeople();
    if (list.isEmpty) {
      setState(() {
        status = false;
      });
    } else {
      setState(() {
        final int i = list.length - 1;
        status = true;
        Email = TextEditingController(text: list[i].name);
        Password = TextEditingController(text: list[i].password);
      });
    }
  }

  @override
  void initState() {
    selectPeople();
    status;
    list;
    super.initState();
    requestModel = LoginRequestModel(email: "", password: "");
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kwhite_new,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          // 'assets/images/KFA-Logo.png',
          'assets/images/KFA-Logo.png',
          height: 120,
          width: 150,
        ),
        toolbarHeight: 100,
      ),
      backgroundColor: kwhite_new,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: kwhite,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Responsive(
            mobile: login(context),
            tablet: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 500,
                        child: login(context),
                      ),
                    ],
                  ),
                )
              ],
            ),
            desktop: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 500,
                        child: login(context),
                      ),
                    ],
                  ),
                )
              ],
            ),
            phone: login(context),
          ),
        ),
      ),
    );
  }

  Widget _uiSteup(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kwhite_new,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          // 'assets/images/KFA-Logo.png',
          'assets/images/KFA-Logo.png',
          height: 120,
          width: 150,
        ),
        toolbarHeight: 100,
      ),
      backgroundColor: kwhite_new,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: kwhite,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Responsive(
            mobile: login(context),
            tablet: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 500,
                        child: login(context),
                      ),
                    ],
                  ),
                )
              ],
            ),
            desktop: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 500,
                        child: login(context),
                      ),
                    ],
                  ),
                )
              ],
            ),
            phone: login(context),
          ),
        ),
      ),
    );
  }

  Padding login(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              'Welcome to KFA Mobile',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: kwhite_new,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 30.0,
            ),
            ((status == false) ? input(context) : Output(context)),

            SizedBox(
              height: 10.0,
            ),
            // ignore: deprecated_member_use
            SizedBox(
              width: 150,
              child: AnimatedButton(
                text: 'Login',
                color: kwhite_new,
                pressEvent: () {
                  if (chec_internet) {
                    if (validateAndSave()) {
                      setState(() {
                        // final player = AudioPlayer();
                        // player.play(AssetSource('nor.mp3'));
                        isApiCallProcess = true;
                      });
                      final APIservice apIservice = APIservice();
                      apIservice.login(requestModel).then((value) {
                        Load(value.token);
                        setState(() {
                          isApiCallProcess = false;
                        });
                        if (value.message == "Login Successfully!") {
                          PeopleController().deletePeople(0);
                          final people = PeopleModel(
                            id: 0,
                            name: requestModel.email,
                            password: requestModel.password,
                          );
                          PeopleController().insertPeople(people);
                          AwesomeDialog(
                            btnOkOnPress: () {},
                            context: context,
                            animType: AnimType.leftSlide,
                            headerAnimationLoop: false,
                            dialogType: DialogType.success,
                            showCloseIcon: false,
                            title: value.message,
                            autoHide: Duration(seconds: 3),
                            onDismissCallback: (type) {
                              // debugPrint('Dialog Dissmiss from callback $type');
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage1(
                                      log: 0,
                                      lat: 0,
                                      user: username,
                                      email: email,
                                      first_name: first_name,
                                      last_name: last_name,
                                      gender: gender,
                                      from: from,
                                      tel: tel,
                                      id: id.toString(),
                                    ),
                                  ),);
                            },
                          ).show();
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            headerAnimationLoop: false,
                            title: 'Error',
                            desc: value.message,
                            btnOkOnPress: () {},
                            btnOkIcon: Icons.cancel,
                            btnOkColor: Colors.red,
                          ).show();
                          print(value.message);
                        }
                      });
                      print(requestModel.toJson());
                    }
                  }
                  initConnectivity();
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text.rich(TextSpan(children: [
              TextSpan(
                text: "Don't have any account? ",
                style: TextStyle(fontSize: 16.0, color: kTextLightColor),
              ),
              TextSpan(
                text: 'Register',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Register()),);
                  },
                style: TextStyle(
                  fontSize: 16.0,
                  color: kImageColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],),),
          ],
        ),
      ),
    );
  }

  void Load(String token) async {
    setState(() {});
    final rs = await http.get(
      Uri.parse(
          'https://www.oneclickonedollar.com/laravel_kfa_2023/public/api/user',),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (rs.statusCode == 200) {
      final jsonData = jsonDecode(rs.body);
      setState(() {
        id = jsonData["id"];
        username = jsonData['username'];
        first_name = jsonData['first_name'];
        last_name = jsonData['last_name'];
        email = jsonData['email'];
        gender = jsonData['gender'];
        from = jsonData['known_from'];
        tel = jsonData['tel_num'];
      });
      print(id.toString());
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget input(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: TextFormField(
            // controller: Email,
            onSaved: (input) => requestModel.email = input!,
            decoration: InputDecoration(
              fillColor: Color.fromARGB(255, 255, 255, 255),
              filled: true,
              labelText: 'Email',
              prefixIcon: Icon(
                Icons.email,
                color: kImageColor,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 126, 250, 1), width: 2.0,),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Color.fromRGBO(0, 126, 250, 1),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Color.fromARGB(255, 249, 0, 0),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Color.fromARGB(255, 249, 0, 0),
                ),
                //  borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (input) {
              if (input == null || input.isEmpty) {
                return 'require *';
              }
              return null;
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          //   height: 55,
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: TextFormField(
            // controller: password,
            // initialValue: "list[0].password",
            onSaved: (input) => requestModel.password = input!,
            obscureText: _isObscure,
            decoration: InputDecoration(
              fillColor: kwhite,
              filled: true,
              labelText: 'Enter password',
              prefixIcon: Icon(
                Icons.key,
                color: kImageColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  color: kImageColor,
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: kPrimaryColor, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: kerror,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: kerror,
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
            validator: (input) {
              if (input == null || input.isEmpty) {
                return 'require *';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget Output(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: TextFormField(
            controller: Email,
            onSaved: (input) => requestModel.email = input!,
            decoration: InputDecoration(
              fillColor: Color.fromARGB(255, 255, 255, 255),
              filled: true,
              labelText: 'Email',
              prefixIcon: Icon(
                Icons.email,
                color: kImageColor,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 126, 250, 1), width: 2.0,),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Color.fromRGBO(0, 126, 250, 1),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Color.fromARGB(255, 249, 0, 0),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Color.fromARGB(255, 249, 0, 0),
                ),
                //  borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (input) {
              if (input == null || input.isEmpty) {
                return 'require *';
              }
              return null;
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          //   height: 55,
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: TextFormField(
            controller: Password,
            // initialValue: "list[0].password",
            onSaved: (input) => requestModel.password = input!,
            obscureText: _isObscure,
            decoration: InputDecoration(
              fillColor: kwhite,
              filled: true,
              labelText: 'Enter password',
              prefixIcon: Icon(
                Icons.key,
                color: kImageColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  color: kImageColor,
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: kPrimaryColor, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: kerror,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: kerror,
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
            validator: (input) {
              if (input == null || input.isEmpty) {
                return 'require *';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
