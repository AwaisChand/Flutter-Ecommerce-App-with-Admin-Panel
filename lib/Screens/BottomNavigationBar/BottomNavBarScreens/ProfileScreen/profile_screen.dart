import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/Common/AppAssets/app_assets.dart';
import 'package:ecommerce_app/Common/AppRoutes/app_routes.dart';
import 'package:ecommerce_app/Provider/UserPovider/user_provider.dart';
import 'package:ecommerce_app/Screens/AuthScreens/SignUpScreen/sign_up_screen.dart';
import 'package:ecommerce_app/Service/FiresoreMethods/firestore_methods.dart';
import 'package:ecommerce_app/Service/SharedPrefMethods/shared_pref_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Common/AppTextStyles/app_text_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _userName;
  String? _userEmail;
  String? _userId;

  getUserDataFromSharedPref() async {
    _userName = await SharedPrefMethods.getUserName();
    _userEmail = await SharedPrefMethods.getUserEmail();
    _userId = await SharedPrefMethods.getUserId();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserDataFromSharedPref();
  }

  void _showAlertDialogForName(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: _userName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update your details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String updatedName = nameController.text.trim();

                if (updatedName.isNotEmpty) {
                  await FirestoreMethods()
                      .updateUserName(_userId!, updatedName);
                  await SharedPrefMethods.saveUserName(updatedName);

                  setState(() {
                    _userName = updatedName;
                  });

                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialogForEmail(BuildContext context) {
    TextEditingController emailController =
        TextEditingController(text: _userEmail);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update your details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String updatedEmail = emailController.text.trim();

                if (updatedEmail.isNotEmpty) {
                  await FirestoreMethods()
                      .updateUserEmail(_userId!, updatedEmail);
                  await SharedPrefMethods.saveUserEmail(updatedEmail);

                  setState(() {
                    _userEmail = updatedEmail;
                  });

                  Navigator.of(context).pop();
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFf2f2f2),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text("Profile",
                        style:
                            AppTextStyles.boldTextStyle.copyWith(fontSize: 20)),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    userProvider.pickUserProfile(context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: userProvider.userProfile != null &&
                            userProvider.userProfile!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: userProvider.userProfile!,
                            height: 140,
                            width: 140,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => _buildShimmerImage(),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              size: 120,
                              color: Colors.grey,
                            ),
                          )
                        : Image.asset(
                            AppAssets.laptopImg,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: height * 0.04),
                InkWell(
                    onTap: () {
                      AppRoutes.moveToNext(context, const SignUpScreen());
                    },
                    child: _containerTwoWidget(
                        Icons.person, "Create Your Account")),
                SizedBox(height: height * 0.05),
                _containerOneWidget(Icons.person, "Name", _userName ?? '',
                    Icons.edit, () => _showAlertDialogForName(context)),
                SizedBox(height: height * 0.04),
                _containerOneWidget(Icons.email, "Email", _userEmail ?? '',
                    Icons.edit, () => _showAlertDialogForEmail(context)),
                SizedBox(height: height * 0.04),
                InkWell(
                    onTap: () async {
                      await userProvider.deleteAccount(context);
                    },
                    child: _containerTwoWidget(Icons.delete, "Delete Account")),
                SizedBox(height: height * 0.04),
                InkWell(
                    onTap: () {
                      userProvider.logoutUser(context);
                    },
                    child: _containerTwoWidget(Icons.logout, "LogOut")),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _containerOneWidget(IconData icon, String text1, String text2,
      IconData editIcon, VoidCallback onTapped) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 55,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text1,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  Text(
                    text2,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: onTapped,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: Icon(editIcon, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _containerTwoWidget(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 55,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(width: 20),
              Text(
                text,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ],
          ),
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
