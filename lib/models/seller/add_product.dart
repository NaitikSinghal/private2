import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/models/seller/product_variant_model.dart';
import 'package:pherico/models/size_option.dart';

class AddProduct with ChangeNotifier {
  final String name;
  final String categoryId;
  final String userId;
  final int price;
  final int discount;
  final String discountUnit;
  final String shortDesc;
  final String color;
  final String colorCode;
  final List<SizeModel> sizes;
  final String longDesc;
  final String imageUrl;
  final String productId;
  final String subcategoryId;
  final String specification;
  final String highlights;
  final String slug;
  final bool isWarranty;
  final String warranty;
  final String brand;
  final String model;
  final List images;
  final bool isCod;
  final int policy;
  final int deliveryCharge;
  final int stocks;
  final List<ProductVariantModel> variants;
  final int orders;
  final createdAt;
  final updatedAt;

  AddProduct({
    required this.name,
    required this.userId,
    required this.categoryId,
    required this.price,
    required this.discount,
    required this.discountUnit,
    required this.shortDesc,
    required this.longDesc,
    required this.imageUrl,
    required this.productId,
    required this.images,
    required this.isCod,
    required this.policy,
    required this.deliveryCharge,
    required this.stocks,
    required this.variants,
    required this.orders,
    required this.createdAt,
    required this.updatedAt,
    required this.subcategoryId,
    required this.specification,
    required this.highlights,
    required this.slug,
    required this.isWarranty,
    required this.warranty,
    required this.brand,
    required this.color,
    required this.colorCode,
    required this.sizes,
    required this.model,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "userId": userId,
        "categoryId": categoryId,
        "price": price,
        "discount": discount,
        "shortDesc": shortDesc,
        "longDesc": longDesc,
        "imageUrl": imageUrl,
        "color": color,
        "colorCode": colorCode,
        "sizes": sizes.map((e) => e.toJson()).toList(),
        "productId": productId,
        "images": images,
        "isCod": isCod,
        "policy": policy,
        "stocks": stocks,
        "deliveryCharge": deliveryCharge,
        "variants": variants.map((e) => e.toJson()).toList(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "discountUnit": discountUnit,
        "orders": orders,
        "subcategoryId": subcategoryId,
        "specification": specification,
        "highlights": highlights,
        "slug": slug,
        "isWarranty": isWarranty,
        "warranty": warranty,
        "brand": brand,
        "model": model
      };

  factory AddProduct.fromMap(Map<String, dynamic> json) {
    List<dynamic> variantList = json['variants'] ?? [];
    final list =
        variantList.map((e) => ProductVariantModel.fromMap(e)).toList();

    List<dynamic> sizeList = json['sizes'] ?? [];
    final sizes = sizeList.map((e) => SizeModel.fromMap(e)).toList();
    return AddProduct(
      name: json['name'],
      categoryId: json["categoryId"],
      userId: json["userId"],
      price: json["price"],
      discount: json["discount"],
      shortDesc: json["shortDesc"],
      longDesc: json["longDesc"],
      imageUrl: json["imageUrl"],
      productId: json["productId"],
      images: json["images"],
      isCod: json["isCod"],
      policy: json["policy"],
      stocks: json["stocks"],
      color: json["color"] ?? '',
      colorCode: json["colorCode"] ?? '',
      sizes: sizes,
      deliveryCharge: json["deliveryCharge"],
      variants: list,
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      discountUnit: json['discountUnit'],
      orders: json['orders'],
      subcategoryId: json['subcategoryId'] ?? '',
      specification: json['specification'] ?? '',
      highlights: json['highlights'] ?? '',
      slug: json['slug'] ?? '',
      isWarranty: json['isWarranty'],
      warranty: json['warranty'],
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
    );
  }

  static AddProduct fromJson(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    List<dynamic> variantList = snap['variants'];
    final List<ProductVariantModel> list;
    if (variantList.isNotEmpty) {
      list = variantList.map((e) => ProductVariantModel.fromMap(e)).toList();
    } else {
      list = [];
    }

    List<dynamic> sizeList = snap['sizes'];
    final List<SizeModel> sizes;
    if (sizeList.isNotEmpty) {
      sizes = sizeList.map((e) => SizeModel.fromMap(e)).toList();
    } else {
      sizes = [];
    }

    return AddProduct(
        name: snap['name'],
        userId: snap['userId'],
        categoryId: snap['categoryId'],
        price: snap['price'],
        discount: snap['discount'],
        shortDesc: snap['shortDesc'],
        longDesc: snap['longDesc'],
        imageUrl: snap['imageUrl'],
        productId: snap['productId'],
        color: snap['color'] ?? '',
        colorCode: snap['colorCode'] ?? '',
        sizes: sizes,
        images: snap['images'],
        isCod: snap['isCod'],
        policy: snap['policy'],
        stocks: snap['stocks'],
        variants: list,
        deliveryCharge: snap['deliveryCharge'],
        createdAt: snap['createdAt'],
        updatedAt: snap['updatedAt'],
        discountUnit: snap['discountUnit'],
        orders: snap['orders'],
        subcategoryId: snap['subcategoryId'],
        specification: snap['specification'],
        highlights: snap['highlights'],
        slug: snap['slug'],
        isWarranty: snap['isWarranty'],
        warranty: snap['warranty'],
        brand: snap['brand'],
        model: snap['model']);
  }
}
