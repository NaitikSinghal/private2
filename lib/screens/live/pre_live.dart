import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/screens/live/host.dart';
import 'package:pherico/utils/crop_image.dart';
import 'package:pherico/utils/text_input.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'dart:convert';
import 'package:pherico/widgets/global/app_bar.dart';

// ignore: must_be_immutable
class PreLive extends StatefulWidget {
  String name;
  String profile;
  PreLive({super.key, required this.name, required this.profile});

  @override
  State<PreLive> createState() => _PreLiveState();
}

class _PreLiveState extends State<PreLive> {
  String selectedCategory = '';
  final TextEditingController _titleController = TextEditingController();
  List categories = [];
  List products = [];
  List selectedProducts = [];
  Uint8List? _file;
  Uint8List? _croppedFile;
  clearImage() {
    setState(() {
      _file = null;
      _croppedFile = null;
    });
  }

  String error = '';

  @override
  void initState() {
    super.initState();
    getCategory();
    getProducts();
  }

  getCategory() async {
    QuerySnapshot snapshot =
        await firebaseFirestore.collection(categoryCollection).get();
    for (var element in snapshot.docs) {
      categories.add({'name': element['name'], 'id': element['id']});
    }
    setState(() {});
  }

  getProducts() async {
    QuerySnapshot snapshot = await firebaseFirestore
        .collection(productsCollection)
        .where('user_id', isEqualTo: firebaseAuth.currentUser!.uid)
        .get();
    for (var element in snapshot.docs) {
      products.add({'name': element['name'], 'id': element['product_id']});
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select image'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        _croppedFile = await cropImage(pickedFile);
                        if (_croppedFile != null) {
                          setState(() {
                            _file = _croppedFile;
                          });
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.camera,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Take a photo',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (pickedFile != null) {
                        _croppedFile = await cropImage(pickedFile);
                        if (_croppedFile != null) {
                          setState(() {
                            _file = _croppedFile;
                          });
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Choose from gallery',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Go Live',
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: _titleController,
                      decoration: inputDecoration(liveTitle),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 3) {
                          return 'Please Enter title';
                        }
                        if (value.length > 40) {
                          return 'Only 40 characters allowed';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomSearchableDropDown(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      showLabelInMenu: true,
                      primaryColor: gradient1,
                      labelStyle: TextStyle(
                          color: gradient1, fontWeight: FontWeight.bold),
                      items: categories,
                      label: 'Select category',
                      onChanged: (value) {
                        if (value != null) {
                          selectedCategory = value['id'].toString();
                        }
                      },
                      dropDownMenuItems: categories.map((e) {
                        return e['name'];
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomSearchableDropDown(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      showLabelInMenu: true,
                      primaryColor: gradient1,
                      labelStyle: TextStyle(
                          color: gradient1, fontWeight: FontWeight.bold),
                      items: products,
                      label: 'Select products',
                      multiSelectTag: 'Products',
                      multiSelect: true,
                      onChanged: (value) {
                        if (value != null) {
                          if (selectedProducts.length > 4) {
                            context.showToast(
                                isError: true,
                                'Only 4 products can be selelcted');
                            Navigator.of(context).pop();
                          } else {
                            List dummy = jsonDecode(value);
                            selectedProducts.clear();
                            dummy.forEach((element) {
                              selectedProducts.add(element['id']);
                            });

                            // selectedProducts = jsonDecode(value);
                          }
                        } else {
                          selectedProducts.clear();
                        }
                      },
                      dropDownMenuItems: products.map((e) {
                        return e['name'];
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Please select image for live thumbnail',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 92, 91, 91)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        _selectImage(context);
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 226, 226, 226),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                            image: _file != null
                                ? DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.cover)
                                : null),
                        child: _file != null
                            ? null
                            : const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: GradientElevatedButton(
                height: 46,
                buttonName: 'Continue',
                onPressed: () {
                  continueToNextScreen();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  continueToNextScreen() {
    setState(() {
      error = '';
    });
    if (_titleController.text.length < 5) {
      setState(() {
        error = 'Please enter title';
      });
    } else if (selectedCategory.isEmpty) {
      setState(() {
        error = 'Please select category';
      });
    } else if (selectedProducts.isEmpty) {
      setState(() {
        error = 'Please select atleast one product';
      });
    } else if (_file == null) {
      setState(() {
        error = 'Please select thumbnail image';
      });
    } else {
      Get.to(
          () => Host(
                profile: widget.profile,
                name: widget.name,
                liveTItle: _titleController.text,
                categoryId: selectedCategory,
                productIds: selectedProducts,
                thumbnail: _file!,
              ),
          transition: Transition.rightToLeft);
    }
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
