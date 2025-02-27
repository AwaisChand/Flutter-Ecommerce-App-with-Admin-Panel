import 'package:ecommerce_app/Common/AppTextStyles/app_text_styles.dart';
import 'package:ecommerce_app/Common/AppTexts/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Common/utils.dart';
import '../../../Provider/UserPovider/user_provider.dart';

class AddProductItemsScreen extends StatefulWidget {
  const AddProductItemsScreen({super.key});

  @override
  State<AddProductItemsScreen> createState() => _AddProductItemsScreenState();
}

class _AddProductItemsScreenState extends State<AddProductItemsScreen> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemPriceController = TextEditingController();
  final TextEditingController itemDetailController = TextEditingController();

  final List<String> itemCategories = [
    "Laptop",
    "TV",
    "Watch",
    "Headphones",
  ];
  String? selectedCategory;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(AppTexts.addProductItemText,
                style: AppTextStyles.lightTextStyle),
            leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 20,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, right: 20, left: 20, bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _labelText(AppTexts.uploadItemsPicText),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      userProvider.pickImageFromGallery();
                    },
                    child: Center(
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: height * 0.15,
                          width: height * 0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  width: 1.5, color: Colors.black38)),
                          child: userProvider.selectedImage == null
                              ? const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.grey,
                          )
                              : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                userProvider.selectedImage!,
                                // height: 90,
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _labelText("Item Name"),
                  const SizedBox(height: 15),
                  _textField(
                      controller: itemNameController,
                      textInputType: TextInputType.name,
                      hintText: "Enter Item Name",
                      height: height * 0.062),
                  const SizedBox(height: 20),
                  _labelText("Item Price"),
                  const SizedBox(height: 15),
                  _textField(
                      controller: itemPriceController,
                      textInputType: TextInputType.number,
                      hintText: "Enter Item Price",
                      height: height * 0.062),
                  const SizedBox(height: 20),
                  _labelText("Item Detail"),
                  const SizedBox(height: 15),
                  _textField(
                    controller: itemDetailController,
                    textInputType: TextInputType.name,
                    maxLines: 7,
                    hintText: "Enter Item Detail",
                  ),
                  const SizedBox(height: 20),
                  _labelText("Select Category"),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFececf8),
                    ),
                    hint: Text("Choose a category",
                        style: AppTextStyles.adminHintTextStyle),
                    items: itemCategories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category,
                            style: AppTextStyles.adminHintTextStyle),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: SizedBox(
                      width: height * 0.2,
                      child: MaterialButton(
                        color: const Color(0xFFfd6f3c),
                        height: 48,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          if (userProvider.selectedImage == null) {
                            Utils.toastErrorMsg(context, "Please select an image");
                          } else if (itemNameController.text.isEmpty) {
                            Utils.toastErrorMsg(context, "Please enter an Item name");
                          } else if (itemPriceController.text.isEmpty) {
                            Utils.toastErrorMsg(context, "Please select an item price");
                          } else if (selectedCategory == null) {
                            Utils.toastErrorMsg(context, "Please select category");
                          } else {
                            userProvider.uploadProductItem(
                                itemNameController.text,
                                itemPriceController.text,
                                itemDetailController.text,
                                selectedCategory,
                                context);
                          }
                        },
                        child: userProvider.isLoading
                            ? const SizedBox(
                                width: 25,
                                height: 25,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                    color: Colors.white,
                                  ),
                                ))
                            : Text("Add",
                                style: AppTextStyles.loginTextStyle
                                    .copyWith(fontSize: 18)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _labelText(String text) {
    return Text(
      text,
      style: AppTextStyles.labelTextStyle,
    );
  }

  Widget _textField({
    TextEditingController? controller,
    TextInputType? textInputType,
    int? maxLines,
    String? hintText,
    double? height,
  }) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      style: AppTextStyles.adminHintTextStyle.copyWith(height: 0.0),
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        hintText: hintText,
        hintStyle: AppTextStyles.adminHintTextStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFececf8),
      ),
    );
  }
}
