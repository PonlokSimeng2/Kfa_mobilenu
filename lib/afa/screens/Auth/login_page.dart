import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kfa_mobilenu/afa/screens/Auth/register.dart';
import 'package:kfa_mobilenu/helper/build_context_helper.dart';
import 'package:kfa_mobilenu/providers/auth_provider.dart';
import 'package:kfa_mobilenu/providers/cache_provider.dart';
import '../../../Memory_local/show_data_saved_offline.dart';
import '../../../screen/Customs/responsive.dart';
import '../../../screen/Home/Home.dart';
import '../../components/contants.dart';

const _cacheEmailKey = "cached-email-key";
const _cachePasswordKey = "cached-password-key";

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({required this.lat, required this.log, Key? key, required thi})
      : super(key: key);
  double? lat;
  double? log;

  @override
  Widget build(BuildContext context) {
    return const Login();
  }
}

class Login extends ConsumerStatefulWidget {
  const Login({Key? key, this.openAsPage = false}) : super(key: key);

  final bool openAsPage;

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
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
            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
            padding: const EdgeInsets.all(0),
            content: GFCard(
              padding: const EdgeInsets.all(0),
              boxFit: BoxFit.cover,
              title: const GFListTile(
                avatar: Icon(
                  Icons.download_for_offline_outlined,
                  color: Colors.blue,
                  size: 50,
                  shadows: [
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
              content: const Text("All data had save!"),
              buttonBar: GFButtonBar(
                children: <Widget>[
                  GFButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const data_verbal_saved(),
                        ),
                      );
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
          final snackBar = const SnackBar(
            backgroundColor: Colors.black12,
            content: Text('Offline'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        break;
    }
  }

  bool _isObscure = true;
  bool status = false;
  late TextEditingController emailCtr;
  late TextEditingController passwordCtr;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    final cache = ref.read(sharePrefProvider);
    final cachedEmail = cache.getString(_cacheEmailKey);
    final cachedPassword = cache.getString(_cachePasswordKey);
    emailCtr = TextEditingController(text: cachedEmail);
    passwordCtr = TextEditingController(text: cachedPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kwhite_new,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/KFA-Logo.png',
          height: 120,
          width: 150,
        ),
        toolbarHeight: 100,
      ),
      backgroundColor: kwhite_new,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
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
        decoration: const BoxDecoration(
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
            const SizedBox(
              height: 30.0,
            ),
            ((status == false) ? input(context) : output(context)),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: 150,
              child: AnimatedButton(
                text: 'Login',
                color: kwhite_new,
                pressEvent: () async {
                  if (chec_internet) {
                    _formKey.currentState?.save();
                    if (!_formKey.currentState!.validate()) return;

                    final close = BotToast.showLoading();
                    final provider = ref.read(authProvider.notifier);
                    final errorOrNull = await provider.login(
                      email: emailCtr.text.trim(),
                      password: passwordCtr.text.trim(),
                    );
                    close();

                    if (errorOrNull == null && context.mounted) {
                      // cache success login
                      final cache = ref.read(sharePrefProvider);
                      cache.setString(
                        _cacheEmailKey,
                        emailCtr.text.trim(),
                      );
                      cache.setString(
                        _cachePasswordKey,
                        passwordCtr.text.trim(),
                      );

                      if (widget.openAsPage) {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.leftSlide,
                          headerAnimationLoop: false,
                          dialogType: DialogType.success,
                          dismissOnTouchOutside: true,
                          showCloseIcon: false,
                          title: "Login Successfully!",
                          autoHide: const Duration(seconds: 3),
                          onDismissCallback: (type) {
                            context.pushReplace((context) => HomePage1());
                          },
                        ).show();
                      } else {
                        BotToast.showText(text: "Login Successfully!");
                      }
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        headerAnimationLoop: false,
                        title: 'Error',
                        desc: errorOrNull,
                        btnOkIcon: Icons.cancel,
                        btnOkColor: Colors.red,
                      ).show();
                    }
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Don't have any account? ",
                    style: TextStyle(fontSize: 16.0, color: kTextLightColor),
                  ),
                  TextSpan(
                    text: 'Register',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: kImageColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget input(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: TextFormField(
            controller: emailCtr,
            decoration: InputDecoration(
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              filled: true,
              labelText: 'Email',
              prefixIcon: const Icon(
                Icons.email,
                color: kImageColor,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromRGBO(0, 126, 250, 1),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Color.fromRGBO(0, 126, 250, 1),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Color.fromARGB(255, 249, 0, 0),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Color.fromARGB(255, 249, 0, 0),
                ),
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
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: TextFormField(
            controller: passwordCtr,
            obscureText: _isObscure,
            decoration: InputDecoration(
              fillColor: kwhite,
              filled: true,
              labelText: 'Enter password',
              prefixIcon: const Icon(
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
                borderSide: const BorderSide(
                  width: 1,
                  color: kerror,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                  color: kerror,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
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

  Widget output(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: TextFormField(
            controller: emailCtr,
            decoration: InputDecoration(
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              filled: true,
              labelText: 'Email',
              prefixIcon: const Icon(
                Icons.email,
                color: kImageColor,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromRGBO(0, 126, 250, 1),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Color.fromRGBO(0, 126, 250, 1),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Color.fromARGB(255, 249, 0, 0),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedErrorBorder: const OutlineInputBorder(
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
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: TextFormField(
            controller: passwordCtr,
            obscureText: _isObscure,
            decoration: InputDecoration(
              fillColor: kwhite,
              filled: true,
              labelText: 'Enter password',
              prefixIcon: const Icon(
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
                borderSide: const BorderSide(
                  width: 1,
                  color: kerror,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                  color: kerror,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
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
