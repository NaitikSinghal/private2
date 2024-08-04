import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/config/orders_status.dart';
import 'package:pherico/helpers/chat_time_formatter.dart';
import 'package:pherico/models/seller/orders.dart';
import 'package:pherico/screens/seller/orders/pending_order_details.dart';
import 'package:pherico/screens/seller/orders/pickup_orders.dart';
import 'package:pherico/screens/seller/orders/transit_orders.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/widgets/global/rounded_image.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class ReceivedOrders extends StatelessWidget {
  const ReceivedOrders({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topMenus(context),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Pending orders',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: FirestoreListView<Map<String, dynamic>>(
                  loadingBuilder: (context) {
                    return const MyProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  },
                  emptyBuilder: (context) {
                    return const Center(
                      child: Text('No orders found'),
                    );
                  },
                  query: firebaseFirestore
                      .collection(ordersCollection)
                      .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
                      .where('status', isEqualTo: OrderStatus.pending),
                  itemBuilder: (context, snapshot) {
                    Orders order = Orders.fromJson(snapshot.data());
                    return orderList(order, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderList(Orders order, BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(() => const PendingOrderDetails(),
                transition: Transition.leftToRight, arguments: order.docId);
          },
          child: Card(
            elevation: 1,
            shape: borderShape(),
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: HexColor('#EBFFD7'),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: const RoundedImage(
                          image:
                              'https://rukminim1.flixcart.com/image/612/612/l51d30w0/shoe/z/w/c/10-mrj1914-10-aadi-white-black-red-original-imagft9k9hydnfjp.jpeg?q=70',
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
                        'Order #${order.orderId}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: greyScale),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Items: ",
                              style: TextStyle(color: greyScale, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: '10',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: greyScale),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          RichText(
                            text: TextSpan(
                              text: "Cost: ",
                              style: TextStyle(
                                color: greyScale,
                                fontSize: 13,
                              ),
                              children: [
                                TextSpan(
                                  text: '${rupeeSymbol}10',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: greyScale),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Received:${ChatTimeFormatter.getFormattedDateTime(context, order.received)}',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget topMenus(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            topButton(
              'On pickup',
              'assets/images/icons/pickup.svg',
              context,
              () {
                Get.to(() => const PickupOrders(),
                    transition: Transition.rightToLeft);
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.035,
            ),
            topButton(
              'In transit',
              'assets/images/icons/transit.svg',
              context,
              () {
                Get.to(() => TransitOrders(),
                    transition: Transition.rightToLeft);
              },
            )
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            topButton('Delivered', 'assets/images/icons/tick-circle.svg',
                context, () {},
                size: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.035,
            ),
            topButton(
              'Cancelled',
              'assets/images/icons/cross_circle.svg',
              context,
              () {},
              size: 30,
            ),
          ],
        )
      ],
    );
  }

  Widget topButton(
      String label, String path, BuildContext context, VoidCallback onTap,
      {int size = 24}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: borderShape(radius: 12),
        margin: EdgeInsets.zero,
        child: Container(
          width: MediaQuery.of(context).size.width / 2 - 26,
          padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: MediaQuery.of(context).size.width * 0.03),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: HexColor('#F4F7FE'),
                child: SvgPicture.asset(
                  path,
                  height: size.toDouble(),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
