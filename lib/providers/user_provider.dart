import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  // UserModel instance to store user information
  UserModel? userModel;

  // Getter method to access userModel
  UserModel? get getUserModel {
    return userModel;
  }

  // Method to fetch user information from Firestore
  Future<UserModel?> fetchUserInfo() async {
    // Initialize FirebaseAuth instance
    final auth = FirebaseAuth.instance;

    // Get current user from FirebaseAuth
    User? user = auth.currentUser;

    // Return null if no user is logged in
    if (user == null) {
      return null;
    }

    // Extract user ID
    String uid = user.uid;

    try {
      // Get user document from Firestore using user ID
      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      // Extract user data from the document
      final userDocDict = userDoc.data();
      userModel = UserModel(
        userId: userDoc.get("userId"),
        userName: userDoc.get("userName"),
        userImage: userDoc.get("userImage"),
        userEmail: userDoc.get('userEmail'),
        userCart:
            userDocDict!.containsKey("userCart") ? userDoc.get("userCart") : [],
        userWish:
            userDocDict.containsKey("userWish") ? userDoc.get("userWish") : [],
        createdAt: userDoc.get('createdAt'),
      );

      // Return userModel with user information
      return userModel;
    } on FirebaseException {
      // Rethrow FirebaseException for handling
      rethrow;
    } catch (error) {
      // Rethrow any other errors for handling
      rethrow;
    }
  }
}
