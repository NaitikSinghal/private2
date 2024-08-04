import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pherico/services/uppercase_input_formatter.dart';
import 'package:pherico/config/my_color.dart';
import 'package:im_stepper/stepper.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/helpers/bank_locator.dart';
import 'package:pherico/helpers/geoservice.dart';
import 'package:pherico/screens/seller/welcome_seller.dart';
import 'package:pherico/resources/store_registration.dart';
import 'package:pherico/utils/crop_image.dart';
import 'package:pherico/widgets/buttons/round_button_with_icon.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';

class BecomeSeller extends StatefulWidget {
  const BecomeSeller({super.key});

  @override
  State<BecomeSeller> createState() => _BecomeSellerState();
}

class _BecomeSellerState extends State<BecomeSeller> {
  String selectedState = stateList.first;
  int activeStep = 0;
  int upperBound = 3;
  String addressType = 'home';
  Uint8List? _file;
  Uint8List? _croppedFile;
  clearImage() {
    setState(() {
      _file = null;
      _croppedFile = null;
    });
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _reAccountController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  String selectedCategory = '';
  int selectedCategoryIndex = 0;
  bool isLoading = false;
  bool isLocationLoading = false;
  bool isFinalLoading = false;
  String nameError = '';
  String bioError = '';
  String categoryError = '';
  String imageError = '';
  String ifscError = '';
  String locationError = '';
  String ifscSuccess = '';
  String accountHolderError = '';
  String accountNumberError = '';
  String reAccountNumberError = '';
  String addressError = '';
  String cityError = '';
  String stateError = '';
  String pincodeError = '';

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _accountController.dispose();
    _reAccountController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _landmarkController.dispose();
    _ifscController.dispose();
    _accountHolderController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(60),
      //   child: CustomAppbar(
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //     title: '',
      //   ),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconStepper(
                icons: [
                  Icon(
                    Icons.store,
                    color: activeStep == 0 ? Colors.white : Colors.black,
                  ),
                  Icon(
                    Icons.category,
                    color: activeStep == 1 ? Colors.white : Colors.black,
                  ),
                  Icon(
                    Icons.account_balance,
                    color: activeStep == 2 ? Colors.white : Colors.black,
                  ),
                  Icon(
                    Icons.local_shipping,
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
                lineLength: 44,
                lineColor: gradient1,
                stepColor: greyColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: centerContent(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                child: isFinalLoading
                    ? const MyProgressIndicator()
                    : RoundButtonWithIcon(
                        height: 46,
                        buttonName: isLoading ? 'Please wait' : 'continue',
                        onPressed: () {
                          backendProcess();
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget centerContent(BuildContext context) {
    switch (activeStep) {
      case 1:
        return categoryWidget();

      case 2:
        return bankDetails();

      case 3:
        return addressWidget(context);
      default:
        return storeNameWidget(context);
    }
  }

  Widget storeNameWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
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
                              imageUrl:
                                  'https://aartigroup.co/wp-content/uploads/blank-img.jpg',
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
                      bottom: 0,
                      left: 52,
                      child: IconButton(
                        onPressed: () {
                          _selectImage(context);
                        },
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                imageError != ''
                    ? const Text(
                        'Please select image ',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.red),
                      )
                    : const Text(
                        'Upload store image',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select a unique name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  controller: _nameController,
                  maxLength: 60,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Ex-Nilasish Clothes',
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
                Text(
                  nameError,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  'Say something about your store(255)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  controller: _bioController,
                  maxLength: 250,
                  maxLines: 3,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Ex-We deal with....',
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
                Text(
                  bioError,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose your category',
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            'Select the categories that define your store',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 4,
          ),
          categoryError != ''
              ? Text(
                  categoryError,
                  style: const TextStyle(color: Colors.red),
                )
              : Container(),
          const SizedBox(
            height: 22,
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: firebaseFirestore
                  .collection(categoryCollection)
                  .where('status', isEqualTo: true)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: MyProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                } else {
                  selectedCategory = snapshot.data!.docs[0]['id'];
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          key: UniqueKey(),
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onTap: () {
                            setState(() {
                              selectedCategory =
                                  snapshot.data!.docs[index]['id'];
                              selectedCategoryIndex = index;
                            });
                          },
                          title: Text(
                            snapshot.data!.docs[index]['name'],
                            style: const TextStyle(color: Colors.black),
                          ),
                          trailing: Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              side: const BorderSide(
                                width: 0.8,
                                color: Colors.black,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              checkColor: Colors.white,
                              activeColor: gradient1,
                              value:
                                  selectedCategoryIndex == index ? true : false,
                              onChanged: (bool? value) {
                                setState(() {
                                  selectedCategory =
                                      snapshot.data!.docs[index]['id'];
                                  selectedCategoryIndex = index;
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget bankDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Add your bank details',
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            const SizedBox(
              height: 4,
            ),
            const Text(
              'To receive your payment',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 22,
            ),
            TextFormField(
              controller: _accountHolderController,
              maxLength: 60,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Account Holder Name',
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
            accountHolderError != ''
                ? Text(
                    accountHolderError,
                    style: const TextStyle(color: Colors.red),
                  )
                : Container(),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _accountController,
              maxLength: 32,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Account Number',
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
            accountNumberError != ''
                ? Text(
                    accountNumberError,
                    style: const TextStyle(color: Colors.red),
                  )
                : Container(),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _reAccountController,
              maxLength: 32,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Re-enter Account Number',
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
            reAccountNumberError != ''
                ? Text(
                    reAccountNumberError,
                    style: const TextStyle(color: Colors.red),
                  )
                : Container(),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _ifscController,
              maxLength: 11,
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: InputDecoration(
                counterText: '',
                hintText: 'IFSC Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: greyColor, width: 0.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: greyColor, width: 0.5),
                ),
              ),
              onChanged: (String value) async {
                if (value.length == 11) {
                  List res = await BankLocator().getBankAddress(value);
                  if (res[0]['status'] == 200) {
                    setState(() {
                      ifscSuccess = res[0]['message'];
                      ifscError = '';
                    });
                  }
                } else {
                  setState(() {
                    ifscSuccess = '';
                    ifscError = 'Please enter valid ifsc code';
                  });
                }
              },
            ),
            ifscSuccess != ''
                ? Text(
                    ifscSuccess,
                    style: const TextStyle(color: Colors.green),
                  )
                : Container(),
            ifscError != ''
                ? Text(
                    ifscError,
                    style: const TextStyle(color: Colors.red),
                  )
                : Container(),
            Text(
              nameError,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget addressWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose your pickup address',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(
              height: 4,
            ),
            isLocationLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: () {
                      getUserCurrentAddress(context);
                    },
                    icon: const Icon(Icons.my_location),
                    label: const Text('Get current location'),
                  ),
            Text(
              locationError,
              style: const TextStyle(color: Colors.red),
            ),
            TextFormField(
              controller: _addressController,
              maxLines: 3,
              maxLength: 250,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Complete address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: greyColor, width: 0.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: greyColor, width: 1),
                ),
              ),
            ),
            addressError != ''
                ? Text(
                    addressError,
                    style: const TextStyle(color: Colors.red),
                  )
                : Container(),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _cityController,
              maxLength: 28,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'City',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: greyColor, width: 0.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: greyColor, width: 1),
                ),
              ),
            ),
            cityError != ''
                ? Text(
                    cityError,
                    style: const TextStyle(color: Colors.red),
                  )
                : Container(),
            const SizedBox(
              height: 12,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 6, bottom: 6, left: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    width: 1, color: Colors.grey, style: BorderStyle.solid),
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
                items: stateList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            stateError != ''
                ? Text(
                    stateError,
                    style: const TextStyle(color: Colors.red),
                  )
                : Container(),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _pincodeController,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'pincode',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: greyColor, width: 0.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: greyColor, width: 1),
                ),
              ),
            ),
            pincodeError != ''
                ? Text(
                    pincodeError,
                    style: const TextStyle(color: Colors.red),
                  )
                : Container(),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _landmarkController,
              decoration: InputDecoration(
                hintText: 'Landmark(Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: greyColor, width: 0.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: greyColor, width: 1),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'Save address as',
              style: TextStyle(fontSize: 16),
            ),
            radioButtons(),
          ],
        ),
      ),
    );
  }

  Widget radioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio(
              value: 'home',
              groupValue: addressType,
              onChanged: (value) {
                setState(() {
                  addressType = value.toString();
                });
              },
              activeColor: gradient1,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const Text('Home'),
          ],
        ),
        Row(
          children: [
            Radio(
              value: 'store',
              groupValue: addressType,
              onChanged: (value) {
                setState(() {
                  addressType = value.toString();
                });
              },
              activeColor: gradient1,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const Text('Store'),
          ],
        ),
        Row(
          children: [
            Radio(
              value: 'godown',
              groupValue: addressType,
              onChanged: (value) {
                setState(() {
                  addressType = value.toString();
                });
              },
              activeColor: gradient1,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const Text('Godown'),
          ],
        ),
      ],
    );
  }

  backendProcess() {
    switch (activeStep) {
      case 0:
        storeNameHandler();
        break;
      case 1:
        categoryHandler();
        break;
      case 2:
        bankHandler();
        break;
      case 3:
        addressHandler();
        break;
      default:
        break;
    }
  }

  storeNameHandler() async {
    setState(() {
      nameError = '';
      imageError = '';
      bioError = '';
    });
    if (_nameController.text.length < 4) {
      setState(() {
        nameError = 'Please enter valid name';
      });
    } else if (_nameController.text.length > 32) {
      setState(() {
        nameError = 'Name should have less than 32 characters';
      });
    } else if (_bioController.text.length < 10) {
      setState(() {
        bioError = 'Please say something about store...';
      });
    } else if (_file == null) {
      setState(() {
        imageError = 'Please upload image';
      });
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        String result =
            await StoreRegistration().checkStoreName(_nameController.text);
        if (result == 'success') {
          setState(() {
            nameError = 'Sorry, this name is already taken';
          });
        } else {
          setState(() {
            if (activeStep < upperBound) {
              setState(() {
                activeStep++;
              });
            }
          });
        }
      } catch (e) {
        setState(() {
          nameError = 'Something went wrong!';
        });
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  categoryHandler() {
    if (selectedCategory == '') {
      setState(() {
        categoryError = 'Please select Category';
      });
    } else {
      setState(() {
        if (activeStep < upperBound) {
          setState(() {
            activeStep++;
          });
        }
      });
    }
  }

  bankHandler() {
    setState(() {
      accountHolderError = '';
      accountNumberError = '';
      reAccountNumberError = '';
      ifscError = '';
    });
    if (_accountHolderController.text == '' ||
        _accountHolderController.text.length < 4) {
      setState(() {
        accountHolderError = 'Please enter valid account holder name';
      });
    } else if (_accountController.text == '' ||
        _accountController.text.length < 8) {
      setState(() {
        accountNumberError = 'Please enter valid account number';
      });
    } else if (_accountController.text != _reAccountController.text) {
      setState(() {
        reAccountNumberError = 'Re-Account number not matched';
      });
    } else if (_ifscController.text == '' ||
        _ifscController.text.length != 11) {
      setState(() {
        ifscError = 'Please enter valid ifsc';
      });
    } else {
      setState(() {
        if (activeStep < upperBound) {
          setState(() {
            activeStep++;
          });
        }
      });
    }
  }

  addressHandler() async {
    setState(() {
      addressError = '';
      cityError = '';
      pincodeError = '';
    });
    if (_addressController.text == '' || _addressController.text.length < 16) {
      setState(() {
        addressError = 'Please enter valid address';
      });
    } else if (_cityController.text == '' || _cityController.text.length < 3) {
      setState(() {
        cityError = 'Please enter valid city name';
      });
    } else if (_pincodeController.text.length != 6) {
      setState(() {
        pincodeError = 'Please enter valid pincode';
      });
    } else {
      Map<String, dynamic> data = {
        "shopName": _nameController.text,
        "categoryId": selectedCategory,
        "accounHolderName": _accountHolderController.text,
        "accountNumber": _accountController.text,
        "ifscNumber": _ifscController.text,
        "address": _addressController.text,
        "city": _cityController.text,
        "state": selectedState,
        "pincode": _pincodeController.text,
        "landmark": _landmarkController.text,
        "addressType": addressType,
        "bio": _bioController.text,
        "file": _file
      };
      setState(() {
        isFinalLoading = true;
        locationError = '';
      });
      String res = await StoreRegistration().createStore(data);
      if (res == 'success') {
        Get.to(() => const WelcomeSeller(), transition: Transition.leftToRight);
      } else {
        setState(() {
          locationError = 'Something went wrong!';
        });
      }
      setState(() {
        isFinalLoading = false;
      });
    }
  }

  getUserCurrentAddress(BuildContext context) async {
    setState(() {
      locationError = '';
      isLocationLoading = true;
    });

    Placemark? placemark = await GeoService().getCurrentAddress(context);
    if (placemark != null) {
      setAddress(placemark);
    } else {
      setState(() {
        locationError = 'Unable to get the address';
      });
    }

    setState(() {
      isLocationLoading = false;
    });
  }

  setAddress(Placemark placemark) {
    setState(() {
      _addressController.text =
          '${placemark.street!}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}';
      _pincodeController.text = placemark.postalCode!;
      _cityController.text = placemark.locality!;
      selectedState = placemark.administrativeArea!;
      addressError = '';
      cityError = '';
      pincodeError = '';
    });
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
}
