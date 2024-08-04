import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CategoryModel with ChangeNotifier {
  final String id;
  final String name;
  final String image;
  final bool status;

  CategoryModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.status});

  Map<String, dynamic> toJson() =>
      {"title": name, "image": image, "id": id, "status": status};

  static CategoryModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CategoryModel(
        name: snapshot['name'],
        image: snapshot['image'],
        id: snapshot['id'],
        status: snapshot["status"]);
  }
}
