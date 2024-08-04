import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/seller/add_product.dart';
import 'package:pherico/screens/products/product_details.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/utils/product.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/widgets/global/rounded_image.dart';

class ClickyProductList extends StatelessWidget {
  const ClickyProductList({super.key});

  @override
  Widget build(BuildContext context) {
    List arguments = ModalRoute.of(context)!.settings.arguments as List;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Linked Products',
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: FirestoreListView<Map<String, dynamic>>(
          query: firebaseFirestore
              .collection(productsCollection)
              .where('productId', whereIn: arguments),
          loadingBuilder: (context) {
            return const MyProgressIndicator();
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          },
          emptyBuilder: (context) {
            return const Center(
              child: Text('No Product Found'),
            );
          },
          itemBuilder: (context, snapshot) {
            AddProduct product = AddProduct.fromMap(snapshot.data());
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ProductDetails(product),
                      transition: Transition.leftToRight);
                },
                child: Card(
                  elevation: 0,
                  color: cardBg,
                  shape: borderShape(),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RoundedImage(
                          image: product.imageUrl,
                          isNetwork: true,
                          width: 100,
                          height: 100,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0, left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '$rupeeSymbol${product.price}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      getbasePrice(
                                          product.price,
                                          product.discount,
                                          product.discountUnit),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationThickness: 2.85,
                                          decorationColor: Colors.black54),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  product.shortDesc,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
