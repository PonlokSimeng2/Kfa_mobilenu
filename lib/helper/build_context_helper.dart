import 'package:flutter/material.dart';

extension BuildContextHelper on BuildContext {
  Future<dynamic> push(Widget Function(BuildContext context) screen) {
    return Navigator.push(this, MaterialPageRoute(builder: screen));
  }

  Future<dynamic> pushReplace(Widget Function(BuildContext context) screen) {
    Navigator.popUntil(this, (route) => route.isFirst);
    return Navigator.pushReplacement(this, MaterialPageRoute(builder: screen));
  }
}
