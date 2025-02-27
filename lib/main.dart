import 'package:ecommerce_app/Common/utils.dart';
import 'package:ecommerce_app/Provider/provider_classes.dart';
import 'package:ecommerce_app/Screens/AdminPanelScreens/HomeAdminScreen/home_admin_screen.dart';
import 'package:ecommerce_app/Screens/BottomNavigationBar/bottom_navigation_bar_screen.dart';
import 'package:ecommerce_app/Screens/OnBoardingScreen/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import 'Screens/AdminPanelScreens/AddProductItemsScreen/add_product_items_screen.dart';
import 'Screens/AdminPanelScreens/AdminLoginScreen/admin_login_screen.dart';
import 'Screens/AdminPanelScreens/AllOrders/all_orders.dart';
import 'Screens/AuthScreens/LoginScreen/login_screen.dart';
import 'Screens/BottomNavigationBar/BottomNavBarScreens/HomeScreen/home_screen.dart';
import 'Screens/ProductDetailScreen/product_detail_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey = Utils.publishKey;
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [...providerClasses],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AdminLoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
