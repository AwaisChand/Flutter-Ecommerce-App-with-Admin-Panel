import 'dart:convert';

import 'package:ecommerce_app/Common/AppTextStyles/app_text_styles.dart';
import 'package:ecommerce_app/Service/FiresoreMethods/firestore_methods.dart';
import 'package:ecommerce_app/Service/SharedPrefMethods/shared_pref_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../../Common/utils.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      required this.price});
  final String image;
  final String title;
  final String description;
  final String price;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? paymentIntentData;

  String? name, email, userImage;

  getUserData() async {
    name = await SharedPrefMethods.getUserName();
    email = await SharedPrefMethods.getUserEmail();
    userImage = await SharedPrefMethods.getUserImage();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFf2f2f2),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Product Details',
          style: AppTextStyles.semiBoldTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  image: NetworkImage(widget.image),
                  height: height * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.title, style: AppTextStyles.boldTextStyle),
                      Text('\$${widget.price}',
                          style: const TextStyle(
                            color: Color(0xFFfd6f3c),
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          )),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Text('Details', style: AppTextStyles.semiBoldTextStyle),
                  const SizedBox(height: 10.0),
                  Text(widget.description,
                      style:
                          AppTextStyles.lightTextStyle.copyWith(fontSize: 13)),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      height: 50,
                      color: const Color(0xFFfd6f3c),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () {
                        makePayment(widget.price);
                      },
                      child:
                          Text('Buy Now', style: AppTextStyles.buttonTextStyle),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      String numericAmount = amount.replaceAll("\$", "");
      paymentIntentData = await createPaymentIntent(numericAmount, 'USD');

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  style: ThemeMode.light,
                  merchantDisplayName: 'Ali'))
          .then((value) {});

      displayPaymentSheet();
    } catch (e, s) {
      debugPrint('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        final Map<String, dynamic> addOrderInfo = {
          "productImage": widget.image,
          "productName": widget.title,
          "productDesc": widget.description,
          'productPrice': widget.price,
          "orderStatus": 'On the way',
          "userName": name,
          "userEmail": email,
          "userImage": userImage,
        };
        await FirestoreMethods().addOrderDetails(addOrderInfo);
        paymentIntentData = null;

        Utils.toastSuccessMsg(context, "✅ Payment Successful");
      }).onError((error, stackTrace) {
        debugPrint('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      debugPrint('Error is:---> $e');
      // Utils.toastErrorMsg(context, "${e.toString()}");
      Utils.toastErrorMsg(context, "Payment Cancelled");
    } catch (e) {
      debugPrint('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${Utils.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;

    return calculatedAmount.toStringAsFixed(0);
  }
}
