import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class DatabaseSeeder {
  static Future<void> uploadDummyProducts() async {
    final CollectionReference productsRef =
    FirebaseFirestore.instance.collection('products');

    List<ProductModel> dummyProducts = [
      ProductModel(
        productId: 'p1',
        productTitle: 'Cheese Burger',
        productPrice: '59',
        productCategory: 'UB',
        productDescription: 'Delicious beef burger with extra cheese.',
        productImage: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=512&h=512&auto=format&fit=crop',
        productQuantity: '10',
        createdAt: Timestamp.now(),
      ),
      ProductModel(
        productId: 'p2',
        productTitle: 'Pepperoni Pizza',
        productPrice: '120',
        productCategory: 'UB',
        productDescription: 'Large pizza with crispy pepperoni.',
        productImage: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?q=80&w=512&h=512&auto=format&fit=crop',
        productQuantity: '5',
        createdAt: Timestamp.now(),
      ),
      ProductModel(
        productId: 'p3',
        productTitle: 'Chocolate Muffin',
        productPrice: '35',
        productCategory: 'Mayuri',
        productDescription: 'Soft muffin filled with dark chocolate chips.',
        productImage: 'https://images.unsplash.com/photo-1611329695518-1763319f3551?q=80&w=512&h=512&auto=format&fit=crop',
        productQuantity: '20',
        createdAt: Timestamp.now(),
      ),
      ProductModel(
        productId: 'p4',
        productTitle: 'Coca Cola',
        productPrice: '15',
        productCategory: 'Boys Mess',
        productDescription: 'Refreshing chilled 500ml bottle.',
        productImage: 'https://images.unsplash.com/photo-1594971475674-6a97f8fe8c2b?q=80&w=512&h=512&auto=format&fit=crop',
        productQuantity: '50',
        createdAt: Timestamp.now(),
      ),
      ProductModel(
        productId: 'p5',
        productTitle: 'Veggie Pizza',
        productPrice: '110',
        productCategory: 'Mayuri',
        productDescription: 'Loaded with bell peppers, olives, and onions.',
        productImage: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=512&h=512&auto=format&fit=crop',
        productQuantity: '8',
        createdAt: Timestamp.now(),
      ),
      ProductModel(
        productId: 'p6',
        productTitle: 'Chicken Nuggets',
        productPrice: '65',
        productCategory: 'Boys Mess',
        productDescription: '10 pieces of crispy golden chicken nuggets.',
        productImage: 'https://images.unsplash.com/photo-1627662168223-7df99068099a?q=80&w=512&h=512&auto=format&fit=crop',
        productQuantity: '15',
        createdAt: Timestamp.now(),
      ),
      ProductModel(
        productId: 'p7',
        productTitle: 'French Fries',
        productPrice: '29',
        productCategory: 'Mayuri',
        productDescription: 'Large portion of salted crispy fries.',
        productImage: 'https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?q=80&w=512&h=512&auto=format&fit=crop',
        productQuantity: '30',
        createdAt: Timestamp.now(),
      ),
      ProductModel(
        productId: 'p8',
        productTitle: 'Vanilla Ice Cream',
        productPrice: '40',
        productCategory: 'Boys Mess',
        productDescription: 'Three scoops of creamy vanilla ice cream.',
        productImage: 'https://images.unsplash.com/photo-1570197788417-0e82375c9371?q=80&w=512&h=512&auto=format&fit=crop',
        productQuantity: '12',
        createdAt: Timestamp.now(),
      ),
      ProductModel(
        productId: 'p9',
        productTitle: 'Double Patty Burger',
        productPrice: '85',
        productCategory: 'Girls Mess',
        productDescription: 'Two juicy beef patties with special sauce.',
        productImage: 'https://images.unsplash.com/photo-1734774204115-941fb31c25c8?q=80&w=512&h=512&auto=format&fit=crop',
        productQuantity: '7',
        createdAt: Timestamp.now(),
      ),
      ProductModel(
        productId: 'p10',
        productTitle: 'Iced Coffee',
        productPrice: '39',
        productCategory: 'Mayuri',
        productDescription: 'Cold brewed coffee with milk and ice.',
        productImage: 'https://images.unsplash.com/photo-1578314675249-a6910f80cc4e?q=80&w=512&h=512&auto=format&fit=crop',
        productQuantity: '25',
        createdAt: Timestamp.now(),
      ),
      ProductModel(
        productId: 'p11',
        productTitle: 'Hot Dog',
        productPrice: '45',
        productCategory: 'Mayuri',
        productDescription: 'Classic hot dog with mustard and ketchup.',
        productImage: 'https://images.unsplash.com/photo-1638368593249-7cadb261e8b3?w=512&h=512&auto=format&fit=crop&q=60',
        productQuantity: '15',
        createdAt: Timestamp.now(),
      ),
      ProductModel(
        productId: 'p12',
        productTitle: 'Orange Juice',
        productPrice: '25',
        productCategory: 'UB',
        productDescription: 'Freshly squeezed 100% orange juice.',
        productImage: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=512&h=512&auto=format&fit=crop&q=60',
        productQuantity: '20',
        createdAt: Timestamp.now(),
      ),
      ProductModel(
        productId: 'p13',
        productTitle: 'Taco',
        productPrice: '30',
        productCategory: 'Girls Mess',
        productDescription: 'Spicy beef taco with lettuce and cheese.',
        productImage: 'https://images.unsplash.com/photo-1545093149-618ce3bcf49d?w=512&h=512&auto=format&fit=crop&q=60',
        productQuantity: '40',
        createdAt: Timestamp.now(),
      ),
      ProductModel(
        productId: 'p14',
        productTitle: 'Strawberry Cake',
        productPrice: '150',
        productCategory: 'Girls Mess',
        productDescription: 'Whole strawberry cream cake for celebrations.',
        productImage: 'https://images.unsplash.com/photo-1602663491496-73f07481dbea?w=512&h=512&auto=format&fit=crop&q=60',
        productQuantity: '3',
        createdAt: Timestamp.now(),
      ),
    ];

    for (var product in dummyProducts) {
      await productsRef.doc(product.productId).set(product.toMap());
    }
    if (kDebugMode) {
      print("Dummy products added!");
    }
  }
}