import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/models/seller/seller.dart';
import 'package:pherico/resources/seller_resources.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/widgets/global/image_popup.dart';

class FavSellerList extends StatelessWidget {
  final Seller seller;
  const FavSellerList({required this.seller, super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(seller.uid.toString()),
      background: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(right: 20, left: 20),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: errorColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.delete,
              color: white,
              size: 30,
            ),
            Icon(
              Icons.delete,
              color: white,
              size: 30,
            ),
          ],
        ),
      ),
      onDismissed: (direction) async {},
      direction: DismissDirection.horizontal,
      child: Stack(
        children: [
          Card(
            color: cardBg,
            shape: borderShape(radius: 12),
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        seller.shopName,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: brownText,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await removeSellerFromFavourites(seller.uid);
                        },
                        child: const Icon(
                          CupertinoIcons.clear_circled_solid,
                          size: 26,
                          color: Color.fromARGB(255, 148, 148, 148),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      seller.bio,
                      style: TextStyle(color: brownText),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: '${seller.followers.length}',
                      style: TextStyle(
                          color: gradient1,
                          fontWeight: FontWeight.w900,
                          fontSize: 20),
                      children: [
                        TextSpan(
                          text: ' Followers',
                          style: TextStyle(
                              color: brownText,
                              fontWeight: FontWeight.normal,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 0,
            child: InkWell(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (_) => ImagePopup(image: seller.profile),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: seller.profile,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
