import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/cart_model.dart';
import '../providers/products_provider.dart';
import '../services/my_app_functions.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get getCartitems {
    return _cartItems;
  }

  // Firestore collection reference for user documents
  final userstDb = FirebaseFirestore.instance.collection("users");

  // Firebase authentication instance
  final _auth = FirebaseAuth.instance;

  // Firebase - Add item to cart
  Future<void> addToCartFirebase({
    required String productId,
    required int qty,
    required BuildContext context,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      // Show error message if user is not logged in
      MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "Please login first",
        fct: () {},
      );
      return;
    }
    final uid = user.uid;
    final cartId = const Uuid().v4(); // Generate unique cart ID
    try {
      // Update user document in Firestore to add item to cart
      await userstDb.doc(uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': qty,
          }
        ])
      });
      // Fetch updated cart after adding item
      await fetchCart();
      // Show toast message confirming item addition
      Fluttertoast.showToast(msg: "Item has been added");
    } catch (e) {
      // Rethrow error if update fails
      rethrow;
    }
  }

  // Firebase - Fetch user's cart items
  Future<void> fetchCart() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      // Clear local cart if user is not logged in
      _cartItems.clear();
      return;
    }
    try {
      // Get user document from Firestore
      final userDoc = await userstDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey('userCart')) {
        return;
      }
      // Iterate through user's cart items and update local cart
      final leng = userDoc.get("userCart").length;
      for (int index = 0; index < leng; index++) {
        _cartItems.putIfAbsent(
          userDoc.get("userCart")[index]['productId'],
          () => CartModel(
              cartId: userDoc.get("userCart")[index]['cartId'],
              productId: userDoc.get("userCart")[index]['productId'],
              quantity: userDoc.get("userCart")[index]['quantity']),
        );
      }
    } catch (e) {
      rethrow;
    }
    // Notify listeners after updating local cart
    notifyListeners();
  }

  // Firebase - Remove item from user's cart
  Future<void> removeCartItemFromFirestore({
    required String cartId,
    required String productId,
    required int qty,
  }) async {
    final User? user = _auth.currentUser;
    try {
      // Update user document in Firestore to remove item from cart
      await userstDb.doc(user!.uid).update({
        'userCart': FieldValue.arrayRemove([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': qty,
          }
        ])
      });
      // Remove item from local cart
      _cartItems.remove(productId);
      // Show toast message confirming item removal
      Fluttertoast.showToast(msg: "Item has been removed");
    } catch (e) {
      rethrow;
    }
  }

  // Firebase - Clear user's entire cart
  Future<void> clearCartFromFirebase() async {
    final User? user = _auth.currentUser;
    try {
      // Update user document in Firestore to clear cart
      await userstDb.doc(user!.uid).update({
        'userCart': [],
      });
      // Clear local cart
      _cartItems.clear();
      // Show toast message confirming cart clearance
      Fluttertoast.showToast(msg: "Cart has been cleared");
    } catch (e) {
      rethrow;
    }
  }

  // Local - Add product to local cart
  void addProductToCart({required String productId}) {
    _cartItems.putIfAbsent(
      productId,
      () => CartModel(
          cartId: const Uuid().v4(), productId: productId, quantity: 1),
    );
    notifyListeners();
  }

  // Local - Update quantity of product in local cart
  void updateQty({required String productId, required int qty}) {
    _cartItems.update(
      productId,
      (cartItem) => CartModel(
        cartId: cartItem.cartId,
        productId: productId,
        quantity: qty,
      ),
    );
    notifyListeners();
  }

  // Local - Check if product is in local cart
  bool isProdinCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  // Local - Calculate total price of items in cart
  double getTotal({required ProductsProvider productsProvider}) {
    double total = 0.0;

    _cartItems.forEach((key, value) {
      final getCurrProduct = productsProvider.findByProdId(value.productId);
      if (getCurrProduct == null) {
        total += 0;
      } else {
        total += double.parse(getCurrProduct.productPrice) * value.quantity;
      }
    });
    return total;
  }

  // Local - Get total quantity of items in cart
  int getQty() {
    int total = 0;
    _cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  // Local - Clear local cart
  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Local - Remove single item from local cart
  void removeOneItem({required String productId}) {
    _cartItems.remove(productId);
    notifyListeners();
  }
}
