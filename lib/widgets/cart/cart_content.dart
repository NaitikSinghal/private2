import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/models/cart.dart';
import 'package:pherico/models/seller/add_product.dart';
import 'package:pherico/resources/cart_resource.dart';
import 'package:pherico/screens/products/product_details.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/utils/product.dart';
import 'package:pherico/utils/size.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/outlined_button.dart';
import 'package:pherico/widgets/global/rounded_image.dart';
import 'package:snippet_coder_utils/hex_color.dart';

// ignore: must_be_immutable
class CartContent extends StatefulWidget {
  Cart cart;
  CartContent({required this.cart, super.key});

  @override
  State<CartContent> createState() => _CartContentState();
}

class _CartContentState extends State<CartContent> {
  showToaster(String msg, bool isError) {
    context.showToast(msg, isError: isError);
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: borderShape(radius: 8),
        color: cardBg,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    // onTap: () {
                    //   Get.to(() => ProductDetails());
                    // },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.cart.thumbnail,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.height * 0.12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                      height: 110,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  widget.cart.productName,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                              ),
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                iconSize: 24,
                                icon: Icon(
                                  CupertinoIcons.clear_circled_solid,
                                  color: gradient1,
                                ),
                                onPressed: () async {
                                  try {
                                    String res = await CartResource()
                                        .removeCartItem(widget.cart.id);
                                    if (res == 'success') {
                                    } else {
                                      showToaster(
                                          "Failed to remove item", true);
                                    }
                                  } catch (error) {
                                    scaffold.showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Unable to delete cart item',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              widget.cart.size.isNotEmpty
                                  ? Text(
                                      'Size:${getSize(widget.cart.size, widget.cart.unit)}',
                                    )
                                  : Container(),
                              const SizedBox(
                                width: 4,
                              ),
                              widget.cart.color.isNotEmpty
                                  ? Text(
                                      widget.cart.color,
                                    )
                                  : Container(),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          widget.cart.deliveryCharge == 0
                              ? Text(
                                  'Free delivery',
                                  style: TextStyle(color: green),
                                )
                              : Text(
                                  overflow: TextOverflow.ellipsis,
                                  'Delivery charge : $rupeeSymbol${widget.cart.deliveryCharge}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: greyText,
                                  ),
                                  maxLines: 2,
                                ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '$rupeeSymbol${widget.cart.price}',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: iconColor),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      MyOutlinedButton(
                          buttonName: 'Save for later',
                          height: 28,
                          onPressed: () async {
                            try {
                              String res = await CartResource().saveForLater(
                                  widget.cart.productId, widget.cart.id);
                              if (res == 'success') {
                                showToaster("Product saved", true);
                              } else {
                                showToaster("Failed to save", true);
                              }
                            } catch (e) {
                              showToaster("Failed to save", true);
                            }
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          height: 26,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: gradient2, width: 1.2)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.remove_sharp,
                                  color: gradient1,
                                  size: 18,
                                ),
                                onPressed: () async {
                                  try {
                                    String res = await CartResource()
                                        .decreaseQuantity(widget.cart.id,
                                            widget.cart.quantity);
                                    if (res == 'success') {
                                      showToaster('Cart updated', false);
                                    } else if (res == 'nothing') {
                                    } else {
                                      showToaster(
                                          'Unable to update quantity', true);
                                    }
                                  } catch (error) {
                                    showToaster(
                                        'Unable to update quantity', true);
                                  }
                                },
                              ),
                              Text('Qty:${widget.cart.quantity.toString()}'),
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.add,
                                  color: gradient1,
                                  size: 18,
                                ),
                                onPressed: () async {
                                  try {
                                    String res = await CartResource()
                                        .increaseQuantity(widget.cart.id,
                                            widget.cart.quantity);
                                    if (res != 'success') {
                                      showToaster(
                                          'Unable to update quantity', true);
                                    }
                                  } catch (error) {
                                    showToaster(
                                        'Unable to update quantity', false);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '$rupeeSymbol${afterDiscount(widget.cart.discount, widget.cart.discountUnit, widget.cart.price * widget.cart.quantity)}',
                        style: TextStyle(
                            height: .57,
                            color: greyText,
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 2,
                            decorationColor: greyText),
                      ),
                      Text(
                        '$rupeeSymbol${widget.cart.price * widget.cart.quantity}',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: iconColor),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
