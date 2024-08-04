import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/helpers/chat_time_formatter.dart';
import 'package:pherico/models/seller/ordered_product.dart';
import 'package:pherico/models/seller/orders.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/my_bottom_sheet.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/widgets/global/rounded_image.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class PendingOrderDetails extends StatelessWidget {
  const PendingOrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    String docId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppbar(
          onPressed: () {
            Get.back();
          },
          title: 'Orders',
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future:
              firebaseFirestore.collection(ordersCollection).doc(docId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MyProgressIndicator();
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.exists) {
                Orders order = Orders.fromJson(snapshot.data!.data()!);
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            shippingDetails(context, order),
                            const SizedBox(
                              height: 12,
                            ),
                            productDetails(context, order.docId),
                            const SizedBox(
                              height: 12,
                            ),
                            billingDetails(context, order),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: MediaQuery.of(context).size.width * 0.1),
                      child: GradientElevatedButton(
                        buttonName: 'Confirm & Ship',
                        onPressed: () {
                          showModalBottomSheet(
                            shape: borderShape(),
                            context: context,
                            builder: (context) {
                              return floatingMenu();
                            },
                          );
                        },
                        height: 50,
                      ),
                    )
                  ],
                );
              } else {
                return const Center(
                  child: Text('No data found'),
                );
              }
            } else {
              return const Center(
                child: Text('No data found'),
              );
            }
          },
        ),
      ),
    );
  }

  shippingDetails(BuildContext context, Orders order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: borderShape(radius: 0),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: MediaQuery.of(context).size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Shipping Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              RichText(
                text: TextSpan(
                  text: 'Name:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: textColor_1),
                  children: [
                    TextSpan(
                      text: order.shippingName,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Address:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: textColor_1),
                  children: [
                    TextSpan(
                      text: order.shippingAddress,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Pin:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: textColor_1),
                  children: [
                    TextSpan(
                      text: order.shippingPincode,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Phone:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: textColor_1),
                  children: [
                    TextSpan(
                      text: order.shippingPhone,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Received:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: textColor_1),
                  children: [
                    TextSpan(
                      text: ChatTimeFormatter.getFormattedDateTime(
                          context, order.received),
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
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

  billingDetails(BuildContext context, Orders order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: borderShape(radius: 0),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: MediaQuery.of(context).size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Billing Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              RichText(
                text: TextSpan(
                  text: 'Name:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: textColor_1),
                  children: [
                    TextSpan(
                        text: order.billingName,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Address:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: textColor_1),
                  children: [
                    TextSpan(
                        text: order.billingAddress,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Pin:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: textColor_1),
                  children: [
                    TextSpan(
                      text: order.billingPincode,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Phone:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: textColor_1),
                  children: [
                    TextSpan(
                      text: order.billingPhone,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
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

  productDetails(BuildContext context, String documentId) {
    return Column(
      children: [
        Card(
          elevation: 1,
          shape: borderShape(radius: 0),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.only(
                top: 12.0,
                bottom: 16,
                left: MediaQuery.of(context).size.width * 0.03,
                right: MediaQuery.of(context).size.width * 0.03),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Product Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: FirestoreListView<Map<String, dynamic>>(
                    query: firebaseFirestore
                        .collection(ordersCollection)
                        .doc(documentId)
                        .collection(productsCollection),
                    emptyBuilder: (context) {
                      return const Center(
                        child: Text('Enable to get products'),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text('Enable to get products'),
                      );
                    },
                    loadingBuilder: (context) {
                      return const MyProgressIndicator();
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, snapshot) {
                      OrderedProduct product =
                          OrderedProduct.fromJson(snapshot.data());
                      return productTile(product, context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        downloadInvoice(context),
        const SizedBox(
          height: 12,
        ),
        priceDetails(context),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget productTile(OrderedProduct orderedProduct, BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: HexColor('#EBFFD7'),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {},
                  child: RoundedImage(
                    image: sellerDefaultCover,
                    isNetwork: true,
                    radius: 50,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderedProduct.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: greyScale,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "Qty: ${orderedProduct.qty}",
                    style: TextStyle(color: greyScale, fontSize: 14),
                    children: [
                      TextSpan(
                        text:
                            ', Cost:$rupeeSymbol${orderedProduct.sellingPrice}',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: greyScale),
                      )
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "Size: ${orderedProduct.size}",
                    style: TextStyle(color: greyScale, fontSize: 14),
                    children: [
                      TextSpan(
                        text: ', Color:${orderedProduct.color}',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: greyScale),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          child: Divider(
            thickness: 0.5,
          ),
        ),
      ],
    );
  }

  priceDetails(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () {},
        child: Card(
          shape: borderShape(radius: 0),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: MediaQuery.of(context).size.width * 0.06),
            child: Column(
              children: [
                const Text(
                  'Price Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                priceList('Shoes Nike', 3000),
                priceList('Tshirt', 300),
                priceList('Shirt', 450),
                const Divider(
                  thickness: 1,
                ),
                priceList('Total', 3750, isBold: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  priceList(String label, int price, {isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                color: textColor_1,
                fontSize: 15,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            '${rupeeSymbol}$price',
            style: TextStyle(
                color: textColor_1,
                fontSize: 15,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  downloadInvoice(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () {},
        child: Card(
          shape: borderShape(radius: 0),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: MediaQuery.of(context).size.width * 0.06),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Download invoice',
                  style: TextStyle(color: textColor_1, fontSize: 15),
                ),
                const SizedBox(
                  width: 8,
                ),
                CircleAvatar(
                  backgroundColor: HexColor('#EBEBEB'),
                  child: const Icon(
                    Icons.receipt_long_outlined,
                    color: Colors.black,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget floatingMenu() {
    return const MyBottomSheet(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'E Kart',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Delhivery',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Blue Dart',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'FedEx',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
