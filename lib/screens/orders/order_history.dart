import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/screens/orders/order_details.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/rounded_image.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class OrderHistory extends StatelessWidget {
  static const routeName = '/orders';
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: CustomAppbar(
            title: 'My Order',
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: Column(
              children: [
                Card(
                  elevation: 1,
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.all(8),
                    maintainState: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    iconColor: gradient1,
                    collapsedIconColor: gradient1,
                    title: tileTitle(context),
                    children: [
                      Divider(
                        color: HexColor('EBEBEB'),
                        thickness: 1,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        child: Column(
                          children: [
                            tileBody('Price(8items)', 1420, false),
                            tileBody('Shipping', 20, false),
                            tileBody('Discount', 220, false),
                            tileBody('Subtotal', 1220, false),
                            tileBody('Total', 1220, true),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Card(
                  elevation: 1,
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.all(8),
                    maintainState: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    iconColor: gradient1,
                    collapsedIconColor: gradient1,
                    title: tileTitle(context),
                    children: [
                      Divider(
                        color: HexColor('EBEBEB'),
                        thickness: 1,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        child: Column(
                          children: [
                            tileBody('Price(8items)', 1420, false),
                            tileBody('Shipping', 20, false),
                            tileBody('Discount', 220, false),
                            tileBody('Subtotal', 1220, false),
                            tileBody('Total', 1220, true),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tileTitle(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: HexColor('#EBFFD7'),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => const OrderDetails(),
                    transition: Transition.leftToRight);
              },
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
              'Order #1234',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14, color: greyScale),
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
            const Text(
              'Ordered: 20 sep 2022',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(
              height: 4,
            ),
            RichText(
              text: const TextSpan(
                text: "Status: ",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: 'Delivered',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget tileBody(String title, int amount, bool isBold) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            '${rupeeSymbol}$amount',
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
