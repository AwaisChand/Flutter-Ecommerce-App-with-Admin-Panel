import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class Utils {
  static void toastSuccessMsg(BuildContext context, String msg) {
    showToast(msg,
        context: context,
        animation: StyledToastAnimation.fade,
        reverseAnimation: StyledToastAnimation.fade,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        textStyle: const TextStyle(color: Colors.white),
        borderRadius: BorderRadius.circular(15.0));
  }

  static void toastErrorMsg(BuildContext context, String msg) {
    showToast(msg,
        context: context,
        animation: StyledToastAnimation.fade,
        reverseAnimation: StyledToastAnimation.fade,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        textStyle: const TextStyle(color: Colors.white),
        borderRadius: BorderRadius.circular(15.0));
  }


  // Stripe Publish Key

  static String publishKey =
      "pk_test_51Pp7EDP66sPruCkTDpiNPsndghACMtIbQ3g5FTezgZ3QTBgjkPiW1OGG6SNhXJ2dZIGTUglHKHtvlgvNJuE9KTUp006jEvrNvz";

  // Stripe Secret Key

  static String secretKey =
      "sk_test_51Pp7EDP66sPruCkTylFqSwfzLuYarJeJw4l4AtXKbtjAWons7bmFq3AYPTqqDX8VxWRXmoMJtIflRs4j2lkcq2KC00zeqY5nfA";
}
