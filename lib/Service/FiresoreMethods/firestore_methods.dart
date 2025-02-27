import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreMethods {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUserDataToFirestore(
      Map<String, dynamic> userMap, String id) async {
    return await firebaseFirestore.collection('users').doc(id).set(userMap);
  }

  addFoodIem(Map<String, dynamic> addItem, String category) async {
    return await firebaseFirestore.collection(category).add(addItem);
  }

  Future<Stream<QuerySnapshot>> getCategory(String category) async {
    return firebaseFirestore.collection(category).snapshots();
  }

  Future<Stream<QuerySnapshot>> getOrders(String email) async {
    return firebaseFirestore
        .collection('orders')
        .where('userEmail', isEqualTo: email)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllOrders() async {
    return firebaseFirestore
        .collection('orders')
        .where('orderStatus', isEqualTo: 'On the way')
        .snapshots();
  }

  Future addOrderDetails(Map<String, dynamic> userMap) async {
    return await firebaseFirestore.collection('orders').add(userMap);
  }

  Future<void> updateStatus(String id) async {
    return await firebaseFirestore
        .collection('orders')
        .doc(id)
        .update({'orderStatus': 'Delivered'});
  }

  mixedProducts(Map<String, dynamic> mixedProductInfo) async {
    return await firebaseFirestore
        .collection('mixedProducts')
        .add(mixedProductInfo);
  }

  Future<QuerySnapshot> searchProducts(String updatedName) async {
    return await firebaseFirestore
        .collection('mixedProducts')
        .where('searchKey',
            isEqualTo: updatedName.substring(0, 1).toUpperCase())
        .get();
  }

  Future<void> updateUserProfile(String userId, String newProfilePic) async {
    if (userId.isEmpty) {
      debugPrint('Error: Profile pic not selected');
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'image': newProfilePic,
    });
  }

  Future<void> updateUserName(String userId, String userName) async {
    if (userId.isEmpty) {
      debugPrint('Error: User ID is empty');
      return;
    }

    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .update({'name': userName});
  }

  Future<void> updateUserEmail(String userId, String userEmail) async {
    if (userId.isEmpty) {
      debugPrint('Error: User ID is empty');
      return;
    }

    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .update({'email': userEmail});
  }

  Future<void> deleteUser(String id) async {
    return await firebaseFirestore.collection("users").doc(id).delete();
  }
}
