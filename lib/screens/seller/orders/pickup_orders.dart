import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/config/orders_status.dart';
import 'package:pherico/helpers/chat_time_formatter.dart';
import 'package:pherico/models/seller/orders.dart';
import 'package:pherico/screens/seller/orders/pending_order_details.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/widgets/buttons/outlined_button.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/my_bottom_sheet.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';

class PickupOrders extends StatefulWidget {
  const PickupOrders({super.key});

  @override
  State<PickupOrders> createState() => _PickupOrdersState();
}

class _PickupOrdersState extends State<PickupOrders> {
  final Query<Map<String, dynamic>> _query = firebaseFirestore
      .collection(ordersCollection)
      .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
      .where('status', isEqualTo: OrderStatus.pick);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppbar(
          onPressed: () {
            Get.back();
          },
          title: 'On Pickup',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: MediaQuery.of(context).size.width * 0.04),
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
            query: _query,
            itemBuilder: (context, snapshot) {
              Orders order = Orders.fromJson(snapshot.data());
              return orderList(order, context);
            },
          ),
        ),
      ),
    );
  }

  Widget orderList(Orders order, BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 1,
          shape: borderShape(),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    RichText(
                      text: TextSpan(
                        text: "Items: 10",
                        style: TextStyle(color: greyScale, fontSize: 14),
                        children: [
                          TextSpan(
                            text: ', Weight:${order.weight}',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: greyScale),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Placed:${ChatTimeFormatter.getFormattedDateTime(context, order.received)}',
                      style: TextStyle(color: greyScale, fontSize: 14),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: bottomSheetBorder,
                      builder: (ctx) {
                        return bottomSheet(order);
                      },
                    );
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_down_sharp,
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget bottomSheet(Orders order) {
    return MyBottomSheet(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
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
                      Text(
                        'Weight : ${order.weight}',
                        style: TextStyle(color: labelGreyColor),
                      ),
                      Text(
                        'Name : ${order.shippingName}',
                        overflow: TextOverflow.visible,
                        style: TextStyle(color: labelGreyColor),
                      ),
                      Text(
                        'Shipping : ${order.shippingAddress} ${order.shippingPincode}',
                        overflow: TextOverflow.visible,
                        style: TextStyle(color: labelGreyColor),
                      ),
                      Text(
                        'Phone : ${order.shippingPhone}',
                        overflow: TextOverflow.visible,
                        style: TextStyle(color: labelGreyColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  children: [
                    Text(
                      'Pickup time',
                      style: TextStyle(fontSize: 12, color: greyScale),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: black, width: 1.2),
                      ),
                      child: SvgPicture.asset(
                        'assets/images/icons/calendar.svg',
                        height: 34,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      ChatTimeFormatter.formattedTime(context, order.pick),
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 14,
                          color: greyScale,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ChatTimeFormatter.formattedDate(context, order.pick),
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 14,
                          color: greyScale,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              height: 38,
              thickness: 1.2,
            ),
            MyOutlinedButton(
              onPressed: () {
                Get.to(() => const PendingOrderDetails(),
                    arguments: order.docId, transition: Transition.rightToLeft);
              },
              height: 46,
              width: MediaQuery.of(context).size.width * 0.8,
              buttonName: 'View Details',
            ),
          ],
        ),
      ),
    );
  }
}
