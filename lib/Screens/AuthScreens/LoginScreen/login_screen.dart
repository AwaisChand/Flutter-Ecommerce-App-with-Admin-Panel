import 'package:ecommerce_app/Common/AppAssets/app_assets.dart';
import 'package:ecommerce_app/Common/AppButton/app_button.dart';
import 'package:ecommerce_app/Common/AppRoutes/app_routes.dart';
import 'package:ecommerce_app/Common/AppTextField/app_text_field.dart';
import 'package:ecommerce_app/Common/AppTextStyles/app_text_styles.dart';
import 'package:ecommerce_app/Common/utils.dart';
import 'package:ecommerce_app/Provider/UserPovider/user_provider.dart';
import 'package:ecommerce_app/Screens/AuthScreens/SignUpScreen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Image(image: AssetImage(AppAssets.loginImg)),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Center(
                    child: Text(
                      'Sign In',
                      style: AppTextStyles.semiBoldTextStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Please enter the details below to\ncontinue.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.lightTextStyle,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Email',
                    style: AppTextStyles.semiBoldTextStyle,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  AppTextField(
                      controller: emailController,
                      textInputType: TextInputType.emailAddress,
                      hintText: 'Email'),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Password',
                    style: AppTextStyles.semiBoldTextStyle,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  AppTextField(
                      controller: passwordController,
                      textInputType: TextInputType.visiblePassword,
                      hintText: 'Password'),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFfd6f3c),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35.0,
                  ),
                  AppButton(
                      isLoading: userProvider.isLoading,
                      onPressed: () {
                        if (emailController.text.isEmpty) {
                          Utils.toastErrorMsg(
                              context, 'Please enter your email!');
                        } else if (passwordController.text.isEmpty) {
                          Utils.toastErrorMsg(
                              context, 'Please enter your password!');
                        } else if (passwordController.text.length < 6) {
                          Utils.toastErrorMsg(
                              context, 'Password must be 6 character long!');
                        } else {
                          userProvider.login(emailController.text,
                              passwordController.text, context);
                        }
                      },
                      buttonText: 'LOGIN'),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTextStyles.lightTextStyle,
                      ),
                      InkWell(
                        onTap: () {
                          AppRoutes.moveToNext(context, const SignUpScreen());
                        },
                        child: const Text(
                          "Sign Up ",
                          style: TextStyle(
                              color: Color(0xFFfd6f3c),
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
