import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Common/AppRoutes/app_routes.dart';
import 'package:ecommerce_app/Common/AppTextStyles/app_text_styles.dart';
import 'package:ecommerce_app/Screens/ProductDetailScreen/product_detail_screen.dart';
import 'package:ecommerce_app/Service/FiresoreMethods/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key, required this.category});

  final String category;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  Stream? categoryProductsStream;

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  void fetchCategoryProducts() async {
    categoryProductsStream =
        await FirestoreMethods().getCategory(widget.category);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf2f2f2),
      appBar: AppBar(
        centerTitle: true,
        title:
            Text('Category Products', style: AppTextStyles.semiBoldTextStyle),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(child: getProductsCategory()),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  Widget getProductsCategory() {
    final double height = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: categoryProductsStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return AlignedGridView.count(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: height * 0.03,
              crossAxisSpacing: 4,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                return GestureDetector(
                  onTap: () {
                    AppRoutes.moveToNext(
                        context,
                        ProductDetailScreen(
                            image: documentSnapshot['selectedImage'],
                            title: documentSnapshot['itemName'],
                            description: documentSnapshot['detail'],
                            price: documentSnapshot['price']));
                  },
                  child: Container(
                    height: height * 0.3,
                    width: 140,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(
                              image: NetworkImage(
                                  documentSnapshot['selectedImage']),
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          documentSnapshot['itemName'],
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.semiBoldTextStyle,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          documentSnapshot['detail'],
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.lightTextStyle
                              .copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${documentSnapshot['price']}",
                              style: const TextStyle(
                                  color: Color(0xFFfd6f3c),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Color(0xFFfd6f3c),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                  child: Icon(
                                Icons.add,
                                size: 15,
                                color: Colors.white,
                              )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
                child: Text(
              "No Data Available",
              style: AppTextStyles.semiBoldTextStyle,
            ));
          }
        });
  }
}
