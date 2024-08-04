import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Seller with ChangeNotifier {
  late final String shopName;
  late final String cover;
  late final String profile;
  late final String bio;
  late final String categoryId;
  late final String uid;
  late final String accounHolderName;
  late final String accountNumber;
  late final String ifscNumber;
  late final String address;
  late final String city;
  late final String state;
  late final String pincode;
  late final String landmark;
  late final String addressType;
  late final List followers;
  late final List following;
  late final int isActive;
  late final bool isOnline;
  late final String lastActive;
  late final String pushToken;
  late final dateCreated;
  late final dateUpdated;

  Seller(
      {required this.shopName,
      required this.cover,
      required this.profile,
      required this.bio,
      required this.categoryId,
      required this.uid,
      required this.accounHolderName,
      required this.accountNumber,
      required this.ifscNumber,
      required this.address,
      required this.city,
      required this.state,
      required this.pincode,
      required this.landmark,
      required this.addressType,
      required this.followers,
      required this.following,
      required this.isActive,
      required this.isOnline,
      required this.lastActive,
      required this.pushToken,
      required this.dateCreated,
      required this.dateUpdated});

  Map<String, dynamic> toJson() => {
        "shopName": shopName,
        "cover": cover,
        "profile": profile,
        "bio": bio,
        "categoryId": categoryId,
        "uid": uid,
        "accounHolderName": accounHolderName,
        "accountNumber": accountNumber,
        "ifscNumber": ifscNumber,
        "address": address,
        "city": city,
        "state": state,
        "pincode": pincode,
        "landmark": landmark,
        "addressType": addressType,
        "followers": followers,
        "following": following,
        "images": isActive,
        'isOnline': isOnline,
        'lastActive': lastActive,
        'pushToken': pushToken,
        "dateCreated": dateCreated,
        "dateUpdated": dateUpdated
      };

  Seller.fromMap(Map<String, dynamic> json) {
    shopName = json['shopName'];
    cover = json['cover'];
    profile = json['profile'];
    bio = json['bio'];
    categoryId = json['categoryId'];
    uid = json['uid'];
    accounHolderName = json['accounHolderName'];
    accountNumber = json['accountNumber'];
    ifscNumber = json['ifscNumber'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    landmark = json['landmark'];
    addressType = json['addressType'];
    followers = json['followers'];
    following = json['following'];
    isActive = json['isActive'];
    isOnline = json['isOnline'];
    pushToken = json['pushToken'];
    lastActive = json['lastActive'];
    dateCreated = json['dateCreated'];
    dateUpdated = json['dateUpdated'];
  }

  static Seller fromJson(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Seller(
        shopName: snap['shopName'],
        cover: snap['cover'],
        profile: snap['profile'],
        bio: snap['bio'],
        categoryId: snap['categoryId'],
        uid: snap['uid'],
        accounHolderName: snap['accounHolderName'],
        accountNumber: snap['accountNumber'],
        ifscNumber: snap['ifscNumber'],
        address: snap['address'],
        city: snap['city'],
        state: snap['state'],
        pincode: snap['pincode'],
        landmark: snap['landmark'],
        addressType: snap['addressType'],
        followers: snap['followers'],
        following: snap['following'],
        isActive: snap['isActive'],
        isOnline: snap['isOnline'],
        pushToken: snap['pushToken'],
        lastActive: snap['lastActive'],
        dateCreated: snap['dateCreated'],
        dateUpdated: snap['dateUpdated']);
  }
}
