import 'package:ecommerce_app/Common/AppTextStyles/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {super.key,
      required this.onPressed,
      this.isLoading = false,
      required this.buttonText});
  final VoidCallback onPressed;
  final bool? isLoading;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        height: 50,
        color: const Color(0xFFfd6f3c),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: onPressed,
        child: isLoading!
            ? const Center(
                child: SizedBox(
                  height: 25.0,
                  width: 25.0,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 4,
                  ),
                ),
              )
            : Text(
                buttonText,
                style: AppTextStyles.buttonTextStyle,
              ),
      ),
    );
  }
}
