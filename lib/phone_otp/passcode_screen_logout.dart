import 'dart:async';
import 'package:flutter/material.dart';
import 'package:passcode_screen/passcode_screen.dart';
import '../Memory_local/sqlitedatabase.dart';

class MyPasscodeHomePageLogOut extends StatefulWidget {
  const MyPasscodeHomePageLogOut({super.key});

  @override
  State<MyPasscodeHomePageLogOut> createState() =>
      _MyPasscodeHomePageLogOutState();
}

DatabaseHelper _databaseHelper = DatabaseHelper();
TextEditingController _passcodeController = TextEditingController();

class _MyPasscodeHomePageLogOutState extends State<MyPasscodeHomePageLogOut> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  static bool c = false;
  static int number = 0;
  static var password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasscodeScreen(
        passwordDigits: 4,
        cancelButton: const Text('Cancel'),
        deleteButton: const Text('Delete'),
        passwordEnteredCallback: (Val) async {
          setState(() {
            password = int.parse(Val);

            if (password == 2345) {
              c = true;
              number = 4;
              //Navigator.of(context)
              // .push(MaterialPageRoute(builder: (context) => Body()));
            } else {
              setState(() {
                number = 0;
                c = false;
                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
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
                        title: Text("Error Password"),
                        content: Text("Please try again later."),
                      );
                    },);
              });
            }
          });
        },
        shouldTriggerVerification: (_verificationNotifier).stream,
        title: const Text(""),
      ),
    );
  }
}
