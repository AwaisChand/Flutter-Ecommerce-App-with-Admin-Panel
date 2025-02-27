import 'package:flutter/material.dart';

class AppRoutes {
  static moveToNext(BuildContext context, Widget route) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => route));
  }

  static moveNextAndRemoveUntil(BuildContext context, Widget route) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => route),
          (Route<dynamic> route) =>
      false, // Set your predicate based on your requirements
    );
  }

  static moveToBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
