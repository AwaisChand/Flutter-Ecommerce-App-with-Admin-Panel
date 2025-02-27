import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecommerce_app/Screens/BottomNavigationBar/BottomNavBarScreens/ShoppingCartScreen/shopping_cart_screen.dart';
import 'package:flutter/material.dart';

import 'BottomNavBarScreens/HomeScreen/home_screen.dart';
import 'BottomNavBarScreens/ProfileScreen/profile_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int currentTabIndex = 0;

  List<Widget> pages = [
    const HomeScreen(),
    const ShoppingCartScreen(),
    const ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        backgroundColor: const Color(0xFFf2f2f2),
        color: Colors.black,
        height: 60,
        animationDuration: const
        Duration(milliseconds: 500),
        items: const [
          Icon(
            Icons.home_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.person_outline,
            color: Colors.white,
          )
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
