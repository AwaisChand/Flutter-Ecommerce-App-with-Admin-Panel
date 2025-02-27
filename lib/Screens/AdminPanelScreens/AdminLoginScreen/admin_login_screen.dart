import 'package:ecommerce_app/Common/AppAssets/app_assets.dart';
import 'package:ecommerce_app/Common/AppButton/app_button.dart';
import 'package:ecommerce_app/Common/AppRoutes/app_routes.dart';
import 'package:ecommerce_app/Common/AppTextField/app_text_field.dart';
import 'package:ecommerce_app/Common/AppTextStyles/app_text_styles.dart';
import 'package:ecommerce_app/Common/utils.dart';
import 'package:ecommerce_app/Provider/UserPovider/user_provider.dart';
import 'package:ecommerce_app/Screens/AdminPanelScreens/HomeAdminScreen/home_admin_screen.dart';
import 'package:ecommerce_app/Screens/BottomNavigationBar/bottom_navigation_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController adminNameController = TextEditingController();
  final TextEditingController adminPasswordController = TextEditingController();
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
                      'Admin Panel',
                      style: AppTextStyles.semiBoldTextStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Username',
                    style: AppTextStyles.semiBoldTextStyle,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  AppTextField(
                      controller: adminNameController,
                      textInputType: TextInputType.name,
                      hintText: 'Username'),
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
                      controller: adminPasswordController,
                      textInputType: TextInputType.visiblePassword,
                      hintText: 'Password'),
                  const SizedBox(
                    height: 35.0,
                  ),
                  AppButton(
                      isLoading: userProvider.isLoading,
                      onPressed: () {
                        if (adminNameController.text.isEmpty) {
                          Utils.toastErrorMsg(context, 'Please enter username');
                        } else if (adminPasswordController.text.isEmpty) {
                          Utils.toastErrorMsg(context, 'Please enter password');
                        } else if (adminPasswordController.text.length < 6) {
                          Utils.toastErrorMsg(
                              context, 'Password mus 6 character long!');
                        } else {
                          userProvider.adminLogin(
                              context,
                              adminNameController.text,
                              adminPasswordController.text);
                          AppRoutes.moveToNext(
                              context, const HomeAdminScreen());
                        }
                      },
                      buttonText: 'LOGIN'),
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
