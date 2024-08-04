import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String desc;
  final String longDesc;
  final double price;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.longDesc,
    required this.price,
    required this.images,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        "name": name,
        "desc": desc,
        "longDesc": longDesc,
        "price": price,
        'images': images
      };

  static Product fromJson(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    return Product(
        id: snap['id'],
        name: snap['name'],
        desc: snap['desc'],
        longDesc: snap['longDesc'],
        price: snap['price'],
        images: snap['images']);
  }
}
