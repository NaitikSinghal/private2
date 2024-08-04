import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/rounded_image.dart';
import 'package:pherico/widgets/global/shadow_box_no_radius.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class OrderDetails extends StatelessWidget {
  static const routeName = '/order-details';
  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Order Details',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadowBoxNoRadius(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.07,
                      vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Shoes',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: textColor_1),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          const Text(
                            'Size:XL,Color:black',
                          ),
                          RichText(
                            text: TextSpan(
                                text: '${rupeeSymbol}1200 ',
                                style: TextStyle(
                                    color: textColor_1,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                children: const [
                                  TextSpan(
                                    text: '${rupeeSymbol}1399',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 2.85,
                                        decorationColor: Colors.black54),
                                  )
                                ]),
                          ),
                          const Text(
                            'short desc here...',
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/product-details', arguments: 1);
                        },
                        child: const RoundedImage(
                          image:
                              'https://thumbs.dreamstime.com/b/blue-shoes-29507491.jpg',
                          isNetwork: true,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ShadowBoxNoRadius(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.07,
                      16,
                      MediaQuery.of(context).size.width * 0.07,
                      0),
                  child: Column(
                    children: [
                      orderStatus('Order placed', '10 Oct 202', true, false),
                      orderStatus('Order confirmed', '12 Oct 202', true, false),
                      orderStatus('Order shipped', '14 Oct 202', true, false),
                      orderStatus(
                          'Out for delivery', '16 Oct 202', false, false),
                      orderStatus('Delivered', '18 Oct 202', false, true),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ShadowBoxNoRadius(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: MediaQuery.of(context).size.width * 0.07),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          'Price details',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      priceDetails('Price', 1200, false),
                      priceDetails('Shipping', 29, false),
                      priceDetails('Subtotal', 1229, false),
                      priceDetails('Discount', -100, false),
                      const Divider(
                        thickness: 1,
                      ),
                      priceDetails('Total', 1000, true),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ShadowBoxNoRadius(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: MediaQuery.of(context).size.width * 0.07),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RichText(
                      text: TextSpan(
                        text: 'Do you want to ',
                        style: TextStyle(color: textColor_1, fontSize: 15),
                        children: [
                          TextSpan(
                            text: 'Cancel ',
                            style: TextStyle(color: gradient1, fontSize: 15),
                            children: [
                              TextSpan(
                                text: 'this order?',
                                style:
                                    TextStyle(color: textColor_1, fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ShadowBoxNoRadius(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 22,
                        horizontal: MediaQuery.of(context).size.width * 0.07),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: HexColor('#EBEBEB'),
                              child: const Icon(
                                Icons.call_outlined,
                                color: Colors.black,
                                size: 26,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Contact Us',
                              style: TextStyle(color: textColor_1),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: HexColor('#EBEBEB'),
                              child: const Icon(
                                Icons.help_outline,
                                color: Colors.black,
                                size: 26,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Need help?',
                              style: TextStyle(color: textColor_1),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 12,
              ),
              ShadowBoxNoRadius(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: MediaQuery.of(context).size.width * 0.07),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Download invoice',
                        style: TextStyle(color: textColor_1, fontSize: 16),
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
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderStatus(String left, String right, bool isActive, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: Stack(
                children: [
                  Icon(
                    Icons.circle,
                    size: 14,
                    color: isActive ? gradient1 : Colors.grey,
                  ),
                  Positioned(
                    left: 6.5,
                    top: 5,
                    child: Container(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      width: 1.5,
                      height: isLast ? 0 : 50,
                      decoration: BoxDecoration(
                        color: isActive ? gradient1 : Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              left,
              style: TextStyle(
                  color: isActive ? textColor : Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          right,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget priceDetails(String title, int amount, bool isBold) {
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
            '$rupeeSymbol$amount',
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
