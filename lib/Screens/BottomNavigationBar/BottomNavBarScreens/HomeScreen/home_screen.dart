import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Common/AppAssets/app_assets.dart';
import 'package:ecommerce_app/Common/AppRoutes/app_routes.dart';
import 'package:ecommerce_app/Common/AppTextStyles/app_text_styles.dart';
import 'package:ecommerce_app/Common/AppTexts/app_texts.dart';
import 'package:ecommerce_app/Screens/CategoryProductsScreen/category_products_screen.dart';
import 'package:ecommerce_app/Screens/ProductDetailScreen/product_detail_screen.dart';
import 'package:ecommerce_app/Service/FiresoreMethods/firestore_methods.dart';
import 'package:ecommerce_app/Service/SharedPrefMethods/shared_pref_methods.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'Widgets/category_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List categories = [
    AppAssets.headPhoneIconImg,
    AppAssets.laptopImg,
    AppAssets.watchImg,
    AppAssets.tvImg
  ];

  final List<String> itemCategories = [
    "Headphones",
    "Laptop",
    "Watch",
    "TV",
  ];

  String? name, image;

  getUserDataFromSharedPref() async {
    name = await SharedPrefMethods.getUserName();
    image = await SharedPrefMethods.getUserImage();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserDataFromSharedPref();
  }

  bool search = false;
  var queryResultSet = [];
  var tempSearchStore = [];

  void filterProducts(String value) async {
    if (value.isEmpty) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
        search = false;
      });
      return;
    }

    setState(() {
      search = true;
    });

    // String capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.isEmpty && value.length == 1) {
      await FirestoreMethods().searchProducts(value).then((QuerySnapshot docs) {
        List<dynamic> results = docs.docs.map((doc) => doc.data()).toList();
        debugPrint("Firestore Results: $results");
        setState(() {
          queryResultSet = results;
          tempSearchStore = results;
        });
      });
    } else {
      setState(() {
        tempSearchStore = queryResultSet
            .where((element) =>
                element['itemName'].toLowerCase().contains(value.toLowerCase()))
            .toList();
        debugPrint("Filtered Results: $tempSearchStore");
      });
    }
  }

  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFf2f2f2),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 50, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salam, $name',
                        style: AppTextStyles.boldTextStyle,
                      ),
                      Text(
                        AppTexts.goodMorningText,
                        style: AppTextStyles.lightTextStyle,
                      )
                    ],
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(30),
                    elevation: 3.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: image == null
                          ? const Center(
                              child: SizedBox(
                                height: 8,
                                width: 8,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                ),
                              ),
                            )
                          : Image(
                              image: NetworkImage(image ?? ''),
                              height: 45,
                              width: 45,
                              fit: BoxFit.cover,
                            ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      hintText: 'Search Products...',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: search
                          ? GestureDetector(
                              onTap: () {
                                tempSearchStore = [];
                                queryResultSet = [];
                                search = false;
                                searchController.text = '';
                                setState(() {});
                              },
                              child: const Icon(Icons.close))
                          : const Icon(Icons.search)),
                  onChanged: (value) {
                    filterProducts(value);
                  },
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              search
                  ? SizedBox(
                      height: 150,
                      child: ListView(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        primary: false,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: tempSearchStore.map((element) {
                          return _buildResultCard(element);
                        }).toList(),
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _labelText('Categories'),
                            const Text(
                              'See All',
                              style: TextStyle(
                                  color: Color(0xFFfd6f3c),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 100,
                              width: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFfd6f3c),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                  child: Text(
                                'All',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              )),
                            ),
                            Flexible(
                              child: SizedBox(
                                height: 100,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: categories.length,
                                    itemBuilder: (context, index) {
                                      return CategoryTileWidget(
                                        image: categories[index],
                                        onTapped: () {
                                          AppRoutes.moveToNext(
                                              context,
                                              CategoryProductsScreen(
                                                  category:
                                                      itemCategories[index]));
                                        },
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _labelText('All Products'),
                            const Text(
                              'See All',
                              style: TextStyle(
                                  color: Color(0xFFfd6f3c),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: height * 0.2,
                                  width: 140,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Center(
                                        child: Image(
                                          image: AssetImage(
                                              AppAssets.headPhone2Img),
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'Headphone',
                                        style: AppTextStyles.semiBoldTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "\$100",
                                            style: TextStyle(
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
                                      )
                                    ],
                                  ),
                                );
                              }),
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelText(String text) {
    return Text(text, style: AppTextStyles.semiBoldTextStyle);
  }

  Widget _buildResultCard(data) {
    if (data == null ||
        !data.containsKey('itemName') ||
        !data.containsKey('selectedImage')) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        AppRoutes.moveToNext(
            context,
            ProductDetailScreen(
                image: data['selectedImage'],
                title: data['itemName'],
                description: data['detail'],
                price: data['price']));
      },
      child: Container(
        width: 140,
        height: 130,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: data['selectedImage'] ?? '',
                height: 100,
                width: 140,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildShimmerImage(),
                errorWidget: (context, url, error) => const Icon(
                  Icons.image_not_supported,
                  size: 120,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Text(
                data['itemName'] ?? 'No Name',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.semiBoldTextStyle.copyWith(fontSize: 13),
              ),
            ),
          ],
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
