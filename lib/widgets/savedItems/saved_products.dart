import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/cart.dart';
import 'package:pherico/models/seller/add_product.dart';
import 'package:pherico/resources/cart_resource.dart';
import 'package:pherico/screens/products/product_details.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/outlined_button.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/widgets/global/rounded_image.dart';
import 'package:uuid/uuid.dart';

class SavedProducts extends StatefulWidget {
  const SavedProducts({super.key});

  @override
  State<SavedProducts> createState() => _SavedProductsState();
}

class _SavedProductsState extends State<SavedProducts> {
  showToaster(String msg, bool isError) {
    context.showToast(msg, isError: isError);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: firebaseFirestore
          .collection(savedProductsCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyProgressIndicator();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('An error occured'),
          );
        } else {
          if (snapshot.hasData) {
            if (snapshot.data!.exists &&
                snapshot.data!.data()!["products"].length > 0) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: firebaseFirestore
                    .collection(productsCollection)
                    .where('productId',
                        whereIn: snapshot.data!.data()!["products"])
                    .snapshots(),
                builder: (ctx, snapshot2) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const MyProgressIndicator();
                  } else {
                    if (snapshot2.hasData) {
                      // var data = snapshot2.data!.docs;
                      return ListView.builder(
                        itemCount: snapshot.data!.data()!['products'].length,
                        itemBuilder: (ctx, i) {
                          AddProduct product =
                              AddProduct.fromJson(snapshot2.data!.docs[i]);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Card(
                              elevation: 1,
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            product.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: textColor_1),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  '$rupeeSymbol${product.price} ',
                                              style: TextStyle(
                                                  color: textColor_1,
                                                  fontWeight: FontWeight.w400),
                                              children: [
                                                TextSpan(
                                                  text: product.discountUnit ==
                                                          '%'
                                                      ? '${product.discount}% Off'
                                                      : '$rupeeSymbol${product.discount} Off',
                                                  style: TextStyle(
                                                    color: green,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Text(
                                            product.shortDesc,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          MyOutlinedButton(
                                            height: 34,
                                            buttonName: 'Add to cart',
                                            onPressed: () async {
                                              try {
                                                final cartId =
                                                    const Uuid().v1();
                                                Cart cart = Cart(
                                                    id: cartId,
                                                    userId: firebaseAuth
                                                        .currentUser!.uid,
                                                    productId:
                                                        product.productId,
                                                    quantity: 1,
                                                    size: product.sizes[0].size,
                                                    unit: product.sizes[0].unit,
                                                    color: product.color,
                                                    colorCode:
                                                        product.colorCode,
                                                    price: product.price,
                                                    discount: product.discount,
                                                    discountUnit:
                                                        product.discountUnit,
                                                    deliveryCharge:
                                                        product.deliveryCharge,
                                                    thumbnail: product.imageUrl,
                                                    productName: product.name);
                                                String res =
                                                    await CartResource()
                                                        .addToCart(cart);
                                                if (res == 'success') {
                                                  showToaster(
                                                      "Added into cart", false);
                                                } else {
                                                  showToaster(
                                                      "Failed to add", true);
                                                }
                                              } catch (error) {
                                                showToaster(
                                                    "Failed to add", true);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => ProductDetails(product),
                                            transition: Transition.rightToLeft);
                                      },
                                      child: RoundedImage(
                                        image: product.imageUrl,
                                        isNetwork: true,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('No products here'),
                      );
                    }
                  }
                },
              );
            } else {
              return const Center(
                child: Text('No products here'),
              );
            }
          } else {
            return const Center(
              child: Text('No products here'),
            );
          }
        }
      },
    );
  }
}
