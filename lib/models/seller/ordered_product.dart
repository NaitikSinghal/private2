import 'package:cloud_firestore/cloud_firestore.dart';

class OrderedProduct {
  late final String name;
  late final int qty;
  late final String size;
  late final String color;
  late final String model;
  late final int sellingPrice;
  late final int basePrice;
  late final int discount;

  OrderedProduct(
      {required this.name,
      required this.qty,
      required this.size,
      required this.color,
      required this.model,
      required this.sellingPrice,
      required this.basePrice,
      required this.discount});

  factory OrderedProduct.fromJson(Map<String, dynamic> json) {
    return OrderedProduct(
        name: json['name'],
        qty: json['qty'],
        size: json['size'],
        color: json['color'],
        model: json['model'],
        sellingPrice: json['sellingPrice'],
        basePrice: json['basePrice'],
        discount: json['discount']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['qty'] = qty;
    data['size'] = size;
    data['color'] = color;
    data['model'] = model;
    data['sellingPrice'] = sellingPrice;
    data['basePrice'] = basePrice;
    data['discount'] = discount;
    return data;
  }

  static OrderedProduct fromMap(DocumentSnapshot snapshot) {
    var json = snapshot.data() as Map<String, dynamic>;
    return OrderedProduct(
        name: json['name'],
        qty: json['qty'],
        size: json['size'],
        color: json['color'],
        model: json['model'],
        sellingPrice: json['sellingPrice'],
        basePrice: json['basePrice'],
        discount: json['discount']);
  }
}
