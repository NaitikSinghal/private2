import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/controllers/upload_video.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class AddClickies extends StatefulWidget {
  final String videoPath;
  final File file;
  static const routeName = '/add-clickies';

  const AddClickies({super.key, required this.videoPath, required this.file});

  @override
  State<AddClickies> createState() => _AddClickiesState();
}

class _AddClickiesState extends State<AddClickies> {
  late VideoPlayerController _controller;
  final TextEditingController _captionController = TextEditingController();

  List<MultiSelectItem<Product>> productItems = [];
  List _selectedProducts = [];
  bool _isLoading = false;
  bool _isPlaying = true;

  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  @override
  void initState() {
    super.initState();
    setState(() {
      _controller = VideoPlayerController.file(widget.file);
    });
    _controller.initialize();
    // controller.play();
    _controller.play();
    _controller.setVolume(1);
    _controller.setLooping(true);
    getProducts();
  }

  getProducts() async {
    QuerySnapshot snapshot = await firebaseFirestore
        .collection(productsCollection)
        .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      List<Product> products = [];
      for (var product in snapshot.docs) {
        products.add(Product(
            id: product['productId'],
            name: product['name'],
            imageUrl: product['imageUrl']));
      }

      productItems = products
          .map((product) => MultiSelectItem<Product>(product, product.name))
          .toList();
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
    _controller.dispose();
  }

  void storeClicky(BuildContext context) async {
    if (_isLoading) {
      return;
    } else {
      if (_selectedProducts.isNotEmpty) {
        List<String> ids = [];
        for (var element in _selectedProducts) {
          ids.add(element.id);
        }
        setState(() {
          _isLoading = true;
        });
        final String res = await uploadVideoController.uploadClickies(
            _captionController.text, ids, widget.file.path);
        if (res == 'success') {
          Get.back();
          showToast("Click uploaded", false);
        } else {
          showToast(res, true);
        }
        setState(() {
          _isLoading = false;
        });
      } else {
        showToast('Please select products', true);
      }
    }
  }

  showToast(String msg, bool isError) {
    context.showToast(msg, isError: isError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_isPlaying) {
                      _controller.pause();
                      _isPlaying = false;
                    } else {
                      _controller.play();
                      _isPlaying = true;
                    }
                  });
                },
                child: AspectRatio(
                  aspectRatio: 1 / 1.5,
                  child: VideoPlayer(_controller),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _captionController,
                      maxLength: 60,
                      decoration: const InputDecoration(
                        hintText: 'Caption',
                        counterText: '',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    MultiSelectBottomSheetField(
                      initialChildSize: 0.4,
                      initialValue: const [],
                      listType: MultiSelectListType.LIST,
                      searchable: true,
                      isDismissible: false,
                      buttonText: const Text("Link Products"),
                      title: const Text("Products"),
                      items: productItems,
                      selectedColor: gradient1,
                      confirmText: Text(
                        'Done',
                        style: TextStyle(color: gradient1),
                      ),
                      cancelText: Text(
                        'Cancel',
                        style: TextStyle(color: greyScale),
                      ),
                      onConfirm: (values) {
                        setState(() {
                          _selectedProducts = values;
                        });
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        chipColor: greyText,
                        scroll: true,
                        textStyle: const TextStyle(color: Colors.white),
                        onTap: (value) {
                          setState(() {
                            _selectedProducts.remove(value);
                          });
                        },
                      ),
                    ),
                    _selectedProducts.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "None selected",
                              style: TextStyle(color: Colors.black54),
                            ))
                        : Container(),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GradientElevatedButton(
                        height: 46,
                        buttonName: _isLoading ? 'Uploading...' : 'Upload',
                        onPressed: () {
                          storeClicky(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}
