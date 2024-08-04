import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/widgets/buttons/outlined_button.dart';
import 'package:pherico/widgets/global/rounded_image.dart';

class CancelledOrder extends StatelessWidget {
  const CancelledOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (ctx, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Woman Kurta',
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
                        Row(
                          children: [
                            const Text('Sold by:'),
                            TextButton(
                                clipBehavior: Clip.none,
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  '@Seller',
                                  style: TextStyle(color: gradient1),
                                )),
                          ],
                        ),
                        const Text(
                          'Cancelled on:25/12/202',
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        MyOutlinedButton(
                            buttonName: 'details', onPressed: () {}),
                      ],
                    ),
                    const RoundedImage(
                        image: 'assets/images/products/girl_top.jpg')
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
