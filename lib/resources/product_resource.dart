import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/seller/add_product.dart';
import 'package:pherico/models/seller/product_variant_model.dart';
import 'package:pherico/resources/storage_methods.dart';
import 'package:pherico/utils/pick_image.dart';
import 'package:slugify/slugify.dart';
import 'package:uuid/uuid.dart';

Future<String> updateStock(String productId, int stock) async {
  String res = 'An error occured';
  try {
    await firebaseFirestore
        .collection(productsCollection)
        .doc(productId)
        .update({'stocks': stock});
    res = 'success';
  } catch (error) {
    res = 'failed';
  }
  return res;
}

Future<DocumentSnapshot<Map<String, dynamic>>> getProductDetails(
    String productId) async {
  return await firebaseFirestore.collection('products').doc(productId).get();
}

Future<QuerySnapshot<Map<String, dynamic>>> getProductRating(
    String productId) async {
  return firebaseFirestore
      .collection(productsCollection)
      .doc(productId)
      .collection(ratingsCollection)
      .get();
}

Future<String> postProduct(AddProduct data) async {
  String res = 'An error occured';
  try {
    List<String> imageUrls = [];
    for (var image in data.images) {
      Uint8List imageData = await compressImage(image);
      String child = const Uuid().v1();
      String imageUrl = await uploadImage(child, imageData, 'products');
      imageUrls.add(imageUrl);
    }

    List<ProductVariantModel> productVariants = [];
    if (data.variants.isNotEmpty) {
      for (var variants in data.variants) {
        List<String> imageUrls = [];
        for (var item in variants.images) {
          Uint8List imageData = await compressImage(item);
          String child = const Uuid().v1();
          String imageUrl = await uploadImage(child, imageData, 'products');
          imageUrls.add(imageUrl);
        }

        productVariants.add(
          ProductVariantModel(
            color: variants.color,
            colorCode: variants.colorCode,
            price: variants.price,
            stocks: variants.stocks,
            discount: variants.discount,
            discountUnit: variants.discountUnit,
            size: variants.size,
            images: imageUrls,
          ),
        );
      }
    }

    AddProduct product = AddProduct(
      name: data.name,
      userId: firebaseAuth.currentUser!.uid,
      categoryId: data.categoryId,
      price: data.price,
      color: data.color,
      colorCode: data.colorCode,
      sizes: data.sizes,
      discount: data.discount,
      discountUnit: data.discountUnit,
      shortDesc: data.shortDesc,
      longDesc: data.longDesc,
      imageUrl: imageUrls.first,
      productId: data.productId,
      images: imageUrls,
      isCod: data.isCod,
      policy: data.policy,
      deliveryCharge: data.deliveryCharge,
      stocks: data.stocks,
      orders: 0,
      subcategoryId: data.categoryId,
      specification: data.specification,
      highlights: data.specification,
      slug: slugify(data.slug, delimiter: '_'),
      isWarranty: data.isWarranty,
      warranty: data.warranty,
      brand: data.brand,
      model: data.model,
      variants: productVariants,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );

    await firebaseFirestore
        .collection(productsCollection)
        .doc(data.productId)
        .set(product.toJson());

    res = "success";
  } catch (err) {
    print(err.toString());
    res = err.toString();
  }
  return res;
}
