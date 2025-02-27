import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Service/FiresoreMethods/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Common/AppTextStyles/app_text_styles.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  Stream? allOrdersStream;

  getOrders() async {
    allOrdersStream = await FirestoreMethods().getAllOrders();
    allOrdersStream!.listen((event) {
      print("Orders Data: ${event.docs.length}"); // Debugging
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOrders();
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
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios_new_outlined)),
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("All Orders",
                        style:
                            AppTextStyles.boldTextStyle.copyWith(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: getAllOrders())
        ],
      ),
    );
  }

  Widget getAllOrders() {
    return StreamBuilder(
      stream: allOrdersStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
              child:
                  Text("No Order Yet", style: AppTextStyles.semiBoldTextStyle));
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

                  String imageUrl = documentSnapshot['userImage'] ?? '';
                  String title = documentSnapshot['productName'] ?? 'Unknown';
                  String price = documentSnapshot['productPrice'];
                  String email = documentSnapshot['userEmail'];
                  String name = documentSnapshot['userName'] ?? 'Unknown';

                  return Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        padding:
                            const EdgeInsets.only(top: 10, right: 10, left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _rowWidget("Name:", name),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                _rowWidget("Email:", email),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                _rowWidget("Product:", title),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                _rowWidget("Price:", '\$$price'),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                MaterialButton(
                                  color: const Color(0xFFfd6f3c),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  onPressed: () async {
                                    await FirestoreMethods()
                                        .updateStatus(documentSnapshot.id);
                                    setState(() {});
                                  },
                                  child: Text(
                                    'Done',
                                    style: AppTextStyles.semiBoldTextStyle
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
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

  Widget _rowWidget(String text1, text2) {
    return Row(
      children: [
        Text(
          text1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.semiBoldTextStyle.copyWith(fontSize: 13),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          text2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.lightTextStyle.copyWith(fontSize: 14),
        ),
      ],
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
