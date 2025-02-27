import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle boldTextStyle = const TextStyle(
      fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.black);

  static TextStyle lightTextStyle = const TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.black54);

  static TextStyle semiBoldTextStyle = const TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black);

  static TextStyle buttonTextStyle = const TextStyle(
      color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500);

  static TextStyle labelTextStyle =
      const TextStyle(fontWeight: FontWeight.w600, fontSize: 16);

  static TextStyle adminHintTextStyle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.purple,
  );

  static TextStyle loginTextStyle = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18);
}
