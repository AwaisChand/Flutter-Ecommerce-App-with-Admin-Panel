import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {super.key,
      required this.controller,
      required this.textInputType,
      required this.hintText});

  final TextEditingController controller;
  final TextInputType textInputType;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: TextField(
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            filled: true,
            fillColor: Colors.cyan.shade100),
      ),
    );
  }
}
