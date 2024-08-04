import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/models/seller/product_variant_model.dart';
import 'package:pherico/models/size_option.dart';
import 'package:pherico/utils/border.dart';

class ProductVariant extends StatelessWidget {
  final VoidCallback onTap;
  final ProductVariantModel products;
  const ProductVariant(
      {super.key, required this.onTap, required this.products});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardBg,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: borderShape(radius: 12),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Price: ',
                    style: TextStyle(
                      color: brownText,
                    ),
                    children: [
                      TextSpan(
                        text: '$rupeeSymbol${products.price} ',
                        style: TextStyle(
                            color: brownText, fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                            text: products.discountUnit == '%'
                                ? ' ${products.discount}${products.discountUnit} Off'
                                : ' ${products.discountUnit}${products.discount} Off',
                            style: const TextStyle(color: Colors.green),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: onTap,
                  child: const CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.white,
                    child: Icon(
                      CupertinoIcons.clear,
                      size: 15,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            Text('Stock:${products.stocks}'),
            Row(
              children: [
                const Text('Sizes:'),
                Expanded(
                  child: SizedBox(
                    height: 15,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.size.length,
                      itemBuilder: (context, index) {
                        if (products.size[index].unit == 'L' ||
                            products.size[index].unit == 'S' ||
                            products.size[index].unit == 'M' ||
                            products.size[index].unit == 'XL' ||
                            products.size[index].unit == 'XXL' ||
                            products.size[index].unit == 'XXXL') {
                          return Text('${products.size[index].unit},');
                        } else {
                          return Text(
                              '${products.size[index].size}${products.size[index].unit},');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            products.color.isNotEmpty
                ? Text(
                    'Color:${products.color},',
                    overflow: TextOverflow.ellipsis,
                  )
                : Container(),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 226, 226, 226),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: MemoryImage(products.images[index]),
                        fit: BoxFit.cover,
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // String sizeFormatter(ProductVariantModel product) {
  //   if (product.size == 'S' ||
  //       product.size == 'M' ||
  //       product.size == 'L' ||
  //       product.size == 'XL' ||
  //       product.size == 'XXL' ||
  //       product.size == 'XXXl') {
  //     return product.size;
  //   } else {
  //     return product.size + product.sizeUnit;
  //   }
  // }
}
