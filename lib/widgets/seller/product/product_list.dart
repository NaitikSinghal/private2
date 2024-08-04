import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/seller/add_product.dart';
import 'package:pherico/screens/products/product_details.dart';
import 'package:pherico/utils/product.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/widgets/global/rounded_image.dart';

class ProductListSellerProfile extends StatefulWidget {
  final String uid;
  const ProductListSellerProfile({required this.uid, super.key});

  @override
  State<ProductListSellerProfile> createState() =>
      _ProductListSellerProfileState();
}

class _ProductListSellerProfileState extends State<ProductListSellerProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FirestoreListView<Map<String, dynamic>>(
              pageSize: 10,
              query: firebaseFirestore
                  .collection(productsCollection)
                  .where('userId', isEqualTo: widget.uid)
                  .orderBy('createdAt'),
              emptyBuilder: (context) {
                return const Center(
                  child: Text('No product found'),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              },
              loadingBuilder: (context) {
                return const MyProgressIndicator();
              },
              itemBuilder: (context, snapshot) {
                AddProduct product = AddProduct.fromMap(snapshot.data());
                return productList(product);
              }),
        ),
      ],
    );
  }

  productList(AddProduct product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      child: Card(
        color: cardBg,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => ProductDetails(product),
                    transition: Transition.rightToLeft,
                  );
                },
                child: RoundedImage(
                  image: product.imageUrl,
                  isNetwork: true,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: brownText,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Text(
                          '$rupeeSymbol${product.price}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${getDiscount(product.discount, product.discountUnit)}',
                          style: TextStyle(color: green),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      intToPolicy(product.policy),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      '${product.shortDesc} about the product and long text can be here',
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(color: greyText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
