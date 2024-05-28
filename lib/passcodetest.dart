import 'package:flutter/material.dart';
import 'package:kfa_mobilenu/screen/Home/Body.dart';

class MyAppPasscode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PasscodeScreentest(),
    );
  }
}

class PasscodeScreentest extends StatefulWidget {
  @override
  _PasscodeScreentestState createState() => _PasscodeScreentestState();
}

class _PasscodeScreentestState extends State<PasscodeScreentest> {
  String passcode = "1234"; // Example passcode
  int durationInMinutes = 5; // Duration for passcode validity
  TextEditingController passcodeController = TextEditingController();
  bool isValid = true;

  void validatePasscode(String input) {
    setState(() {
      isValid = input == passcode;
    });
    if (isValid) {
      // If passcode is valid, do something like navigate to home screen
      // Navigator.pushReplacement(
      // context, MaterialPageRoute(builder: (context) => Body()));
      //print("Passcode is correct!");
    } else {
      // If passcode is invalid, show error message or do something else
      print("Passcode is incorrect!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passcode Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Enter Passcode:',
              style: TextStyle(fontSize: 18.0),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: TextField(
                controller: passcodeController,
                keyboardType: TextInputType.number,
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter passcode',
                  errorText: isValid ? null : 'Invalid passcode',
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                validatePasscode(passcodeController.text);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
