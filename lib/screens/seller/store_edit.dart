import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/models/seller/seller.dart';
import 'package:pherico/resources/store_registration.dart';
import 'package:pherico/utils/crop_image.dart';
import 'package:pherico/utils/text_input.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button_with_indicator.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class StoreEdit extends StatefulWidget {
  const StoreEdit({super.key});

  @override
  State<StoreEdit> createState() => _StoreEditState();
}

class _StoreEditState extends State<StoreEdit> {
  final _form = GlobalKey<FormState>();
  String selectedState = stateList.first;
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;
  String error = '';
  Uint8List? _file;
  Uint8List? _croppedFile;
  clearImage() {
    setState(() {
      _file = null;
      _croppedFile = null;
    });
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _bioController.dispose();
    _holderNameController.dispose();
    _accountController.dispose();
    _ifscController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _addressController.dispose();
    super.dispose();
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

  setError(String msg) {
    setState(() {
      error = msg;
    });
  }

  _updateSeller() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    try {
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> data = {
        "shopName": _storeNameController.text,
        "accounHolderName": _holderNameController.text,
        "accountNumber": _accountController.text,
        "ifscNumber": _ifscController.text,
        "address": _addressController.text,
        "city": _cityController.text,
        "state": selectedState,
        "pincode": _pincodeController.text,
        "bio": _bioController.text,
        "file": _file
      };
      String res = await StoreRegistration().updateStore(data);
      if (res == 'storename') {
        setError('Store name already taken');
      } else if (res == 'success') {
        Get.back();
        showToaster('Profile updated');
        clearFields();
        clearImage();
      } else {
        setError(res);
      }
    } catch (err) {
      setError(err.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  showToaster(String msg) {
    context.showToast(msg);
  }

  clearFields() {
    _storeNameController.text = '';
    _holderNameController.text = '';
    _accountController.text = '';
    _ifscController.text = '';
    _addressController.text = '';
    _cityController.text = '';
    _pincodeController.text = '';
    _bioController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    Seller seller = ModalRoute.of(context)!.settings.arguments as Seller;
    selectedState = seller.state;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Edit Store',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            _file != null
                                ? CircleAvatar(
                                    radius: 44,
                                    backgroundImage: MemoryImage(_file!),
                                    backgroundColor: Colors.grey,
                                  )
                                : ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: seller.profile,
                                      fit: BoxFit.cover,
                                      height: 86,
                                      width: 86,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error, size: 40),
                                    ),
                                  ),
                            Positioned(
                              bottom: -2,
                              left: 45,
                              child: IconButton(
                                onPressed: () {
                                  _selectImage(context);
                                },
                                icon: CircleAvatar(
                                  backgroundColor: HexColor('#EBEBEB'),
                                  radius: 20,
                                  child: const Icon(
                                    CupertinoIcons.photo_camera_solid,
                                    color: Color.fromARGB(255, 68, 68, 68),
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 12),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            error.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        TextFormField(
                          controller: _storeNameController
                            ..text = seller.shopName,
                          autofocus: false,
                          decoration: inputDecoration(storeName),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.length < 4) {
                              return 'Atleast 4 charcters needed';
                            }
                            if (value.length > 24) {
                              return 'Only 24 characters allowed';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _bioController..text = seller.bio,
                          autofocus: false,
                          decoration: inputDecoration(storeBio),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          maxLines: 3,
                          validator: (value) {
                            if (value!.length < 12) {
                              return 'Atleast 12 charcters needed';
                            }
                            if (value.length > 224) {
                              return 'Only 224 characters allowed';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _holderNameController
                            ..text = seller.accounHolderName,
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          decoration: inputDecoration(accountHolderName),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.length < 3) {
                              return 'Atleast 4 charcters needed';
                            }
                            if (value.length > 32) {
                              return 'Only 32 characters allowed';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.48,
                              child: TextFormField(
                                controller: _accountController
                                  ..text = seller.accountNumber,
                                autofocus: false,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: inputDecoration(accountNumber),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.length < 9 || value.length > 18) {
                                    return 'Enter valid account number';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextFormField(
                                controller: _ifscController
                                  ..text = seller.ifscNumber,
                                autofocus: false,
                                textInputAction: TextInputAction.next,
                                decoration: inputDecoration(ifscCode),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.length != 11) {
                                    return 'Enter valid ifsc number';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _addressController..text = seller.address,
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          maxLines: 2,
                          decoration: inputDecoration(fullAddress),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.length < 12) {
                              return 'Enter full address ';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _cityController..text = seller.city,
                          autofocus: false,
                          decoration: inputDecoration(city),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.length < 3 || value.length > 99) {
                              return 'Enter valid and full address ';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _pincodeController..text = seller.pincode,
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: inputDecoration(pincode),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.length != 6) {
                              return 'Enter valid pincode number';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              top: 6, bottom: 6, left: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButton<String>(
                            value: selectedState,
                            isExpanded: true,
                            elevation: 16,
                            iconSize: 28,
                            underline: Container(
                              height: 0,
                              color: Colors.transparent,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                selectedState = value!;
                              });
                            },
                            items: stateList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _isLoading
                  ? const Center(child: MyProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GradientElevatedButtonWithIndicator(
                        height: 46,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Update'),
                        onPressed: () {
                          _updateSeller();
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
