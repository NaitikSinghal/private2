import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pherico/models/size_option.dart';

class ProductVariantModel {
  final String color;
  final String colorCode;
  final int price;
  final int stocks;
  final int discount;
  final String discountUnit;
  final List<SizeModel> size;
  final List images;

  ProductVariantModel({
    required this.color,
    required this.colorCode,
    required this.price,
    required this.stocks,
    required this.discount,
    required this.discountUnit,
    required this.size,
    required this.images,
  });

  Map<String, dynamic> toJson() => {
        "color": color,
        "colorCode": colorCode,
        "price": price,
        "stocks": stocks,
        "discount": discount,
        "discountUnit": discountUnit,
        "size": size.map((e) => e.toJson()).toList(),
        "images": images,
      };

  static ProductVariantModel fromJson(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    List<dynamic> sizeList = snap['size'];
    final List<SizeModel> list;
    if (sizeList.isNotEmpty) {
      list = sizeList.map((e) => SizeModel.fromMap(e)).toList();
    } else {
      list = [];
    }
    return ProductVariantModel(
      color: snap['color'],
      colorCode: snap['colorCode'],
      price: snap['price'],
      stocks: snap['stocks'],
      discount: snap['discount'],
      discountUnit: snap['discountUnit'] ?? '',
      size: list,
      images: snap['images'],
    );
  }

  factory ProductVariantModel.fromMap(Map<String, dynamic> json) {
    List<dynamic> sizeList = json['size'] ?? [];
    final list = sizeList.map((e) => SizeModel.fromMap(e)).toList();
    return ProductVariantModel(
      color: json["color"],
      colorCode: json["colorCode"],
      price: json["price"],
      stocks: json["stocks"],
      discount: json["discount"],
      discountUnit: json["discountUnit"] ?? '',
      size: list,
      images: json["images"],
    );
  }
}
