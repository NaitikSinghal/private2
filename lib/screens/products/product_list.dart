import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/seller/add_product.dart';
import 'package:pherico/screens/products/product_details.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/widgets/global/rounded_image.dart';

class ProductList extends StatefulWidget {
  static const routeName = '/product-list';
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    final categoryId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Products',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: FirestoreListView<Map<String, dynamic>>(
          pageSize: 15,
          query: firebaseFirestore
              .collection(productsCollection)
              .where('categoryId', isEqualTo: categoryId),
          loadingBuilder: (context) {
            return const Center(child: MyProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          },
          emptyBuilder: (context) {
            return const Center(
              child: Text('No products found'),
            );
          },
          itemBuilder: (context, snapshot) {
            AddProduct product = AddProduct.fromMap(snapshot.data());
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ProductDetails(product),
                      transition: Transition.rightToLeft);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  color: cardBg,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RoundedImage(
                          radius: 12,
                          height: 100,
                          width: 100,
                          image: product.imageUrl,
                          isNetwork: true,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '\u{20B9}${product.discount}',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    '\u{20B9}${product.price}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 2.85,
                                      decorationColor: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              const Text(
                                'Size:XL, black',
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
