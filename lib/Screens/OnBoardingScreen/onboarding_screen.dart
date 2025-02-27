import 'package:ecommerce_app/Common/AppAssets/app_assets.dart';
import 'package:ecommerce_app/Common/AppRoutes/app_routes.dart';
import 'package:ecommerce_app/Provider/UserPovider/user_provider.dart';
import 'package:ecommerce_app/Screens/AuthScreens/SignUpScreen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<UserProvider>();
      provider.checkUserLogin(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 235, 231),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40.0,
          ),
          const Image(
            image: AssetImage(AppAssets.headPhoneImg),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 15),
            child: Text(
              "Explore\nThe Best\nProducts",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.only(right: 20.0, top: 15),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: (){
                    AppRoutes.moveToNext(context, const SignUpScreen());
                  },
                  child: const Center(
                      child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
