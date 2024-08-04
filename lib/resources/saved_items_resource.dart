import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/seller/add_product.dart';

class SavedItemsResource {
  Future<List<AddProduct>> getSavedProducts() async {
    List<AddProduct> products = [];
    try {
      await firebaseFirestore
          .collection(savedProductsCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .get()
          .then((snapshot) async {
        if (snapshot.exists && snapshot.data()!['products'].isNotEmpty) {
          for (var product in snapshot.data()!['products']) {
            await firebaseFirestore
                .collection(productsCollection)
                .doc(product)
                .get()
                .then((productSnapshot) {
              products.add(AddProduct.fromJson(productSnapshot));
            });
          }
        }
      });
      return products;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Object> getSavedClicky() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> clickies = [];
    try {
      await firebaseFirestore
          .collection(savedClickyCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .get()
          .then((snapshot) async {
        if (snapshot.exists && snapshot.data()!['clickies'].isNotEmpty) {
          await firebaseFirestore
              .collection(clickiesCollection)
              .where('id', whereIn: snapshot.data()!['clickies'])
              .get()
              .then((clickySnapshot) {
            clickies.addAll(clickySnapshot.docs);
          });
        }
      });
      return clickies;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<String> saveClickies(String clickyId) async {
    String res = 'An error occured';
    try {
      if (await clickyExists(clickyId)) {
        await firebaseFirestore
            .collection(savedClickyCollection)
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'clickies': FieldValue.arrayUnion([clickyId]),
        });
      }
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<bool> clickyExists(String clickyId) async {
    bool isExist = false;

    await firebaseFirestore
        .collection(savedClickyCollection)
        .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
        .where('clickies', arrayContains: clickyId)
        .get()
        .then((snapshot) {
      isExist = snapshot.docs.isEmpty;
    });
    return isExist;
  }

  removeSavedClicky(String clickyId) async {
    try {
      await firebaseFirestore
          .collection(savedClickyCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'clickies': FieldValue.arrayRemove([clickyId]),
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<String> removeSavedProduct(String productId) async {
    String res = 'An error occured';
    try {
      await firebaseFirestore
          .collection(savedProductsCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'products': FieldValue.arrayRemove([productId]),
      });
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  static Future<String> saveProduct(String productId) async {
    String res = 'An error occured';
    try {
      await firebaseFirestore
          .collection(savedProductsCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .set({
        'userId': firebaseAuth.currentUser!.uid,
        'products': FieldValue.arrayUnion([productId]),
      });
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
