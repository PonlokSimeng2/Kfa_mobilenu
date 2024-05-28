import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kfa_mobilenu/phone_otp/passcode_screen_logout.dart';
import 'package:passcode_screen/passcode_screen.dart';
import '../Memory_local/sqlitedatabase.dart';

class MyPasscodeHomePage extends StatefulWidget {
  const MyPasscodeHomePage({super.key});

  @override
  State<MyPasscodeHomePage> createState() => _MyPasscodeHomePageState();
}

final StreamController<bool> _verificationNotifier =
    StreamController<bool>.broadcast();
DatabaseHelper databaseHelper = DatabaseHelper();
TextEditingController _passcodeController = TextEditingController();

class _MyPasscodeHomePageState extends State<MyPasscodeHomePage> {
  static var password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        onPressed: () {
          _showPasscodeSetup(context);
        },
        child: Text('Set Passcode'),
      ),
    )
        // body: PasscodeScreen(
        //   passwordDigits: 4,
        //   cancelButton: const Text('Cancel'),
        //   deleteButton: const Text('Delete'),
        //   bottomWidget: TextField(
        //     controller: _passcodeController,
        //     keyboardType: TextInputType.number,
        //     maxLength: 4,
        //     decoration: InputDecoration(
        //       labelText: 'Enter Passcode',
        //     ),
        //   ),
        //   passwordEnteredCallback: (Val) {
        //     setState(() {
        //       password = int.parse(Val);
        //       if (password ==
        //           databaseHelper.setPasscode(_passcodeController.toString())) {
        //         Navigator.of(context).push(MaterialPageRoute(
        //             builder: (context) => const MyPasscodeHomePageLogOut()));
        //       } else {
        //         setState(() {
        //           Navigator.of(context).pop();
        //           showDialog(
        //               context: context,
        //               builder: (context) {
        //                 return const AlertDialog(
        //                   actions: [
        //                     // FlatButton(
        //                     //     textColor: Colors.white,
        //                     //     color: Colors.red,
        //                     //     onPressed: () {
        //                     //       Navigator.pop(context);
        //                     //     },
        //                     //     child: Text("Okay!"))
        //                   ],
        //                   title: Text("Error Password"),
        //                   content: Text("Please try again later."),
        //                 );
        //               });
        //         });
        //       }
        //     });
        //   },
        //   shouldTriggerVerification: (_verificationNotifier).stream,
        //   title: const Text(
        //     "Set Passcode",
        //     style: TextStyle(
        //         fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
        //   ),
        // ),
        );
  }
}

_showPasscodeSetup(BuildContext context) async {
  String passcode = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PasscodeScreen(
        title: Text('Set Passcode'),
        passwordEnteredCallback: (String enteredPasscode) {
          // For simplicity, we'll just accept any passcode entered by the user
          // In a real-world scenario, you should add your own validation logic here
          print('User entered passcode: $enteredPasscode');
        },
        cancelButton: Text('Cancel'),
        deleteButton: Text('Delete'),
        shouldTriggerVerification: (_verificationNotifier).stream,
        //shouldTriggerVerification: false, // No need to verify the passcode
      ),
    ),
  );

  // // Handle the retrieved passcode
  // if (passcode != null && passcode.isNotEmpty) {
  //   // Save or process the passcode as needed

  //   print('User set passcode: $passcode');
  // }
  // Handle the retrieved passcode
  if (passcode != null && passcode.isNotEmpty) {
    // Save or process the passcode as needed
    print('User set passcode: $passcode');
    // In a real app, you would save the passcode securely here
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const MyPasscodeHomePageLogOut()));
  }
}
// class PasscodeSetupScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Set Passcode'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             _showPasscodeSetup(context);
//           },
//           child: Text('Set Passcode'),
//         ),
//       ),
//     );
//   }


// }
