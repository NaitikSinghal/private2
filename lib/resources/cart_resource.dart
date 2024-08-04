import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/cart.dart';
import 'package:uuid/uuid.dart';

class CartResource {
  Stream<List<Map<String, dynamic>>> getCart = (() async* {
    final List<Map<String, dynamic>> productData = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await firebaseFirestore
        .collection('cart')
        .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
        .get();

    for (var data in snapshot.docs) {
      await firebaseFirestore
          .collection(productsCollection)
          .doc(data['productId'])
          .get()
          .then((product) {
        productData.add({
          'cartId': data['id'],
          'quantity': data['quantity'],
          'name': product.data()!['name'],
          'userId': data['userId'],
          'basePrice': product.data()!['base_price'],
          'sellingPrice': product.data()!['selling_price'],
          'categoryId': product.data()!['categoryId'],
          'imageUrl': product.data()!['image_url'],
          'longDesc': product.data()!['long_desc'],
          'shortDesc': product.data()!['short_desc'],
          'productId': product.data()!['product_id'],
        });
      });
    }
    yield productData;
  })();

  Future<String> addToCart(Cart cart) async {
    String res = 'An error occured';
    try {
      await firebaseFirestore
          .collection(cartCollection)
          .where('productId', isEqualTo: cart.productId)
          .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
          .get()
          .then((snapshot) async {
        if (snapshot.docs.isEmpty) {
          await firebaseFirestore
              .collection(cartCollection)
              .doc(cart.id)
              .set(cart.toJson());
          await removeFromSavedItems(cart.productId);
          res = 'success';
        } else {
          final cartData = snapshot.docs.single.data();
          await firebaseFirestore
              .collection(cartCollection)
              .doc(cartData['id'])
              .update({
            'size': cart.size,
            'unit': cart.unit,
            'color': cart.color,
            'colorCode': cart.colorCode,
            'price': cart.price,
            'discount': cart.discount,
            'discountUnit': cart.discountUnit
          });
          await removeFromSavedItems(cart.productId);
          res = 'success';
        }
      });
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> increaseQuantity(String cartId, int qunatity) async {
    String res = 'An error occured';
    try {
      if (qunatity > 0) {
        await firebaseFirestore.collection(cartCollection).doc(cartId).update({
          'quantity': qunatity + 1,
        });
        res = 'success';
      } else {
        res = 'nothing';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> decreaseQuantity(String cartId, int qunatity) async {
    String res = 'An error occured';
    try {
      if (qunatity > 1) {
        await firebaseFirestore.collection(cartCollection).doc(cartId).update({
          'quantity': qunatity - 1,
        });
        res = 'success';
      } else {
        res = 'nothing';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> removeCartItem(String cartId) async {
    String res = 'An error occured';
    try {
      await firebaseFirestore.collection(cartCollection).doc(cartId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> saveForLater(String productId, String cartId) async {
    String res = 'An error occured';
    try {
      if (await userExists(firebaseAuth.currentUser!.uid)) {
        await firebaseFirestore
            .collection(savedProductsCollection)
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'products': FieldValue.arrayUnion([productId]),
        });
        await removeCartItem(cartId);
      } else {
        await firebaseFirestore
            .collection(savedProductsCollection)
            .doc(firebaseAuth.currentUser!.uid)
            .set({
          'userId': firebaseAuth.currentUser!.uid,
          'products': FieldValue.arrayUnion([productId]),
        });
        await removeCartItem(cartId);
      }

      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Future<bool> productExists(String productId) async => (await firebaseFirestore
  //             .collection(productsCollection)
  //             .where('user_id', isEqualTo: firebaseAuth.currentUser!.uid)
  //             .where("products", arrayContains: productId)
  //             .get())
  //         .docs
  //         .isEmpty
  //     ? false
  //     : true;

  Future<bool> userExists(String username) async => (await firebaseFirestore
              .collection(savedProductsCollection)
              .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
              .get())
          .docs
          .isEmpty
      ? false
      : true;

  Future<void> removeFromSavedItems(String productId) async {
    await firebaseFirestore
        .collection(savedProductsCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'products': FieldValue.arrayRemove([productId])
    });
  }

  Future<String> addToCartAndRemoveFromSaved(Cart cart) async {
    String res = 'An error occured';
    try {
      await firebaseFirestore
          .collection(cartCollection)
          .where('productId', isEqualTo: cart.productId)
          .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
          .get()
          .then((snapshot) async {
        if (snapshot.docs.isEmpty) {
          await firebaseFirestore
              .collection('cart')
              .doc(cart.id)
              .set(cart.toJson());
          res = 'success';
        } else {
          final cartData = snapshot.docs.single.data();
          await firebaseFirestore
              .collection(cartCollection)
              .doc(cartData['id'])
              .update({'quantity': cartData['quantity'] + 1});
          res = 'success';
        }
      });
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
