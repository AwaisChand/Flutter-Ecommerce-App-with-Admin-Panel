import 'package:ecommerce_app/Common/AppRoutes/app_routes.dart';
import 'package:ecommerce_app/Screens/AdminPanelScreens/AddProductItemsScreen/add_product_items_screen.dart';
import 'package:ecommerce_app/Screens/AdminPanelScreens/AllOrders/all_orders.dart';
import 'package:flutter/material.dart';

import '../../../Common/AppTextStyles/app_text_styles.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf2f2f2),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 50),
            child: Center(
              child: Text("Home Admin",
                  style: AppTextStyles.boldTextStyle.copyWith(fontSize: 20)),
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          _containerWidget(Icons.add, 'Add Product', () {
            AppRoutes.moveToNext(context, const AddProductItemsScreen());
          }),
          const SizedBox(
            height: 50.0,
          ),
          _containerWidget(Icons.add, 'All Orders', () {
            AppRoutes.moveToNext(context, const AllOrders());
          })
        ],
      ),
    );
  }

  Widget _containerWidget(IconData icon, String text, VoidCallback onTapped) {
    return GestureDetector(
      onTap: onTapped,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 30,
                ),
                const SizedBox(width: 20),
                Text(
                  text,
                  style: AppTextStyles.boldTextStyle,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
