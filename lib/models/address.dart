import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  String uid;
  String id;
  String fullName;
  String phone;
  String flat;
  String area;
  String city;
  String state;
  String pincode;
  int isDefault;

  Address(
      {required this.uid,
      required this.id,
      required this.fullName,
      required this.phone,
      required this.flat,
      required this.area,
      required this.city,
      required this.state,
      required this.pincode,
      required this.isDefault});

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "id": id,
        "fullName": fullName,
        "phone": phone,
        "flat": flat,
        "area": area,
        "city": city,
        "state": state,
        "pincode": pincode,
        "isDefault": isDefault
      };

  static Address fromSnap(DocumentSnapshot snap) {
    var snapshop = snap.data() as Map<String, dynamic>;

    return Address(
        uid: snapshop['uid'],
        id: snapshop['id'],
        fullName: snapshop['fullName'],
        phone: snapshop['phone'],
        flat: snapshop['flat'],
        area: snapshop['area'],
        city: snapshop['city'],
        state: snapshop['state'],
        pincode: snapshop['pincode'],
        isDefault: snapshop['isDefault']);
  }

  static Address fromMap(Map<String, dynamic> snap) {
    return Address(
        uid: snap['uid'],
        id: snap['id'],
        fullName: snap['fullName'],
        phone: snap['phone'],
        flat: snap['flat'],
        area: snap['area'],
        city: snap['city'],
        state: snap['state'],
        pincode: snap['pincode'],
        isDefault: snap['isDefault']);
  }
}
