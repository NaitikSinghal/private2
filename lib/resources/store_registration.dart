import 'dart:typed_data';
import 'package:pherico/config/variables.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/resources/storage_methods.dart';
import 'package:pherico/resources/user_resource.dart';
import 'package:pherico/utils/pick_image.dart';
import 'package:uuid/uuid.dart';

class StoreRegistration {
  Future<String> checkStoreName(String name) async {
    String res = 'fail';
    try {
      if (name.isNotEmpty) {
        if (await storeNameExists(name)) {
          res = 'success';
        } else {
          res = 'fail';
        }
      }
    } catch (err) {
      res = 'fail';
    }

    return res;
  }

  static Future<String> updateCover(Uint8List file) async {
    String response = 'An error occured';
    try {
      Uint8List image = await compressImage(file);
      String coverUrl =
          await uploadImage(const Uuid().v1(), image, 'store_covers');
      await firebaseFirestore
          .collection(storeCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .update({'cover': coverUrl});
      response = 'success';
    } catch (e) {
      response = 'fail';
    }
    return response;
  }

  Future<bool> storeNameExists(String sotreName) async =>
      (await firebaseFirestore
                  .collection(storeCollection)
                  .where('shopName', isEqualTo: sotreName)
                  .get())
              .docs
              .isEmpty
          ? false
          : true;

  Future<String> createStore(Map data) async {
    String res = 'An error occured';

    try {
      final pushToken = UserResource.myself.pushToken;
      Uint8List image = await compressImage(data['file']);
      String profileUrl =
          await uploadImage(const Uuid().v1(), image, 'store_profile');
      await firebaseFirestore
          .collection(storeCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .set({
        "shopName": data['shopName'],
        "cover": sellerDefaultCover,
        "profile": profileUrl,
        "bio": data['bio'],
        "categoryId": data['categoryId'],
        "uid": firebaseAuth.currentUser!.uid,
        "accounHolderName": data['accounHolderName'],
        "accountNumber": data['accountNumber'],
        "ifscNumber": data['ifscNumber'],
        "address": data['address'],
        "city": data['city'],
        "state": data['state'],
        "pincode": data['pincode'],
        "landmark": data['landmark'],
        "addressType": data['addressType'],
        "followers": [],
        "following": [],
        "isActive": 1,
        'isOnline': true,
        "pushToken": pushToken,
        'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
        "dateCreated": DateTime.now(),
        "dateUpdated": DateTime.now()
      });
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> updateStore(Map data) async {
    String res = 'An error occured';
    try {
      if (await storeExists(data['shopName'])) {
        res = 'storename';
        return res;
      } else {
        if (data['file'] != null) {
          Uint8List image = await compressImage(data['file']);
          String profileUrl =
              await uploadImage(const Uuid().v1(), image, 'store_profile');
          await firebaseFirestore
              .collection(storeCollection)
              .doc(firebaseAuth.currentUser!.uid)
              .update({
            "shopName": data['shopName'],
            "profile": profileUrl,
            "bio": data['bio'],
            "accounHolderName": data['accounHolderName'],
            "accountNumber": data['accountNumber'],
            "ifscNumber": data['ifscNumber'],
            "address": data['address'],
            "city": data['city'],
            "state": data['state'],
            "pincode": data['pincode'],
            "dateUpdated": DateTime.now()
          });
        } else {
          await firebaseFirestore
              .collection(storeCollection)
              .doc(firebaseAuth.currentUser!.uid)
              .update({
            "shopName": data['shopName'],
            "bio": data['bio'],
            "accounHolderName": data['accounHolderName'],
            "accountNumber": data['accountNumber'],
            "ifscNumber": data['ifscNumber'],
            "address": data['address'],
            "city": data['city'],
            "state": data['state'],
            "pincode": data['pincode'],
            "dateUpdated": DateTime.now()
          });
        }
      }
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<bool> storeExists(String storeName) async => (await firebaseFirestore
              .collection(storeCollection)
              .where('uid', isNotEqualTo: firebaseAuth.currentUser!.uid)
              .where("shopName", isEqualTo: storeName)
              .get())
          .docs
          .isEmpty
      ? false
      : true;

  static Future<bool> sellerRegistered() async => (await firebaseFirestore
              .collection(storeCollection)
              .doc(firebaseAuth.currentUser!.uid)
              .get())
          .exists
      ? true
      : false;
}
