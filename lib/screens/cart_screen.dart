import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/seller/add_product.dart';
import 'package:pherico/screens/checkout.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'package:pherico/widgets/cart/cart_amount.dart';
import 'package:pherico/widgets/cart/empty_cart.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/error_widget.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import '../widgets/cart/cart_content.dart';
import 'package:pherico/widgets/global/dotted_divider.dart';
import 'package:pherico/models/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firebaseFirestore
              .collection(cartCollection)
              .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MyProgressIndicator();
            } else if (snapshot.hasError) {
              return const SomethingWentWrongError();
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        key: Key(snapshot.data!.docs.length.toString()),
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx, i) {
                          Cart cart = Cart.fromSnap(snapshot.data!.docs[i]);
                          return CartContent(cart: cart);
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(24.0),
                    //   child: Column(
                    //     children: [
                    //       CartAmount(
                    //           title: 'Sub total($items items)',
                    //           amount: baseAmount.toDouble()),
                    //       const SizedBox(
                    //         height: 10,
                    //       ),
                    //       const CartAmount(title: 'Shipping', amount: 20.0),
                    //       const SizedBox(
                    //         height: 10,
                    //       ),
                    //       CartAmount(
                    //           title: 'Discount',
                    //           amount: baseAmount.toDouble() -
                    //               sellingAmount.toDouble()),
                    //       const SizedBox(
                    //         height: 10,
                    //       ),
                    //       const DottedDivider(),
                    //       const SizedBox(
                    //         height: 10,
                    //       ),
                    //       CartAmount(
                    //           title: 'Total', amount: sellingAmount.toDouble()),
                    //       const SizedBox(
                    //         height: 12,
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //           horizontal: 16,
                    //         ),
                    //         child: GradientElevatedButton(
                    //           buttonName: 'Checkout',
                    //           height: 45,
                    //           onPressed: () {
                    //             Get.to(
                    //               () => const Checkout(),
                    //               transition: Transition.rightToLeft,
                    //             );
                    //           },
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              );
            } else {
              return const Align(
                alignment: Alignment.center,
                child: EmptyCart(),
              );
            }
          },
        ),
      ),
    );
  }
}
