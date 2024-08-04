import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/address.dart';
import 'package:uuid/uuid.dart';

class AddressMethods {
  Future<String> addAddress(Map data) async {
    String res = 'An error occures';
    print(res);
    try {
      if (data['id'] != 0) {
        await firebaseFirestore.collection('addresses').doc(data['id']).update({
          'fullName': data['fullName'],
          'phone': data['phone'],
          'flat': data['flat'],
          'area': data['area'],
          'city': data['city'],
          'state': data['state'],
          'pincode': data['pincode'],
        });
        res = 'update';
        return res;
      }
      String id = const Uuid().v1();
      Address address = Address(
        uid: firebaseAuth.currentUser!.uid,
        id: id,
        fullName: data['fullName'],
        phone: data['phone'],
        flat: data['flat'],
        area: data['area'],
        city: data['city'],
        state: data['state'],
        pincode: data['pincode'],
        isDefault: 0,
      );

      await firebaseFirestore
          .collection('addresses')
          .doc(id)
          .set(address.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> setDefaultAddress(String id) async {
    String res = 'An error occured';
    try {
      await firebaseFirestore
          .collection('addresses')
          .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
          .get()
          .then((value) async {
        for (var data in value.docs) {
          if (data['id'] == id) {
            await firebaseFirestore
                .collection('addresses')
                .doc(data['id'])
                .update({'isDefault': 1});
          } else {
            await firebaseFirestore
                .collection('addresses')
                .doc(data['id'])
                .update({'isDefault': 0});
          }
        }
        res = 'success';
        return value;
      }, onError: (err) {
        res = err.toString();
        return res;
      });
    } catch (error) {
      res = 'Something went wrong.';
    }
    return res;
  }

  Future<String> deleteAddress(String id) async {
    String res = 'An error occured';
    try {
      await firebaseFirestore.collection('addresses').doc(id).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getDefaultAddress() async {
    return firebaseFirestore
        .collection(addressesCollection)
        .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
        .where('isDefault', isEqualTo: 1)
        .limit(1)
        .get();
  }
}
