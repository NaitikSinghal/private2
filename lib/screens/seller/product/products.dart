import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/models/seller/add_product.dart';
import 'package:pherico/resources/product_resource.dart';
import 'package:pherico/screens/products/product_details.dart';
import 'package:pherico/screens/seller/product/upload_product.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/utils/product.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'package:pherico/widgets/buttons/outlined_button.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/error_widget.dart';
import 'package:pherico/widgets/global/my_bottom_sheet.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/widgets/global/rounded_image.dart';
import 'package:pherico/widgets/skeletons/product_skeleton.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class SellerProducts extends StatefulWidget {
  const SellerProducts({super.key});

  @override
  State<SellerProducts> createState() => _SellerProductsState();
}

class _SellerProductsState extends State<SellerProducts> {
  List<String> filterButtons = [
    'Stocks',
    'Category',
    'Price',
    'Orders',
    'Date'
  ];
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _orderNumberController = TextEditingController();
  final TextEditingController _priceLessController = TextEditingController();
  final TextEditingController _priceGreaterController = TextEditingController();
  final TextEditingController _priceEqualController = TextEditingController();
  final TextEditingController _stockUpdateController = TextEditingController();
  List categories = [];
  String selectedCategory = '';
  String _priceType = 'price';
  int selectedFilter = -1;

  Query<Map<String, dynamic>> _query = firebaseFirestore
      .collection(productsCollection)
      .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
      .orderBy('createdAt', descending: true);

  @override
  void dispose() {
    super.dispose();
    _stockController.dispose();
    _orderNumberController.dispose();
    _priceLessController.dispose();
    _priceGreaterController.dispose();
    _priceEqualController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        key: UniqueKey(),
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Products',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
          child: Column(
            children: [
              Row(
                children: [
                  selectedFilter != -1
                      ? IconButton(
                          visualDensity: const VisualDensity(horizontal: -4),
                          icon: const Icon(CupertinoIcons.clear),
                          onPressed: () {
                            setState(() {
                              selectedFilter = -1;
                              _query = firebaseFirestore
                                  .collection(productsCollection)
                                  .where('userId',
                                      isEqualTo: firebaseAuth.currentUser!.uid)
                                  .orderBy('createdAt', descending: true);
                            });
                          },
                        )
                      : Container(),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 16,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return filterButton(
                              filterButtons[index], index, context);
                        },
                        itemCount: filterButtons.length,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: FirestoreListView<Map<String, dynamic>>(
                  pageSize: 10,
                  query: _query,
                  loadingBuilder: (context) => const ProductSkeleton(),
                  errorBuilder: (context, error, stackTrace) {
                    return const SomethingWentWrongError();
                  },
                  emptyBuilder: (context) {
                    return const Center(
                      child: Text('No products'),
                    );
                  },
                  itemBuilder: (context, snapshot) {
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width - 16,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return filterButton(
                              filterButtons[index], index, context);
                        },
                        itemCount: filterButtons.length,
                      ),
                    );
                    final products = AddProduct.fromMap(snapshot.data());

                    return productStyle(products, context);
                  },
                ),
              ),
              addProductBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget addProductBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: GradientElevatedButton(
        buttonName: 'Add',
        height: 46,
        onPressed: () {
          Get.to(() => const UploadProduct(),
              transition: Transition.leftToRight);
        },
      ),
    );
  }

  Widget productStyle(AddProduct products, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      elevation: 0,
      color: cardBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(
                  () => ProductDetails(products),
                  transition: Transition.leftToRight,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: products.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$rupeeSymbol${products.price}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  getbasePrice(products.price,
                                      products.discount, products.discountUnit),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 2.85,
                                    decorationColor: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: HexColor('#EBEBEB'),
                        child: const Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 68, 68, 68),
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Stocks:${products.stocks} | ',
                      style: TextStyle(color: textColor),
                      children: [TextSpan(text: 'Orders:${products.orders}')],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () async {
                      _showStockEditDialog(
                          products.stocks, products.productId, context);
                    },
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: products.stocks < 5 ? orange : green,
                      child: const Center(
                        child: Text(
                          'Edit sotck',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
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

  Future<void> _showStockEditDialog(
      int stock, String productId, BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            insetPadding: const EdgeInsets.fromLTRB(20, 0, 16, 20),
            title: const Text('Update stocks'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Remaining stock : $stock'),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: _stockUpdateController,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(top: 8, left: 8),
                          counterText: '',
                          hintText: 'Enter stock',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: greyColor, width: 0.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: greyColor, width: 0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GradientElevatedButton(
                            buttonName: 'Add to stock',
                            onPressed: () {
                              increaseStock(productId, stock, context);
                            }),
                        MyOutlinedButton(
                            buttonName: 'minus stock',
                            onPressed: () {
                              decreaseStock(productId, stock, context);
                            })
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  decreaseStock(String productId, int stock, BuildContext context) async {
    if (_stockUpdateController.text == '') {
      context.showToast(
        "Enter number",
      );
    } else if (int.parse(_stockUpdateController.text) > stock) {
      context.showToast(
        isError: true,
        "Enter number less than current stock",
      );
    } else {
      String res = await updateStock(
          productId, stock - int.parse(_stockUpdateController.text));
      if (res == 'success') {
        context.showToast(isError: true, 'Stock updated');
        Navigator.of(context).pop();
        _stockUpdateController.text = '';
      } else {
        context.showToast(
          isError: true,
          "Failed to update stock",
        );
      }
    }
  }

  increaseStock(String productId, int stock, BuildContext context) async {
    if (_stockUpdateController.text == '') {
      context.showToast(
        isError: true,
        "Enter any number",
      );
    } else if (int.parse(_stockUpdateController.text) == 0) {
      context.showToast(
        isError: true,
        "Enter number greater than 0",
      );
    } else {
      String res = await updateStock(
          productId, stock + int.parse(_stockUpdateController.text));
      if (res == 'success') {
        context.showToast('Stock updated');
        Navigator.of(context).pop();
        _stockUpdateController.text = '';
      } else {
        context.showToast(
          isError: true,
          "Failed to update stock",
        );
      }
    }
  }

  Widget filterButton(String buttonName, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: FilterChip(
        label: Text(buttonName),
        labelStyle: const TextStyle(fontWeight: FontWeight.normal),
        backgroundColor: Colors.transparent,
        selected: selectedFilter == index ? true : false,
        showCheckmark: false,
        shape: StadiumBorder(
          side: BorderSide(width: 1, color: greyColor),
        ),
        onSelected: (bool value) async {
          switch (index) {
            case 0:
              await showStockBottomSheet(context);
              break;
            case 1:
              showCategory(context);
              break;
            case 2:
              await showPriceBottomSheet(context);
              break;
            case 3:
              await showOrdersBottomSheet(context);
              break;
            case 4:
              await showDateFilter(context);
              break;
          }
        },
      ),
    );
  }

  showCategory(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return SafeArea(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 22,
              height: MediaQuery.of(context).size.height - 80,
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: firebaseFirestore.collection(categoryCollection).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: MyProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Something went wrong! Please try again after sometime',
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.docs[index];
                        return TextButton(
                          onPressed: () {
                            setState(() {
                              _query = firebaseFirestore
                                  .collection(productsCollection)
                                  .where('userId',
                                      isEqualTo: firebaseAuth.currentUser!.uid)
                                  .where('categoryId', isEqualTo: data['id']);
                              selectedFilter = 1;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            data['name'],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: textColor_1,
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showStockBottomSheet(context) {
    return showModalBottomSheet(
      context: context,
      shape: bottomSheetBorder,
      builder: (context) {
        return MyBottomSheet(
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Select stock or enter',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilterChip(
                    label: const Text('<5'),
                    onSelected: (bool value) {
                      setStockInput(5);
                    },
                    labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(width: 1, color: greyColor),
                    ),
                  ),
                  FilterChip(
                    label: const Text('<10'),
                    onSelected: (bool value) {
                      setStockInput(10);
                    },
                    labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(width: 1, color: greyColor),
                    ),
                  ),
                  FilterChip(
                    label: const Text('<20'),
                    onSelected: (bool value) {
                      setStockInput(20);
                    },
                    labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(width: 1, color: greyColor),
                    ),
                  ),
                  FilterChip(
                    label: const Text('<50'),
                    onSelected: (bool value) {
                      setStockInput(50);
                    },
                    labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(width: 1, color: greyColor),
                    ),
                  ),
                  FilterChip(
                    label: const Text('<100'),
                    onSelected: (bool value) {
                      setStockInput(100);
                    },
                    labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(width: 1, color: greyColor),
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: _stockController,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(top: 8, left: 8),
                            counterText: '',
                            hintText: 'Ex-5',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide:
                                  BorderSide(color: greyColor, width: 0.2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide:
                                  BorderSide(color: greyColor, width: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    GradientElevatedButton(
                      radius: 6,
                      buttonName: 'Apply',
                      onPressed: () {
                        if (_stockController.text == '') {
                          return;
                        } else {
                          setState(() {
                            selectedFilter = 0;
                            _query = firebaseFirestore
                                .collection(productsCollection)
                                .where('userId',
                                    isEqualTo: firebaseAuth.currentUser!.uid)
                                .where('stocks',
                                    isLessThanOrEqualTo:
                                        int.parse(_stockController.text));
                          });
                          _stockController.text = '';
                          Navigator.of(context).pop();
                        }
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showOrdersBottomSheet(context) {
    return showModalBottomSheet(
      context: context,
      shape: bottomSheetBorder,
      builder: (context) {
        return MyBottomSheet(
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Enter stock to filter products',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilterChip(
                    label: const Text('<5'),
                    onSelected: (bool value) {
                      setOrderInput(5);
                    },
                    labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(width: 1, color: greyColor),
                    ),
                  ),
                  FilterChip(
                    label: const Text('<10'),
                    onSelected: (bool value) {
                      setOrderInput(10);
                    },
                    labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(width: 1, color: greyColor),
                    ),
                  ),
                  FilterChip(
                    label: const Text('<20'),
                    onSelected: (bool value) {
                      setOrderInput(20);
                    },
                    labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(width: 1, color: greyColor),
                    ),
                  ),
                  FilterChip(
                    label: const Text('<50'),
                    onSelected: (bool value) {
                      setOrderInput(50);
                    },
                    labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(width: 1, color: greyColor),
                    ),
                  ),
                  FilterChip(
                    label: const Text('<100'),
                    onSelected: (bool value) {
                      setOrderInput(100);
                    },
                    labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(width: 1, color: greyColor),
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: _orderNumberController,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(top: 8, left: 8),
                            counterText: '',
                            hintText: 'Ex-5',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide:
                                  BorderSide(color: greyColor, width: 0.2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide:
                                  BorderSide(color: greyColor, width: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    GradientElevatedButton(
                      radius: 6,
                      buttonName: 'Apply',
                      onPressed: () {
                        if (_orderNumberController.text == '') {
                          return;
                        } else {
                          setState(() {
                            _query = firebaseFirestore
                                .collection(productsCollection)
                                .where('userId',
                                    isEqualTo: firebaseAuth.currentUser!.uid)
                                .where(
                                  'orders',
                                  isLessThanOrEqualTo:
                                      int.parse(_orderNumberController.text),
                                );
                            selectedFilter = 3;
                          });
                          _orderNumberController.text = '';
                          Navigator.of(context).pop();
                        }
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showPriceBottomSheet(context) {
    return showModalBottomSheet(
      context: context,
      shape: bottomSheetBorder,
      builder: (context) {
        return MyBottomSheet(
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              radioButtons(context),
              priceLessThan(context),
              priceGreaterThan(context),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showDateFilter(context) async {
    final DateTimeRange? dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime.now(),
      cancelText: 'Cancel',
      saveText: 'Apply',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: gradient1,
              onPrimary: Colors.white,
              onSurface: Colors.blueAccent,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: gradient1, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (dateRange != null) {
      setState(() {
        _query = firebaseFirestore
            .collection(productsCollection)
            .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
            .where(
              'createdAt',
              isGreaterThanOrEqualTo:
                  DateTime.parse(dateRange.toString().split(' - ')[0])
                      .millisecondsSinceEpoch,
            )
            .where(
              'createdAt',
              isLessThanOrEqualTo:
                  DateTime.parse(dateRange.toString().split(' - ')[1])
                      .millisecondsSinceEpoch,
            );
        selectedFilter = 4;
      });
    }
  }

  Widget radioButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio(
              value: 'lowtohigh',
              groupValue: _priceType,
              onChanged: (value) {
                setState(() {
                  _priceType = value.toString();
                  _query = firebaseFirestore
                      .collection(productsCollection)
                      .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
                      .orderBy('price', descending: false);
                  selectedFilter = 2;
                  Navigator.of(context).pop();
                });
              },
              activeColor: gradient1,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const Text('Price Low To High'),
          ],
        ),
        Row(
          children: [
            Radio(
              value: 'hightolow',
              groupValue: _priceType,
              onChanged: (value) {
                setState(() {
                  _priceType = value.toString();
                  _query = firebaseFirestore
                      .collection(productsCollection)
                      .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
                      .orderBy('price', descending: true);
                  selectedFilter = 2;
                  Navigator.of(context).pop();
                });
              },
              activeColor: gradient1,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const Text('Price High To Low'),
          ],
        ),
      ],
    );
  }

  Widget priceLessThan(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextFormField(
                controller: _priceLessController,
                maxLength: 6,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price Less than',
                  contentPadding: const EdgeInsets.only(top: 8, left: 8),
                  counterText: '',
                  hintText: 'Ex-499',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: greyColor, width: 0.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: greyColor, width: 0.5),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          GradientElevatedButton(
            radius: 6,
            buttonName: 'Apply',
            onPressed: () {
              if (_priceLessController.text == '') {
                return;
              } else {
                setState(() {
                  _query = firebaseFirestore
                      .collection(productsCollection)
                      .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
                      .where(
                        'price',
                        isLessThan: int.parse(_priceLessController.text),
                      );
                  selectedFilter = 2;
                });
                _priceLessController.text = '';
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }

  Widget priceGreaterThan(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextFormField(
                controller: _priceGreaterController,
                maxLength: 6,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price Greater than',
                  contentPadding: const EdgeInsets.only(top: 8, left: 8),
                  counterText: '',
                  hintText: 'Ex-499',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: greyColor, width: 0.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: greyColor, width: 0.5),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          GradientElevatedButton(
            radius: 6,
            buttonName: 'Apply',
            onPressed: () {
              if (_priceGreaterController.text == '') {
                return;
              } else {
                setState(() {
                  _query = firebaseFirestore
                      .collection(productsCollection)
                      .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
                      .where(
                        'price',
                        isGreaterThan: int.parse(_priceGreaterController.text),
                      );
                  selectedFilter = 2;
                });
                _priceGreaterController.text = '';
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }

  setStockInput(int number) {
    setState(() {
      _stockController.text = number.toString();
    });
  }

  setOrderInput(int number) {
    setState(() {
      _orderNumberController.text = number.toString();
    });
  }
}
