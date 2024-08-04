import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/models/color_options.dart';
import 'package:pherico/models/discount_options.dart';
import 'package:pherico/models/policy_options.dart';
import 'package:pherico/models/seller/add_product.dart';
import 'package:pherico/models/seller/product_variant_model.dart';
import 'package:pherico/models/size_option.dart';
import 'package:pherico/resources/product_resource.dart';
import 'package:pherico/screens/seller/product/add_variant_button.dart';
import 'package:pherico/screens/seller/product/product_variant.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/utils/crop_image.dart';
import 'package:pherico/utils/pick_image.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:pherico/utils/product.dart';
import 'package:pherico/utils/text_input.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'package:pherico/widgets/buttons/outlined_button.dart';
import 'package:pherico/widgets/buttons/round_button_with_icon.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:uuid/uuid.dart';

class UploadProduct extends StatefulWidget {
  static const routeName = '/add-product';
  const UploadProduct({super.key});

  @override
  State<UploadProduct> createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  //Errors
  int imageError = 0;

  final List<Uint8List> _selectedImages = [];
  final List<Uint8List> _selectedVariantImages = [];
  bool _isLoading = false;
  List categories = [];
  String selectedCategory = '';
  bool isFreeDelivery = false;
  bool isCod = false;
  bool isWarranty = false;
  bool isColor = false;
  bool isSize = false;
  bool isVariantColor = false;
  bool isVariantSize = false;
  bool isAddVariantBtnPressed = false;
  bool disabledSizeInput = false;
  bool disabledVariantSizeInput = false;
  String selectedPolicy = '';

  final _shortDescFocus = FocusNode();
  final _longDescFocus = FocusNode();
  DiscountOption? _selectedDiscountOption = discountOption[0];
  PolicyOption? _selectedPolicy = policyOptions[0];
  DiscountOption? _selectedVariantDiscountOption = discountOption[0];
  ColorOption? _selectedColor = colorOptions[0];
  ColorOption? _selectedVariantColor = colorOptions[0];
  final List<String> _selectedSizeUnit = [];
  final List<String> _selectedVariantSizeUnit = [];
  int sizeUnitIndexes = 0;
  int variantSizeUnitIndexes = 0;
  final List<TextEditingController> _sizeControllerList = [];
  final List<TextEditingController> _variantSizeControllerList = [];
  final HtmlEditorController _editorController = HtmlEditorController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _shortDescController = TextEditingController();
  final TextEditingController _longDescController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _warrantyController = TextEditingController();
  final TextEditingController _deliveryChargeController =
      TextEditingController();
  final TextEditingController _variantPriceController = TextEditingController();
  final TextEditingController _variantStockController = TextEditingController();

  final TextEditingController _variantDiscountController =
      TextEditingController();
  final TextEditingController _variantSizeController = TextEditingController();
  List<ProductVariantModel> productVariants = [];
  List<Map<String, dynamic>> variants = [];
  int activeStep = 0;
  int upperBound = 3;
  late Size size;
  List<Widget> sizeWidgets = [];

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  getCategory() async {
    QuerySnapshot snapshot =
        await firebaseFirestore.collection(categoryCollection).get();
    for (var element in snapshot.docs) {
      categories.add({'name': element['name'], 'id': element['id']});
    }
    setState(() {});
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _shortDescController.dispose();
    _longDescController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    _deliveryChargeController.dispose();
    _variantPriceController.dispose();
    _variantStockController.dispose();
    _variantDiscountController.dispose();
    super.dispose();
  }

  clearImage() {
    setState(() {
      _selectedImages.clear();
      _selectedVariantImages.clear();
    });
  }

  _selectImage() async {
    XFile? pickedImage = await pickImage(ImageSource.gallery, true);

    if (pickedImage != null) {
      Uint8List? croppedFile = await cropProductImage(pickedImage);
      if (croppedFile != null) {
        setState(() {
          _selectedImages.insert(0, croppedFile);
        });
      } else {}
    }
  }

  _selectVariantImage() async {
    XFile? pickedImage = await pickImage(ImageSource.gallery, true);

    if (pickedImage != null) {
      Uint8List? croppedFile = await cropProductImage(pickedImage);
      if (croppedFile != null) {
        setState(() {
          _selectedVariantImages.add(croppedFile);
        });
      }
    }
  }

  setStep() {
    if (activeStep < upperBound) {
      setState(() {
        activeStep++;
      });
    }
  }

  showToaster(String msg, {bool isError = false}) {
    context.showToast(msg, isError: isError);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          _editorController.clearFocus();
        }
      },
      child: Stack(children: [
        WillPopScope(
          onWillPop: () async {
            clearImage();
            Navigator.of(context).pop();
            return Future.value(false);
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(55),
              child: CustomAppbar(
                title: 'Add product',
                onPressed: () {
                  clearImage();
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconStepper(
                    icons: [
                      Icon(
                        Icons.image,
                        color: activeStep == 0 ? Colors.white : Colors.black,
                      ),
                      Icon(
                        CupertinoIcons.square_favorites_alt_fill,
                        color: activeStep == 1 ? Colors.white : Colors.black,
                      ),
                      Icon(
                        CupertinoIcons.cube_box_fill,
                        color: activeStep == 2 ? Colors.white : Colors.black,
                      ),
                      Icon(
                        CupertinoIcons.collections_solid,
                        color: activeStep == 3 ? Colors.white : Colors.black,
                      ),
                    ],
                    enableNextPreviousButtons: false,
                    enableStepTapping: false,
                    activeStep: activeStep,
                    activeStepColor: gradient1,
                    activeStepBorderWidth: 0,
                    activeStepBorderPadding: 0,
                    stepRadius: 20,
                    lineLength: size.width / 4 - 42,
                    lineColor: gradient1,
                    stepColor: greyColor,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: content(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: _isLoading
                        ? const MyProgressIndicator()
                        : RoundButtonWithIcon(
                            height: 46,
                            buttonName: activeStep == 3 ? 'Done' : 'continue',
                            onPressed: () {
                              onButtonPressed();
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget content() {
    switch (activeStep) {
      case 0:
        return selectProductImages();
      case 1:
        return productDetails();
      case 2:
        return colorSizePrice();
      case 3:
        return variant();
      default:
        return selectProductImages();
    }
  }

  onButtonPressed() {
    switch (activeStep) {
      case 0:
        imageHandler();
        break;
      case 1:
        productDetailsHandler();
        break;
      case 2:
        priceSizeColorHandler();
        break;
      case 3:
        saveProductDetails();
        break;
      default:
        break;
    }
  }

  Widget selectProductImages() {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        InkWell(
          onTap: () {
            _selectImage();
          },
          child: Container(
            height: size.width * 0.52,
            width: size.height * 0.24,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 226, 226, 226),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/icons/camera.svg',
                  height: size.height * 0.07,
                ),
                const Text(
                  'Add minimum 2 photos',
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        _selectedImages.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.only(bottom: 12),
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: _selectedImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12),
                itemBuilder: (context, index) {
                  return Container(
                    height: size.height * 0.1,
                    width: size.width * 0.09,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 226, 226, 226),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: MemoryImage(_selectedImages[index]),
                        fit: BoxFit.cover,
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedImages.removeAt(index);
                        });
                      },
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.white,
                            child: Icon(
                              CupertinoIcons.clear,
                              size: 15,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                })
            : Container(),
      ],
    );
  }

  Widget productDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSearchableDropDown(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0), color: inputBoxColor),
          padding: const EdgeInsets.symmetric(vertical: 12),
          showLabelInMenu: true,
          primaryColor: gradient1,
          labelStyle: TextStyle(color: gradient1, fontWeight: FontWeight.bold),
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
          height: 8,
        ),
        TextFormField(
          controller: _productNameController,
          autofocus: false,
          decoration: inputDecoration(productName),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_shortDescFocus);
          },
        ),
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          controller: _shortDescController,
          autofocus: false,
          decoration: inputDecoration(shortDesc),
          textInputAction: TextInputAction.next,
          focusNode: _shortDescFocus,
          keyboardType: TextInputType.text,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_longDescFocus);
          },
        ),
        const SizedBox(
          height: 12,
        ),
        // HtmlEditor(
        //   controller: _editorController,
        //   htmlEditorOptions: const HtmlEditorOptions(
        //       hint: "Specifications", shouldEnsureVisible: true),
        //   htmlToolbarOptions: HtmlToolbarOptions(
        //     buttonSelectedColor: gradient1,
        //     toolbarItemHeight: 28,
        //     defaultToolbarButtons: [
        //       const FontButtons(
        //         bold: true,
        //         italic: true,
        //         underline: true,
        //         clearAll: false,
        //         subscript: true,
        //         superscript: true,
        //         strikethrough: true,
        //       ),
        //       const ListButtons(listStyles: false),
        //     ],
        //     toolbarType: ToolbarType.nativeScrollable,
        //   ),
        //   otherOptions: const OtherOptions(
        //     height: 400,
        //   ),
        //   plugins: [
        //     SummernoteAtMention(
        //       getSuggestionsMobile: (String value) {
        //         List<String> mentions = ['test1', 'test2', 'test3'];
        //         return mentions
        //             .where((element) => element.contains(value))
        //             .toList();
        //       },
        //     ),
        //   ],
        // ),
        TextFormField(
          controller: _longDescController,
          maxLines: 12,
          autofocus: false,
          decoration: inputDecoration(longDesc),
          textInputAction: TextInputAction.next,
          focusNode: _longDescFocus,
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }

  Widget colorSizePrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: size.width * 0.35,
              child: TextFormField(
                controller: _priceController,
                autofocus: false,
                decoration: inputDecoration(price),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^[1-9][0-9]*'),
                  )
                ],
              ),
            ),
            SizedBox(
              width: size.width * 0.35,
              child: TextFormField(
                controller: _discountController,
                autofocus: false,
                decoration: inputDecoration(discountedPrice),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^[1-9][0-9]*'),
                  )
                ],
              ),
            ),
            Container(
              width: size.width * 0.15,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: inputBoxColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<DiscountOption>(
                isExpanded: true,
                value: _selectedDiscountOption,
                borderRadius: BorderRadius.circular(10),
                dropdownColor: inputBoxColor,
                underline: const SizedBox(),
                onChanged: (DiscountOption? newValue) {
                  setState(() {
                    _selectedDiscountOption = newValue!;
                  });
                },
                items: discountOption.map<DropdownMenuItem<DiscountOption>>(
                    (DiscountOption option) {
                  return DropdownMenuItem<DiscountOption>(
                    value: option,
                    child: Text(option.type),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        _discountController.text.isNotEmpty && _priceController.text.isNotEmpty
            ? Row(
                children: [
                  Text(
                    afterDiscount(
                      int.parse(_discountController.text.trim()),
                      _selectedDiscountOption!.type,
                      int.parse(_priceController.text.trim()),
                    ).toString(),
                    style: TextStyle(color: brownText, fontSize: 18),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '$rupeeSymbol${_priceController.text}',
                    style: TextStyle(
                        color: greyText,
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 2,
                        fontSize: 12),
                  ),
                ],
              )
            : Container(),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 26,
                  width: 35,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      value: isColor,
                      activeColor: gradient1,
                      side: BorderSide(color: greyScale),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (bool? value) {
                        setState(() {
                          isColor = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'Color',
                  style: TextStyle(fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(
              width: 36,
            ),
            Row(
              children: [
                SizedBox(
                  height: 26,
                  width: 35,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      value: isSize,
                      activeColor: gradient1,
                      side: BorderSide(color: greyScale),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            isSize = true;
                            TextEditingController controller =
                                TextEditingController();
                            _sizeControllerList.add(controller);
                            sizeUnitIndexes++;
                          } else {
                            isSize = false;
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'Size',
                  style: TextStyle(fontWeight: FontWeight.w500),
                )
              ],
            ),
          ],
        ),
        isColor
            ? Container(
                height: 50,
                margin: const EdgeInsets.only(top: 16),
                width: size.width - 32,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: inputBoxColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<ColorOption>(
                  hint: const Text('Select Color'),
                  borderRadius: BorderRadius.circular(10),
                  underline: const SizedBox(),
                  value: _selectedColor,
                  isExpanded: true,
                  onChanged: (ColorOption? newValue) {
                    setState(() {
                      _selectedColor = newValue;
                    });
                  },
                  items: colorOptions
                      .map<DropdownMenuItem<ColorOption>>((ColorOption option) {
                    return DropdownMenuItem<ColorOption>(
                      value: option,
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: HexColor(option.color),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(option.name),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              )
            : Container(),
        isSize ? addSize() : Container(),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          width: size.width,
          child: TextFormField(
            controller: _stockController,
            autofocus: false,
            decoration: inputDecoration(stock),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^[1-9][0-9]*'),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 26,
                  width: 35,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      value: isFreeDelivery,
                      activeColor: gradient1,
                      side: BorderSide(color: greyScale),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (bool? value) {
                        setState(() {
                          isFreeDelivery = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'Free Delivery?',
                  style: TextStyle(fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(
              width: 22,
            ),
            Row(
              children: [
                SizedBox(
                  height: 26,
                  width: 35,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      value: isCod,
                      activeColor: gradient1,
                      side: BorderSide(color: greyScale),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (bool? value) {
                        print(_selectedSizeUnit);
                        setState(() {
                          isCod = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'COD?',
                  style: TextStyle(fontWeight: FontWeight.w500),
                )
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        isFreeDelivery
            ? Container()
            : SizedBox(
                width: size.width - 32,
                child: TextFormField(
                  controller: _deliveryChargeController,
                  autofocus: false,
                  decoration: inputDecoration(deliveryCharge),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^[1-9][0-9]*'),
                    )
                  ],
                ),
              ),
        const SizedBox(
          height: 12,
        ),
        Container(
          width: size.width,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: inputBoxColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<PolicyOption>(
            isExpanded: true,
            value: _selectedPolicy,
            borderRadius: BorderRadius.circular(10),
            dropdownColor: inputBoxColor,
            underline: const SizedBox(),
            onChanged: (PolicyOption? newValue) {
              setState(() {
                _selectedPolicy = newValue!;
              });
            },
            items: policyOptions
                .map<DropdownMenuItem<PolicyOption>>((PolicyOption option) {
              return DropdownMenuItem<PolicyOption>(
                value: option,
                child: Text(option.name),
              );
            }).toList(),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            SizedBox(
              height: 26,
              width: 35,
              child: Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: isWarranty,
                  activeColor: gradient1,
                  side: BorderSide(color: greyScale),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (bool? value) {
                    setState(() {
                      isWarranty = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Text(
              'Warranty?',
              style: TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        !isWarranty
            ? Container()
            : SizedBox(
                width: size.width - 32,
                child: TextFormField(
                  controller: _warrantyController,
                  autofocus: false,
                  decoration: inputDecoration(warranty),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                ),
              ),
      ],
    );
  }

  Widget variant() {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: productVariants.length,
          itemBuilder: (context, index) {
            return ProductVariant(
              onTap: () {
                setState(() {
                  productVariants.removeAt(index);
                });
              },
              products: productVariants[index],
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
        isAddVariantBtnPressed
            ? Container()
            : AddVariantButton(
                onTap: () {
                  setState(() {
                    isAddVariantBtnPressed = !isAddVariantBtnPressed;
                  });
                },
                icon: Icons.add,
              ),
        const SizedBox(
          height: 12,
        ),
        addVariantSheet(),
      ],
    );
  }

  Widget addVariantSheet() {
    return isAddVariantBtnPressed
        ? Card(
            color: cardBg,
            elevation: 0,
            shape: borderShape(radius: 12),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: size.width * 0.32,
                        child: TextFormField(
                          controller: _variantPriceController,
                          autofocus: false,
                          decoration: inputDecoration(price),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^[1-9][0-9]*'),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.32,
                        height: 50,
                        child: TextFormField(
                          controller: _variantDiscountController,
                          autofocus: false,
                          decoration: inputDecoration(discountedPrice),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^[1-9][0-9]*'),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: size.width * 0.15,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: inputBoxColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<DiscountOption>(
                          value: _selectedVariantDiscountOption,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(10),
                          dropdownColor: inputBoxColor,
                          underline: const SizedBox(),
                          onChanged: (DiscountOption? newValue) {
                            setState(() {
                              _selectedVariantDiscountOption = newValue!;
                            });
                          },
                          items: discountOption
                              .map<DropdownMenuItem<DiscountOption>>(
                                  (DiscountOption option) {
                            return DropdownMenuItem<DiscountOption>(
                              value: option,
                              child: Text(option.type),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  _variantDiscountController.text.isNotEmpty &&
                          _variantPriceController.text.isNotEmpty
                      ? Row(
                          children: [
                            Text(
                              afterDiscount(
                                int.parse(_variantDiscountController.text),
                                _selectedVariantDiscountOption!.type,
                                int.parse(_variantPriceController.text),
                              ).toString(),
                              style: TextStyle(color: brownText, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              '$rupeeSymbol${_variantPriceController.text}',
                              style: TextStyle(
                                  color: greyText,
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 2,
                                  fontSize: 12),
                            ),
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 50,
                    width: size.width,
                    child: TextFormField(
                      controller: _variantStockController,
                      autofocus: false,
                      decoration: inputDecoration(stock),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[1-9][0-9]*'),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 26,
                            width: 35,
                            child: Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                value: isVariantColor,
                                activeColor: gradient1,
                                side: BorderSide(color: greyScale),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isVariantColor = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'Color',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 36,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 26,
                            width: 35,
                            child: Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                value: isVariantSize,
                                activeColor: gradient1,
                                side: BorderSide(color: greyScale),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value!) {
                                      isVariantSize = true;
                                      variantSizeUnitIndexes++;
                                      TextEditingController controller =
                                          TextEditingController();
                                      _variantSizeControllerList
                                          .add(controller);
                                    } else {
                                      isVariantSize = false;
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'Size',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ],
                  ),
                  isVariantColor
                      ? Container(
                          height: 50,
                          margin: const EdgeInsets.only(top: 16),
                          width: size.width - 32,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: inputBoxColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<ColorOption>(
                            hint: const Text('Select Color'),
                            borderRadius: BorderRadius.circular(10),
                            underline: const SizedBox(),
                            value: _selectedVariantColor,
                            isExpanded: true,
                            onChanged: (ColorOption? newValue) {
                              setState(() {
                                _selectedVariantColor = newValue;
                              });
                            },
                            items: colorOptions
                                .map<DropdownMenuItem<ColorOption>>(
                                    (ColorOption option) {
                              return DropdownMenuItem<ColorOption>(
                                value: option,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: HexColor(option.color),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(option.name),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      : Container(),
                  isVariantSize ? addVariantSize() : Container(),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _selectVariantImage();
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 226, 226, 226),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 35,
                            color: Color.fromARGB(221, 53, 53, 53),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 84,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 12, top: 12),
                            scrollDirection: Axis.horizontal,
                            itemCount: _selectedVariantImages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 226, 226, 226),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: MemoryImage(
                                        _selectedVariantImages[index]),
                                    fit: BoxFit.cover,
                                    alignment: FractionalOffset.topCenter,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedVariantImages.removeAt(index);
                                    });
                                  },
                                  child: const Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          CupertinoIcons.clear,
                                          size: 15,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyOutlinedButton(
                        height: 44,
                        onPressed: () {
                          setState(() {
                            isAddVariantBtnPressed = false;
                          });
                        },
                        buttonName: 'Cancel',
                        width: size.width / 2 - 36,
                      ),
                      GradientElevatedButton(
                        buttonName: 'Add',
                        height: 46,
                        width: size.width / 2 - 36,
                        onPressed: () {
                          variantHandler();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  imageHandler() {
    if (_selectedImages.length < 2) {
      showToaster('Please select image', isError: true);
    } else {
      setStep();
    }
  }

  productDetailsHandler() {
    if (selectedCategory.isEmpty) {
      showToaster(isError: true, 'Select category');
      return;
    } else if (_productNameController.text.isEmpty ||
        _productNameController.text.length < 3) {
      showToaster(isError: true, 'Enter product name');
      return;
    } else if (_shortDescController.text.isEmpty ||
        _shortDescController.text.length < 10) {
      showToaster(isError: true, 'Enter short desccription');
      return;
    } else if (_longDescController.text.isEmpty ||
        _longDescController.text.length < 10) {
      showToaster(isError: true, 'Please enter long desccription');
      return;
    } else {
      setStep();
    }
  }

  priceSizeColorHandler() {
    if (_priceController.text.isEmpty) {
      showToaster(isError: true, 'Enter product price');
      return;
    } else if (_discountController.text.isEmpty) {
      showToaster(isError: true, 'Please enter discount');
      return;
    } else if (!isFreeDelivery && _deliveryChargeController.text.isEmpty) {
      showToaster(isError: true, 'Enter delivery charge');
      return;
    } else if (isWarranty && _warrantyController.text.isEmpty) {
      showToaster(isError: true, 'Please enter warranty');
      return;
    } else {
      setStep();
    }
  }

  variantHandler() {
    if (_variantPriceController.text.isEmpty) {
      showToaster(isError: true, 'Please enter price');
      return;
    } else if (_variantStockController.text.isEmpty) {
      showToaster(isError: true, 'Please enter stock');
      return;
    } else if (_variantDiscountController.text.isEmpty) {
      showToaster(isError: true, 'Please enter discount');
      return;
    } else if (!isVariantColor && !isVariantSize) {
      showToaster(isError: true, 'Please select color or size');
      return;
    } else if (_selectedVariantDiscountOption!.type == '₹' &&
        (int.parse(_variantPriceController.text) <=
            int.parse(_variantDiscountController.text))) {
      showToaster(isError: true, 'Discount can not be greater than price');
      return;
    } else if (_selectedVariantDiscountOption!.type == '%' &&
        int.parse(_variantDiscountController.text) > 90) {
      showToaster(isError: true, 'Discount can not be greater than price');
      return;
    } else if (_selectedVariantImages.isEmpty) {
      showToaster(isError: true, 'Please select image');
      return;
    } else {
      List<SizeModel> sizes = [];
      for (int i = 0; i < _selectedVariantSizeUnit.length; i++) {
        sizes.add(SizeModel(
            size: _variantSizeControllerList[i].text.trim(),
            unit: _selectedVariantSizeUnit[i]));
      }

      productVariants.add(
        ProductVariantModel(
          color: isVariantColor ? _selectedColor!.name : '',
          colorCode: isVariantColor ? _selectedColor!.color : '',
          price: int.parse(_variantPriceController.text),
          stocks: int.parse(_variantStockController.text),
          discount: int.parse(_variantDiscountController.text),
          discountUnit: _selectedVariantDiscountOption!.type,
          size: sizes,
          images: _selectedVariantImages.toList(),
        ),
      );

      setState(() {
        isAddVariantBtnPressed = false;
        _variantPriceController.clear();
        _variantStockController.clear();
        _variantDiscountController.clear();
        _variantSizeController.clear();
        isVariantSize = false;
        isVariantColor = false;
        _selectedVariantImages.clear();
      });
    }
  }

  saveProductDetails() async {
    if (isAddVariantBtnPressed) {
      showToaster(isError: true, 'Add variant details');
      return;
    } else {
      try {
        setState(() {
          _isLoading = true;
        });

        // String? specification = await _editorController.getText();
        List<SizeModel> sizes = [];
        for (int i = 0; i < _selectedSizeUnit.length; i++) {
          sizes.add(SizeModel(
              size: _sizeControllerList[i].text.trim(),
              unit: _selectedSizeUnit[i]));
        }

        String productId = const Uuid().v1();
        AddProduct product = AddProduct(
          name: _productNameController.text.trim(),
          userId: firebaseAuth.currentUser!.uid,
          categoryId: selectedCategory,
          color: isColor ? _selectedColor!.name : '',
          colorCode: isColor ? _selectedColor!.color : '',
          sizes: sizes,
          price: int.parse(_priceController.text.trim()),
          discount: int.parse(_discountController.text.trim()),
          discountUnit: _selectedDiscountOption!.type,
          shortDesc: _shortDescController.text.trim(),
          longDesc: _longDescController.text.trim(),
          imageUrl: '',
          productId: productId,
          images: _selectedImages.toList(),
          isCod: isCod,
          policy: _selectedPolicy!.value,
          deliveryCharge: isFreeDelivery
              ? 0
              : int.parse(_deliveryChargeController.text.trim()),
          stocks: int.parse(_stockController.text.trim()),
          variants: productVariants,
          orders: 0,
          subcategoryId: "",
          specification: '',
          highlights: "",
          slug: _productNameController.text.trim(),
          isWarranty: isWarranty,
          warranty:
              isWarranty ? _warrantyController.text.trim() : 'No Warranty',
          brand: "",
          model: "",
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        );

        String res = await postProduct(product);
        if (res == 'success') {
          showToaster('Product uploaded');
          Get.back();
        } else {
          showToaster('Something went wrong', isError: true);
        }
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  addSize() {
    return SizedBox(
      height: sizeUnitIndexes * 66,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sizeUnitIndexes,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.38,
                  height: 50,
                  child: TextFormField(
                    controller: _sizeControllerList[index],
                    autofocus: false,
                    decoration: inputDecoration('Size'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[0-9.]"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Container(
                  height: 50,
                  width: size.width * 0.38,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: inputBoxColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedSizeUnit.length > index
                        ? _selectedSizeUnit[index]
                        : null,
                    isExpanded: true,
                    hint: const Text('Select size'),
                    borderRadius: BorderRadius.circular(10),
                    dropdownColor: inputBoxColor,
                    underline: const SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {
                        if (_selectedSizeUnit.length > index) {
                          _selectedSizeUnit[index] = newValue!;
                          if (newValue == 'S' ||
                              newValue == 'M' ||
                              newValue == 'L' ||
                              newValue == 'XL' ||
                              newValue == 'XXL' ||
                              newValue == 'XXL') {
                            _sizeControllerList[index].text = newValue;
                          }
                        } else {
                          _selectedSizeUnit.add(newValue!);
                        }
                      });
                    },
                    items: sizeOptionString
                        .map<DropdownMenuItem<String>>((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Center(
                    child: index > 0
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                sizeUnitIndexes = sizeUnitIndexes - 1;
                                _selectedSizeUnit.removeAt(index);
                              });
                            },
                            icon: Icon(
                              CupertinoIcons.clear_circled_solid,
                              color: red,
                              size: 26,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              if (sizeUnitIndexes < 7) {
                                TextEditingController controller =
                                    TextEditingController();
                                setState(() {
                                  _sizeControllerList.add(controller);
                                  sizeUnitIndexes++;
                                });
                              }
                            },
                            icon: Icon(
                              CupertinoIcons.add_circled_solid,
                              color: gradient1,
                              size: 28,
                            ),
                          ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  addVariantSize() {
    return SizedBox(
      height: variantSizeUnitIndexes * 66,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: variantSizeUnitIndexes,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.38,
                  height: 50,
                  child: TextFormField(
                    controller: _variantSizeControllerList[index],
                    autofocus: false,
                    decoration: inputDecoration('Size'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[0-9.]"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Container(
                  height: 50,
                  width: size.width * 0.38,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: inputBoxColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedVariantSizeUnit.length > index
                        ? _selectedVariantSizeUnit[index]
                        : null,
                    isExpanded: true,
                    hint: const Text('Select size'),
                    borderRadius: BorderRadius.circular(10),
                    dropdownColor: inputBoxColor,
                    underline: const SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {
                        if (_selectedVariantSizeUnit.length > index) {
                          _selectedVariantSizeUnit[index] = newValue!;
                          if (newValue == 'S' ||
                              newValue == 'M' ||
                              newValue == 'L' ||
                              newValue == 'XL' ||
                              newValue == 'XXL' ||
                              newValue == 'XXL') {
                            _variantSizeControllerList[index].text = newValue;
                          }
                        } else {
                          _selectedVariantSizeUnit.add(newValue!);
                        }
                      });
                    },
                    items: sizeOptionString
                        .map<DropdownMenuItem<String>>((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Center(
                    child: index > 0
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                variantSizeUnitIndexes =
                                    variantSizeUnitIndexes - 1;
                                _selectedVariantSizeUnit.removeAt(index);
                              });
                            },
                            icon: Icon(
                              CupertinoIcons.clear_circled_solid,
                              color: red,
                              size: 26,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              if (variantSizeUnitIndexes < 7) {
                                TextEditingController controller =
                                    TextEditingController();
                                setState(() {
                                  variantSizeUnitIndexes =
                                      variantSizeUnitIndexes + 1;
                                  _variantSizeControllerList.add(controller);
                                });
                              }
                            },
                            icon: Icon(
                              CupertinoIcons.add_circled_solid,
                              color: gradient1,
                              size: 28,
                            ),
                          ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> showIndicatorDialog(BuildContext context) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: borderShape(radius: 12),
          contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.1),
          children: const [
            Column(
              children: [
                MyProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text('Product uploading...'),
              ],
            )
          ],
        );
      },
    );
  }
}
