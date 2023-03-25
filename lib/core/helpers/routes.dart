import 'package:flutter/material.dart';

class CustomNavigator {
  static pushScreen({
    required BuildContext context,
    required Widget widget,
  }) {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => widget));
  }

  static popScreen({required BuildContext context}) {
    Navigator.pop(context);
  }

  static pushScreenReplacement({
    required BuildContext context,
    required Widget widget,
  }) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => widget));
  }

  static cleanAndPush({
    required BuildContext context,
    required Widget widget,
  }) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => widget), (route) => false);
  }
}
