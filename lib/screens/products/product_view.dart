import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/screens/products/product_details.dart';
import 'package:pherico/models/seller/add_product.dart';
import 'package:pherico/utils/product.dart';

class ProductView extends StatelessWidget {
  final AddProduct product;
  const ProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () {
          Get.to(
            () => ProductDetails(product),
            transition: Transition.rightToLeft,
            preventDuplicates: false,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.33,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text: TextSpan(
                text: getbasePrice(
                    product.price, product.discount, product.discountUnit),
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 2,
                  fontSize: 12,
                  color: Colors.grey,
                ),
                children: [
                  TextSpan(
                    text:
                        ' $rupeeSymbol${afterDiscount(product.discount, product.discountUnit, product.price).toString()}',
                    style: TextStyle(
                      color: brownText,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      decoration: TextDecoration.none,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
