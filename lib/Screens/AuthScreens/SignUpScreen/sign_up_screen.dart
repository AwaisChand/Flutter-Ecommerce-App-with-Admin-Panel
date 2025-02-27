import 'package:ecommerce_app/Common/AppAssets/app_assets.dart';
import 'package:ecommerce_app/Common/AppButton/app_button.dart';
import 'package:ecommerce_app/Common/AppRoutes/app_routes.dart';
import 'package:ecommerce_app/Common/AppTextField/app_text_field.dart';
import 'package:ecommerce_app/Common/AppTextStyles/app_text_styles.dart';
import 'package:ecommerce_app/Common/utils.dart';
import 'package:ecommerce_app/Provider/UserPovider/user_provider.dart';
import 'package:ecommerce_app/Screens/AuthScreens/LoginScreen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
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
                      'Sign Up',
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
                    'Name',
                    style: AppTextStyles.semiBoldTextStyle,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  AppTextField(
                      controller: nameController,
                      textInputType: TextInputType.name,
                      hintText: 'Name'),
                  const SizedBox(
                    height: 10.0,
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
                  const SizedBox(
                    height: 35.0,
                  ),
                  AppButton(
                      isLoading: userProvider.isLoading,
                      onPressed: () {
                        if (nameController.text.isEmpty) {
                          Utils.toastErrorMsg(
                              context, 'Please enter your name!');
                        } else if (emailController.text.isEmpty) {
                          Utils.toastErrorMsg(
                              context, 'Please enter your email!');
                        } else if (passwordController.text.isEmpty) {
                          Utils.toastErrorMsg(
                              context, 'Please enter your password!');
                        } else if (passwordController.text.length < 6) {
                          Utils.toastErrorMsg(
                              context, 'Please must be 6 character long!');
                        } else {
                          userProvider.signUp(context, nameController.text,
                              emailController.text, passwordController.text);
                        }
                      },
                      buttonText: 'SIGN UP'),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: AppTextStyles.lightTextStyle,
                      ),
                      GestureDetector(
                        onTap: (){
                          AppRoutes.moveToNext(context, const LoginScreen());
                        },
                        child: const Text(
                          "Sign In ",
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
