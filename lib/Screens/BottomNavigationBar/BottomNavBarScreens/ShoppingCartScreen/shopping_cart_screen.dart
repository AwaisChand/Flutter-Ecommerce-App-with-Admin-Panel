import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Common/AppTextStyles/app_text_styles.dart';
import 'package:ecommerce_app/Service/FiresoreMethods/firestore_methods.dart';
import 'package:ecommerce_app/Service/SharedPrefMethods/shared_pref_methods.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  String? userEmail;
  Stream? ordersStream;

  getEmailFromSharedPref() async {
    userEmail = await SharedPrefMethods.getUserEmail();
    setState(() {});
  }

  getOrdersData() async {
    await getEmailFromSharedPref();
    ordersStream = await FirestoreMethods().getOrders(userEmail ?? '');

    print("User Email: $userEmail"); // Debugging
    ordersStream!.listen((event) {
      print("Orders Data: ${event.docs.length}"); // Debugging
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOrdersData();
  }

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
              child: Text("Current Orders",
                  style: AppTextStyles.boldTextStyle.copyWith(fontSize: 20)),
            ),
          ),
          Expanded(child: getAllOrders())
        ],
      ),
    );
  }

  Widget getAllOrders() {
    return StreamBuilder(
      stream: ordersStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
              child: Text("Your cart is empty",
                  style: AppTextStyles.semiBoldTextStyle));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];

                  String imageUrl = documentSnapshot['productImage'] ?? '';
                  String title = documentSnapshot['productName'] ?? 'Unknown';
                  String price = documentSnapshot['productPrice'];
                  String status = documentSnapshot['orderStatus'];

                  return Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 15),
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 130,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    _buildShimmerImage(),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.person,
                                  size: 120,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _containerWidget(title),
                                const SizedBox(height: 10),
                                _containerWidget("\$$price"),
                                const SizedBox(height: 10),
                                _containerWidget("Status: $status"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _containerWidget(String text) {
    return Container(
      height: 30,
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Center(
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.semiBoldTextStyle.copyWith(fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildShimmerImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 130,
        width: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
