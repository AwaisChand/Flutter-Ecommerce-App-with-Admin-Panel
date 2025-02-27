import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Common/AppRoutes/app_routes.dart';
import 'package:ecommerce_app/Common/utils.dart';
import 'package:ecommerce_app/Screens/AuthScreens/LoginScreen/login_screen.dart';
import 'package:ecommerce_app/Screens/BottomNavigationBar/bottom_navigation_bar_screen.dart';
import 'package:ecommerce_app/Service/FiresoreMethods/firestore_methods.dart';
import 'package:ecommerce_app/Service/SharedPrefMethods/shared_pref_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Screens/OnBoardingScreen/onboarding_screen.dart';

class UserProvider extends ChangeNotifier {
  // create an instance of firebase auth

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // create an instance of firebase storage

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  // create an instance of image picker

  ImagePicker imagePicker = ImagePicker();

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  String? _userProfile;
  String? get userProfile => _userProfile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set circularProgressIndicator(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> signUp(
      BuildContext context, String name, email, password) async {
    try {
      circularProgressIndicator = true;
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final String userId = randomAlphaNumeric(10);
      final Map<String, dynamic> userInfo = {
        'userId': userId,
        'name': name,
        'email': email,
        'image':
            'https://img.freepik.com/free-photo/bohemian-man-with-his-arms-crossed_1368-3542.jpg?semt=ais_hybrid'
      };

      await FirestoreMethods().addUserDataToFirestore(userInfo, userId);

      await SharedPrefMethods.saveUserId(userId);
      await SharedPrefMethods.saveUserName(name);
      await SharedPrefMethods.saveUserEmail(email);
      await SharedPrefMethods.saveUserImage(
          'https://img.freepik.com/free-photo/bohemian-man-with-his-arms-crossed_1368-3542.jpg?semt=ais_hybrid');
      AppRoutes.moveToNext(context, const LoginScreen());
      Utils.toastSuccessMsg(
          context, 'You have successfully signup with your account!');
      circularProgressIndicator = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Utils.toastErrorMsg(context, 'Password is too weak');
        circularProgressIndicator = false;
      } else if (e.code == 'email-already-in-use') {
        Utils.toastErrorMsg(context, 'Account already exist');
        circularProgressIndicator = false;
      }
    } catch (e) {
      Utils.toastErrorMsg(context, 'catch error: ${e.toString()}');
      circularProgressIndicator = false;
    }
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    if (password.isNotEmpty) {
      try {
        circularProgressIndicator = true;

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where("email", isEqualTo: email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          String customId = userDoc['userId'];
          String userName = userDoc['name'];
          String profilePic = userDoc['image'];

          await SharedPrefMethods.saveUserId(customId);
          await SharedPrefMethods.saveUserEmail(email);
          await SharedPrefMethods.saveUserName(userName);
          await SharedPrefMethods.saveUserImage(profilePic);
          await loadUserProfile();
          debugPrint(
              "Logged in user: $email,ID: $customId, profile: $profilePic");


          Utils.toastSuccessMsg(
              context, "You have successfully sign in to your account");

          AppRoutes.moveNextAndRemoveUntil(
              context, const BottomNavigationBarScreen());

          circularProgressIndicator = false;

          notifyListeners();
        } else {
          Utils.toastErrorMsg(context, "User data not found.");
        }

        circularProgressIndicator = false;
      } catch (e) {
        Utils.toastErrorMsg(context, "Error: ${e.toString()}");
        circularProgressIndicator = false;
      }
    }
  }

  Future<bool> adminLogin(
      BuildContext context, String username, String password) async {
    try {
      circularProgressIndicator = true;
      // Reference Firestore collection
      final adminRef = FirebaseFirestore.instance.collection('admin');

      // Query Firestore for matching email
      var querySnapshot =
          await adminRef.where('username', isEqualTo: username).get();

      if (querySnapshot.docs.isNotEmpty) {
        var adminData = querySnapshot.docs.first.data();

        // Check password (Assuming it's stored as plain text; consider hashing it)
        if (adminData['password'] == password) {
          Utils.toastSuccessMsg(context, "Login Successful");
          circularProgressIndicator = false;
          return true;
        } else {
          Utils.toastErrorMsg(context, "Incorrect password");
          circularProgressIndicator = false;
          return false;
        }
      } else {
        Utils.toastErrorMsg(context, "Admin not found");
        circularProgressIndicator = false;
        return false;
      }
    } catch (e) {
      Utils.toastErrorMsg(context, "Login Failed: ${e.toString()}");
      circularProgressIndicator = false;
      return false;
    }
  }

  Future<void> pickImageFromGallery() async {
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _selectedImage = File(pickedImage.path);
      notifyListeners();
    } else {
      debugPrint("Image not picked");
    }
  }

  UserProvider() {
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    _userProfile = await SharedPrefMethods.getUserImage();
    notifyListeners();
  }

  Future<void> pickUserProfile(BuildContext context) async {
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _selectedImage = File(pickedImage.path);
      notifyListeners();

      try {
        String? userId = await SharedPrefMethods.getUserId();
        if (userId!.isNotEmpty) {
          // Upload image to Firebase Storage
          String id = randomAlphaNumeric(10);
          Reference reference =
              firebaseStorage.ref().child("userImage").child(id);

          UploadTask uploadTask = reference.putFile(_selectedImage!);
          TaskSnapshot snapshot = await uploadTask;
          var downloadUrl = await snapshot.ref.getDownloadURL();

          // Update the profile picture URL in SharedPreferences
          await SharedPrefMethods.saveUserImage(downloadUrl);

          // Update the Firestore document with the new profile picture
          await FirestoreMethods().updateUserProfile(userId, downloadUrl);

          _userProfile = downloadUrl;
          notifyListeners();
        } else {
          Utils.toastErrorMsg(context, "User ID not found.");
        }
      } catch (e) {
        debugPrint("Error uploading profile image: ${e.toString()}");
        Utils.toastErrorMsg(
            context, "Failed to upload profile image. Try again.");
      }
    } else {
      debugPrint("Image not picked");
    }
  }

  Future<void> uploadProductItem(
      String item, price, detail, category, BuildContext context) async {
    try {
      circularProgressIndicator = true;
      if (_selectedImage != null &&
          item != '' &&
          price != null &&
          detail != null) {
        String id = randomAlphaNumeric(10);
        Reference reference =
            firebaseStorage.ref().child("adminImage").child(id);

        // this will make sure to upload the selected image to firebase storage

        UploadTask uploadTask = reference.putFile(_selectedImage!);

        // Wait for the upload to complete and get the snapshot

        TaskSnapshot snapshot = await uploadTask;

        // once the image is uploaded we are able to get selected image URL

        var downloadUrl = await snapshot.ref.getDownloadURL();
        String firstLetter = item.substring(0, 1).toUpperCase();

        Map<String, dynamic> addItem = {
          "selectedImage": downloadUrl,
          "itemName": item,
          'searchKey': firstLetter,
          'updatedName': item.toUpperCase(),
          "price": price,
          "detail": detail
        };
        await FirestoreMethods().addFoodIem(addItem, category);
        await FirestoreMethods().mixedProducts(addItem);
        AppRoutes.moveToNext(context, const BottomNavigationBarScreen());
        Utils.toastSuccessMsg(
            context, "Product Item has been added successfully");
        notifyListeners();
        circularProgressIndicator = false;
      } else {
        debugPrint("Double check if you missed something");
        Utils.toastErrorMsg(
            context, "You need to double check your information");
        circularProgressIndicator = false;
      }
    } catch (e) {
      debugPrint("Catch Error: ${e.toString()}");
      Utils.toastErrorMsg(context, "Catch Error: ${e.toString()}");
      circularProgressIndicator = false;
    }
  }

  Future<void> checkUserLogin(BuildContext context) async {
    User? user = firebaseAuth.currentUser;

    if (user != null) {
      await SharedPrefMethods.getUserId();
      await SharedPrefMethods.getUserName();
      await SharedPrefMethods.getUserEmail();
      final profile = await SharedPrefMethods.getUserImage();

      _userProfile = profile;
      Timer(const Duration(seconds: 2), () {
        AppRoutes.moveToNext(context, const BottomNavigationBarScreen());
      });
      notifyListeners();
    } else {
      AppRoutes.moveToNext(context, const LoginScreen());
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    await firebaseAuth.signOut();

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.clear();

    _userProfile = null;
    Utils.toastSuccessMsg(
        context, "You have successful logout to your account");

    notifyListeners();

    debugPrint(
        "User logged out, SharedPreferences cleared except profile pic.");

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      User? user = firebaseAuth.currentUser;
      await user?.reload();
      user = firebaseAuth.currentUser;
      if (user == null) {
        Utils.toastErrorMsg(context, "No authenticated user found.");
        circularProgressIndicator = false;
        return;
      }

      String? userId = await SharedPrefMethods.getUserId();
      if (userId == null) {
        Utils.toastErrorMsg(context, "User ID not found in local storage.");
        return;
      }

      await FirestoreMethods().deleteUser(userId);

      String? profilePic = await SharedPrefMethods.getUserImage();
      if (profilePic != null && profilePic.isNotEmpty) {
        try {
          Reference imageRef = firebaseStorage.refFromURL(profilePic);
          await imageRef.delete();
        } catch (e) {
          debugPrint("Error deleting profile image: ${e.toString()}");
        }
      }

      await user.delete();

      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.clear();

      _userProfile = null;
      notifyListeners();

      Utils.toastSuccessMsg(context, "Account deleted successfully.");
      debugPrint("User account deleted: $userId");

      // 5️⃣ Navigate to login screen
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    } catch (e) {
      debugPrint("Error deleting account: ${e.toString()}");
      Utils.toastErrorMsg(context, "Failed to delete account. Try again.");
      circularProgressIndicator = false;
    }
  }
}
