import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/models/seller/seller.dart';
import 'package:pherico/screens/chats/chat.dart';
import 'package:pherico/widgets/global/image_popup.dart';
import 'package:pherico/widgets/global/rounded_image.dart';

class UserSearchCard extends StatelessWidget {
  final Seller seller;
  const UserSearchCard({super.key, required this.seller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: cardBg,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (_) => ImagePopup(image: seller.cover));
              },
              child: RoundedImage(
                height: 50,
                width: 50,
                radius: 25,
                image: seller.cover,
                isNetwork: true,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.to(() => const Chat(),
                      transition: Transition.rightToLeft, arguments: seller);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            seller.shopName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        seller.isOnline
                            ? const Icon(
                                Icons.circle,
                                color: Colors.green,
                                size: 18,
                              )
                            : Container()
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      seller.bio,
                      maxLines: 1,
                      style: TextStyle(color: greyText),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
