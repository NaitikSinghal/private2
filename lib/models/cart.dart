import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  final String id;
  final String userId;
  late int quantity;
  final String productId;
  final String thumbnail;
  final String productName;
  final int price;
  final int discount;
  final int deliveryCharge;
  final String discountUnit;
  final String size;
  final String unit;
  final String color;
  final String colorCode;
  Cart({
    required this.id,
    required this.userId,
    required this.productId,
    required this.thumbnail,
    required this.quantity,
    required this.deliveryCharge,
    required this.productName,
    required this.size,
    required this.unit,
    required this.color,
    required this.colorCode,
    required this.price,
    required this.discount,
    required this.discountUnit,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "quantity": quantity,
        "productId": productId,
        "thumbnail": thumbnail,
        "productName": productName,
        "size": size,
        "unit": unit,
        "color": color,
        "colorCode": colorCode,
        "price": price,
        "discount": discount,
        "deliveryCharge": deliveryCharge,
        "discountUnit": discountUnit,
      };

  static Cart fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Cart(
      id: snapshot['id'],
      userId: snapshot['userId'],
      productId: snapshot['productId'],
      thumbnail: snapshot['thumbnail'],
      quantity: snapshot['quantity'],
      productName: snapshot['productName'],
      size: snapshot['size'],
      unit: snapshot['unit'],
      color: snapshot['color'],
      colorCode: snapshot['colorCode'],
      price: snapshot['price'],
      discount: snapshot['discount'],
      deliveryCharge: snapshot['deliveryCharge'],
      discountUnit: snapshot['discountUnit'],
    );
  }
}
