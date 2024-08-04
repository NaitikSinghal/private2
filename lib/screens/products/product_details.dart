import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:get/get.dart';
import 'package:pherico/config/icon_paths.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/helpers/chat_time_formatter.dart';
import 'package:pherico/models/address.dart';
import 'package:pherico/models/cart.dart';
import 'package:pherico/models/ratings.dart';
import 'package:pherico/models/seller/add_product.dart';
import 'package:pherico/models/seller/product_variant_model.dart';
import 'package:pherico/models/seller/seller.dart';
import 'package:pherico/models/size_option.dart';
import 'package:pherico/resources/address_resource.dart';
import 'package:pherico/resources/cart_resource.dart';
import 'package:pherico/resources/seller_resources.dart';
import 'package:pherico/resources/product_resource.dart';
import 'package:pherico/resources/saved_items_resource.dart';
import 'package:pherico/screens/add_address.dart';
import 'package:pherico/screens/cart_screen.dart';
import 'package:pherico/screens/products/product_view.dart';
import 'package:pherico/screens/seller_profile.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/utils/color.dart';
import 'package:pherico/utils/product.dart';
import 'package:pherico/utils/size.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'package:pherico/widgets/buttons/outlined_button.dart';
import 'package:pherico/widgets/cart/cart_total_badge.dart';
import 'package:pherico/widgets/global/read_more.dart';
import 'package:pherico/widgets/global/my_bottom_sheet.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/widgets/skeletons/container_skeleton.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:uuid/uuid.dart';

class ProductDetails extends StatefulWidget {
  final AddProduct product;
  const ProductDetails(this.product, {super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<String> swiperImages = [];
  int stocks = 0;
  int selectSizeIndex = -1;
  String selectedSize = '';
  String selectedSizeUnit = '';
  int selectedColorIndex = -1;
  String selectedColor = '';
  String selectedColorCode = '';
  String error = '';
  late String address = '';
  int price = 0;
  int discount = 0;
  String discountUnit = '';
  bool isSize = false;
  bool isColor = false;
  late final Future<QuerySnapshot<Map<String, dynamic>>> _addressFuture;
  late final Future<QuerySnapshot<Map<String, dynamic>>> _ratings;
  late Size deviceSize;
  late List<SizeModel> sizes;

  @override
  void initState() {
    super.initState();
    swiperImages = widget.product.images.map((e) => e.toString()).toList();
    stocks = widget.product.stocks;
    price = widget.product.price;
    discount = widget.product.discount;
    discountUnit = widget.product.discountUnit;
    selectedColor = widget.product.colorCode;
    sizes = widget.product.sizes;
    isSize = widget.product.sizes.isNotEmpty ? true : false;
    isColor = widget.product.colorCode.isNotEmpty ? true : false;
    _ratings = getProductRating(widget.product.productId);
    _addressFuture = AddressMethods.getDefaultAddress();
  }

  void addToCart(String productId, context) async {
    setState(() {
      error = '';
    });
    try {
      if (isSize && selectedSize.isEmpty) {
        setState(() {
          error = 'Please select size';
        });
      } else if (isColor && selectedColor.isEmpty) {
        setState(() {
          error = 'Please select color';
        });
      } else {
        final cartId = const Uuid().v1();
        Cart cart = Cart(
            id: cartId,
            userId: firebaseAuth.currentUser!.uid,
            productId: productId,
            quantity: 1,
            size: selectedSize,
            unit: selectedSizeUnit,
            color: selectedColor,
            colorCode: selectedColorCode,
            price: price,
            deliveryCharge: widget.product.deliveryCharge,
            productName: widget.product.name,
            discount: discount,
            thumbnail: widget.product.imageUrl,
            discountUnit: discountUnit);

        String res = await CartResource().addToCart(cart);
        if (res == 'success') {
          showToast(
            "Product added into cart",
          );
        } else {
          context.showToast(
            isError: true,
            "Failed to add",
          );
        }
      }
    } catch (err) {
      showToast(
        isError: true,
        "Something went wrong",
      );
    }
  }

  showToast(String msg, {bool isError = false}) {
    context.showToast(msg, isError: isError);
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              },
              iconSize: 20,
              padding: const EdgeInsets.fromLTRB(0, 0, 1, 2),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Get.to(() => const CartScreen(),
                      transition: Transition.rightToLeft);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CartTotalBadge(
                    iconPath: cartIcon,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    flexibleSpace: FlexibleSpaceBar(
                      background: swiper(),
                    ),
                    backgroundColor: Colors.white,
                    toolbarHeight: 0,
                    floating: false,
                    pinned: false,
                    expandedHeight: deviceSize.height * 0.32,
                  ),
                  SliverToBoxAdapter(
                    child: Wrap(
                      children: [
                        productNameAndPrice(),
                        widget.product.sizes.isNotEmpty
                            ? sizeTile()
                            : Container(),
                        widget.product.colorCode.isNotEmpty
                            ? colorTile()
                            : Container(),
                        error.isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    error,
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        liveDemoCard(),
                        const SizedBox(
                          height: 8,
                        ),
                        productDesc(),
                        deliveryCard(),
                        returnCard(),
                        review(),
                        // widget.product.userId == firebaseAuth.currentUser!.uid
                        //     ? Container()
                        //     : followSellerWidget(),
                        followSellerWidget(),
                        productByThisSeller(),
                        recommendedProduct()
                      ],
                    ),
                  )
                ],
              ),
            ),
            bottomButton()
          ],
        ),
      ),
    );
  }

  Widget swiper() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Swiper(
                key: UniqueKey(),
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    key: UniqueKey(),
                    imageUrl: swiperImages[index],
                    placeholder: (context, url) {
                      return const MyProgressIndicator();
                    },
                  );
                },
                loop: false,
                autoplay: true,
                autoplayDelay: 4000,
                itemCount: swiperImages.length,
                pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.grey,
                    activeColor: gradient1,
                  ),
                ),
                scrollDirection: Axis.horizontal,
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Card(
                  color: greyColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 10,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      CupertinoIcons.arrowshape_turn_up_right,
                      size: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 6,
            width: deviceSize.width - 100,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Color.fromARGB(255, 224, 223, 223),
            ),
          ),
        ),
      ],
    );
  }

  Widget productNameAndPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.visible,
              ),
              const SizedBox(
                height: 4,
              ),
              RichText(
                text: TextSpan(
                  text: '$rupeeSymbol$price ',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: getDiscount(discount, discountUnit),
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          loveIcon()
        ],
      ),
    );
  }

  Widget loveIcon() {
    // item to be saved for later and check whether it is already saved or not
    return Card(
      color: greyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: firebaseFirestore
              .collection(savedProductsCollection)
              .doc(firebaseAuth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return saveIcon();
            } else if (snapshot.hasError) {
              return Container();
            } else {
              if (snapshot.hasData && snapshot.data!.data() != null) {
                if (snapshot.data!.data()!.containsKey('products')) {
                  List productIds = snapshot.data!.data()!['products'];
                  if (productIds.contains(widget.product.productId)) {
                    return saveIconFilled();
                  } else {
                    return saveIcon();
                  }
                } else {
                  return saveIcon();
                }
              } else {
                return saveIcon();
              }
            }
          },
        ),
      ),
    );
  }

  Widget saveIcon() {
    return InkWell(
      onTap: () async {
        try {
          String res =
              await SavedItemsResource.saveProduct(widget.product.productId);
          if (res == 'success') {
            showToast('Added to saved list');
          } else {
            showToast(
              'Error to add',
              isError: true,
            );
          }
        } catch (e) {
          showToast(
            'Error to add',
            isError: true,
          );
        }
      },
      child: const Icon(
        CupertinoIcons.heart,
        size: 28,
      ),
    );
  }

  Widget saveIconFilled() {
    return InkWell(
      onTap: () async {
        try {
          String res = await SavedItemsResource.removeSavedProduct(
              widget.product.productId);
          if (res == 'success') {
            showToast('Removed from saved list');
          } else {
            showToast(isError: true, 'Error to remove');
          }
        } catch (e) {
          showToast(isError: true, 'Error to remove');
        }
      },
      child: const Icon(
        CupertinoIcons.heart_fill,
        size: 28,
        color: Color.fromARGB(255, 201, 85, 104),
      ),
    );
  }

  Widget productDesc() {
    //product desc here
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            desc,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(widget.product.longDesc)
        ],
      ),
    );
  }

  Widget sizeTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Available Size'),
          const SizedBox(
            height: 4,
          ),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                widget.product.colorCode.isEmpty
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            price = widget.product.price;
                            discount = widget.product.discount;
                            discountUnit = widget.product.discountUnit;
                            swiperImages.clear();
                            swiperImages = widget.product.images
                                .map((e) => e.toString())
                                .toList();
                            stocks = widget.product.stocks;
                            selectSizeIndex = -1;
                            selectedSize = widget.product.sizes.first.size;
                            selectedSizeUnit = widget.product.sizes.first.unit;
                          });
                        },
                        child: productSizes(widget.product.sizes[0].size,
                            widget.product.sizes[0].unit, -1),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sizes.length,
                        itemBuilder: (context, index) {
                          SizeModel sizeData = sizes[index];
                          return sizeData.size.isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectSizeIndex = index;
                                      selectedSize = sizeData.size;
                                      selectedSizeUnit = sizeData.unit;
                                    });
                                  },
                                  child: productSizes(
                                      sizeData.size, sizeData.unit, index),
                                )
                              : Container();
                        },
                      ),
                widget.product.colorCode.isEmpty &&
                        widget.product.variants.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.product.variants.length,
                          itemBuilder: (context, index) {
                            ProductVariantModel variant =
                                widget.product.variants[index];
                            SizeModel sizeData = variant.size.first;
                            return sizeData.size.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        price = variant.price;
                                        discount = variant.discount;
                                        discountUnit = variant.discountUnit;
                                        swiperImages.clear();
                                        swiperImages = variant.images
                                            .map((e) => e.toString())
                                            .toList();
                                        stocks = variant.stocks;
                                        sizes = variant.size;
                                        selectSizeIndex = index;
                                        selectedSize = sizeData.size;
                                        selectedSizeUnit = sizeData.unit;
                                      });
                                    },
                                    child: productSizes(
                                        sizeData.size, sizeData.unit, index),
                                  )
                                : Container();
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget productSizes(String size, String unit, int index) {
    if (unit == 'S' ||
        unit == 'M' ||
        unit == 'L' ||
        unit == 'XL' ||
        unit == 'XXL' ||
        unit == 'XXXL') {
      return Container(
        width: 40,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
              color:
                  selectSizeIndex == index ? Colors.black : Colors.transparent,
              width: selectSizeIndex == index ? 1.4 : 0),
          color: greyColor,
        ),
        child: Center(
          child: Text(size),
        ),
      );
    } else {
      return Card(
        elevation: 0,
        margin: const EdgeInsets.only(right: 12),
        shape: borderShape(radius: 8),
        color: selectSizeIndex == index ? selectedCardColor : greyColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Center(
            child: Text(
              '$size $unit',
            ),
          ),
        ),
      );
    }
  }

  Widget colorTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Available Colors'),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    price = widget.product.price;
                    discount = widget.product.discount;
                    discountUnit = widget.product.discountUnit;
                    swiperImages.clear();
                    swiperImages =
                        widget.product.images.map((e) => e.toString()).toList();
                    stocks = widget.product.stocks;
                    selectedColorIndex = -1;
                    selectedColor = widget.product.color;
                    selectedColorCode = widget.product.colorCode;
                    sizes = widget.product.sizes;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: HexColor(widget.product.colorCode),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: selectedColorIndex == -1
                          ? Colors.black
                          : Colors.transparent,
                      width: selectedColorIndex == -1 ? 1.4 : 0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.product.variants.length,
                    itemBuilder: (context, index) {
                      ProductVariantModel variant =
                          widget.product.variants[index];
                      if (variant.color.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            right: 16.0,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                price = variant.price;
                                discount = variant.discount;
                                discountUnit = variant.discountUnit;
                                swiperImages.clear();
                                swiperImages = variant.images
                                    .map((e) => e.toString())
                                    .toList();
                                stocks = variant.stocks;
                                selectedColorIndex = index;
                                selectedColor = variant.color;
                                selectedColorCode = variant.colorCode;
                                sizes = variant.size;
                              });
                            },
                            child: Container(
                              width: 40,
                              decoration: BoxDecoration(
                                color: HexColor(variant.colorCode),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  color: selectedColorIndex == index
                                      ? Colors.black
                                      : Colors.transparent,
                                  width: selectedColorIndex == index ? 1.4 : 0,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget deliveryCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Card(
                  color: HexColor('#F4F7FE'),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8, horizontal: deviceSize.width * 0.07),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          transit,
                          height: 25,
                        ),
                        Text(
                          widget.product.deliveryCharge == 0
                              ? 'Free delivery'
                              : '  $rupeeSymbol${widget.product.deliveryCharge}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const SizedBox(
                  height: 20,
                  child: VerticalDivider(
                    thickness: 2,
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  'Delivery in 6-7 days',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: _addressFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ContainerSkeleton();
                } else if (snapshot.hasError) {
                  return emptyAddressCard();
                } else {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    Address defaultAddress =
                        Address.fromSnap(snapshot.data!.docs[0]);
                    address =
                        '${defaultAddress.flat} ${defaultAddress.area} ${defaultAddress.city}, ${defaultAddress.state}';

                    return addressCard();
                  } else {
                    return emptyAddressCard();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget liveDemoCard() {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      shape: borderShape(radius: 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              'Request for live demonstration to this seller',
              maxLines: 2,
              style: TextStyle(
                overflow: TextOverflow.visible,
                color: brownText,
                fontWeight: FontWeight.normal,
              ),
            )),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  shape: bottomSheetBorder,
                  context: context,
                  builder: (ctx) {
                    return selectAddress();
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SvgPicture.asset(
                  liveRequest,
                  height: 44,
                  colorFilter: svgColor(
                    color: gradient1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addressCard() {
    return Card(
      shape: borderShape(),
      elevation: 0,
      color: HexColor('#F4F4F4'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: 'Delivering to: ',
                  style: TextStyle(
                    color: textColor_1,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: address,
                      style: TextStyle(
                        overflow: TextOverflow.visible,
                        color: brownText,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  shape: borderShape(),
                  context: context,
                  builder: (ctx) {
                    return selectAddress();
                  },
                );
              },
              child: Card(
                color: HexColor('#FDE7CE'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SvgPicture.asset(
                    editPencil,
                    height: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyAddressCard() {
    return Card(
      shape: borderShape(),
      elevation: 0,
      color: HexColor('#F4F4F4'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: 'Delivering to:',
                  style: TextStyle(
                    color: textColor_1,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: ' Add address',
                      style: TextStyle(
                        overflow: TextOverflow.visible,
                        color: brownText,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                Get.to(() => const AddAddress(),
                    transition: Transition.leftToRight);
              },
              child: Card(
                color: HexColor('#FDE7CE'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.add_location_alt,
                    color: gradient1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget returnCard() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                if (widget.product.policy == 0) {
                  return;
                } else {
                  showModalBottomSheet(
                    shape: borderShape(),
                    context: context,
                    builder: (context) {
                      return bottomSheetPolicy();
                    },
                  );
                }
              },
              child: Column(
                children: [
                  SvgPicture.asset(
                    returnIcon,
                    height: 35,
                  ),
                  Text(
                    intToPolicy(widget.product.policy),
                    style: TextStyle(color: brownText),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
              child: VerticalDivider(
                thickness: 2,
                color: Colors.black,
              ),
            ),
            Column(
              children: [
                SvgPicture.asset(
                  dollar,
                  height: 35,
                ),
                Text(
                  widget.product.isCod
                      ? 'Cash on delivery'
                      : 'No cash on delivery',
                  style: TextStyle(color: brownText),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget averageRating(int numberOfStar) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < numberOfStar; i++)
                SvgPicture.asset(
                  star,
                  height: 35,
                ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            '$numberOfStar Ratings on average',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget review() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review from buyers',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: _ratings,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ContainerSkeleton();
              } else if (snapshot.hasError) {
                return SizedBox(
                  height: 40,
                  width: deviceSize.width,
                  child: const Center(
                    child: Text('No review'),
                  ),
                );
              } else {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  if (snapshot.data!.docs.length > 4) {
                    return Column(
                      children: [
                        averageRating(averageOfRating(snapshot.data!.docs)),
                        for (var i = 0; i < 4; i++)
                          reviewWithProfile(
                              Rating.fromJson(snapshot.data!.docs[i])),
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'Show more(${snapshot.data!.docs.length})',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: brownText,
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        averageRating(averageOfRating(snapshot.data!.docs)),
                        for (var i = 0; i < snapshot.data!.docs.length; i++)
                          reviewWithProfile(
                              Rating.fromJson(snapshot.data!.docs[i])),
                      ],
                    );
                  }
                } else {
                  return SizedBox(
                    height: 40,
                    width: deviceSize.width,
                    child: const Center(
                      child: Text('No review'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  int averageOfRating(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> listOfRating) {
    double r1 = 0;
    double r2 = 0;
    double r3 = 0;
    double r4 = 0;
    double r5 = 0;
    double average = 0;
    for (var i = 0; i < listOfRating.length; i++) {
      Rating rating = Rating.fromJson(listOfRating[i]);
      switch (rating.rate) {
        case 1:
          r1 = r1 + 1;
          break;
        case 2:
          r2 = r2 + 1;
          break;
        case 3:
          r3 = r3 + 1;
          break;
        case 4:
          r4 = r4 + 1;
          break;
        case 5:
          r5 = r5 + 1;
          break;
      }
    }
    average =
        (5 * r5 + 4 * r4 + 3 * r3 + r2 * 2 + r1) / (r5 + r4 + r3 + r2 + r1);

    return average.toInt();
  }

  Widget reviewWithProfile(Rating rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(rating.profile),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rating.name,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: brownText),
                ),
                Text(
                  ChatTimeFormatter.getFormattedDateTime(
                      context, rating.ratingAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Text(
              '4.5',
              style: TextStyle(color: brownText, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 4,
            ),
            for (var i = 0; i < 4; i++)
              SvgPicture.asset(
                star,
                height: 15,
              ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        ReadMore(
          text: rating.review,
          trimLine: 2,
          textColor: Colors.grey,
        ),
        const Divider(
          height: 30,
          thickness: 1,
        ),
      ],
    );
  }

  Widget followSellerWidget() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: firebaseFirestore
            .collection(storeCollection)
            .doc(widget.product.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data()!.isNotEmpty) {
            Seller seller = Seller.fromJson(snapshot.data!);
            return Card(
              elevation: 2,
              shape: borderShape(radius: 0),
              margin: EdgeInsets.zero,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => SellerProfile(
                                  sellerId: seller.uid,
                                ),
                                transition: Transition.rightToLeft,
                              );
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  CachedNetworkImageProvider(seller.profile),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                seller.shopName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                ChatTimeFormatter.getSince(seller.dateCreated),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: greyText),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    seller.followers.contains(firebaseAuth.currentUser!.uid)
                        ? GradientElevatedButton(
                            buttonName: 'Following',
                            width: 100,
                            onPressed: () {
                              showToast('Unfollow', isError: false);
                            })
                        : GradientElevatedButton(
                            width: 100,
                            buttonName: 'Follow',
                            onPressed: () async {
                              try {
                                followSeller(seller.uid);
                              } catch (e) {
                                showToast('Error to follow', isError: true);
                              }
                            },
                          )
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget productByThisSeller() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 12,
          ),
          const Text(
            'More by this seller',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          SizedBox(
            height: deviceSize.height * 0.2,
            child: FirestoreListView<Map<String, dynamic>>(
              scrollDirection: Axis.horizontal,
              query: firebaseFirestore
                  .collection(productsCollection)
                  .where('userId', isEqualTo: widget.product.userId)
                  .where('productId', isNotEqualTo: widget.product.productId)
                  .limit(10),
              loadingBuilder: (context) {
                return const MyProgressIndicator();
              },
              itemBuilder: (context, snapshot) {
                AddProduct product = AddProduct.fromMap(snapshot.data());
                return ProductView(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget recommendedProduct() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended products',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: deviceSize.height * 0.2,
            child: FirestoreListView<Map<String, dynamic>>(
              scrollDirection: Axis.horizontal,
              query: firebaseFirestore
                  .collection(productsCollection)
                  .where('userId', isNotEqualTo: widget.product.userId)
                  .where('categoryId', isEqualTo: widget.product.categoryId)
                  .limit(10),
              loadingBuilder: (context) {
                return const MyProgressIndicator();
              },
              emptyBuilder: (context) {
                return const Text(
                  'No product found',
                );
              },
              itemBuilder: (context, snapshot) {
                AddProduct product = AddProduct.fromMap(snapshot.data());
                return ProductView(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomButton() {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 16, vertical: stocks == 0 ? 22 : 8),
      child: stocks == 0
          ? const Text(
              'Currently out of stock',
              style: TextStyle(color: Colors.red, fontSize: 15),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyOutlinedButton(
                  buttonName: 'Add To Cart',
                  width: deviceSize.width / 2 - 24,
                  height: 46,
                  onPressed: () {
                    addToCart(widget.product.productId, context);
                  },
                ),
                GradientElevatedButton(
                  buttonName: buyNow,
                  width: deviceSize.width / 2 - 24,
                  height: 46,
                  onPressed: (() {}),
                ),
              ],
            ),
    );
  }

  Widget bottomSheetPolicy() {
    return MyBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Condition for return/exchange',
            style: TextStyle(
              color: brownText,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            '1.Received defective product',
            style: TextStyle(
              color: brownText,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            '2.Received wrong product',
            style: TextStyle(
              color: brownText,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            '3.Low product quality',
            style: TextStyle(
              color: brownText,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            '4.Did not like the product',
            style: TextStyle(
              color: brownText,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            '5.Received damaged product',
            style: TextStyle(
              color: brownText,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget selectAddress() {
    return MyBottomSheet(
      title: 'Select address',
      child: SizedBox(
        height: deviceSize.height * 0.4,
        child: FirestoreListView<Map<String, dynamic>>(
          padding: const EdgeInsets.only(top: 20, bottom: 12),
          pageSize: 10,
          query: firebaseFirestore
              .collection(addressesCollection)
              .where('uid', isEqualTo: firebaseAuth.currentUser!.uid),
          loadingBuilder: (context) {
            return const MyProgressIndicator();
          },
          emptyBuilder: (context) {
            return const Center(
              child: Text('No address found'),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text('Something went wrong'),
            );
          },
          itemBuilder: (ctx, snapshot) {
            Address selectedAddress = Address.fromMap(snapshot.data());
            return InkWell(
              onTap: () {
                setState(() {
                  address =
                      '${selectedAddress.flat} ${selectedAddress.area} ${selectedAddress.city}, ${selectedAddress.state} ${selectedAddress.pincode}';
                  Navigator.of(context).pop();
                });
              },
              child: Card(
                elevation: 2,
                shape: borderShape(),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedAddress.fullName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: brownText),
                      ),
                      Text(
                        '${selectedAddress.flat} ${selectedAddress.area} ${selectedAddress.city} ${selectedAddress.state} ${selectedAddress.pincode}',
                        style: TextStyle(color: brownText),
                      ),
                      Text(
                        selectedAddress.phone,
                        style: TextStyle(color: brownText),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
