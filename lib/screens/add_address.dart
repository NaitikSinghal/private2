import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/resources/address_resource.dart';
import 'package:pherico/screens/address.dart';
import 'package:pherico/utils/text_input.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/round_button_with_icon.dart';
import 'package:pherico/widgets/global/app_bar.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  String dropdownValue = stateList.first;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _flatController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final _phoneFocus = FocusNode();
  final _pincodeFocus = FocusNode();
  final _flatFocus = FocusNode();
  final _areaFocus = FocusNode();
  final _townFocus = FocusNode();
  final _stateFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final Map<String, dynamic> _address = ({
    'id': 0,
    'fullName': '',
    'phone': '',
    'pincode': '',
    'flat': '',
    'area': '',
    'city': '',
    'state': '',
  });

  @override
  void dispose() {
    _phoneFocus.dispose();
    _pincodeFocus.dispose();
    _flatFocus.dispose();
    _areaFocus.dispose();
    _townFocus.dispose();
    _stateFocus.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _pincodeController.dispose();
    _flatController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  showToast(String msg, {isError = false}) {
    context.showToast(msg, isError: isError);
  }

  void _saveAddress() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await AddressMethods().addAddress(_address);
      if (res == 'success') {
        showToast('Address added');
        Get.to(() => const MyAddress());
      } else if (res == 'update') {
        showToast('Address updated');
        Get.to(() => const MyAddress());
      } else {
        showToast(res, isError: true);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      showToast(error.toString(), isError: true);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasArguments = ModalRoute.of(context)!.settings.arguments;
    if (hasArguments != null) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _address['id'] = arguments['id'];
      _nameController.text = arguments['fullName'];
      _phoneController.text = arguments['phone'];
      _pincodeController.text = arguments['pincode'];
      _flatController.text = arguments['flat'];
      _areaController.text = arguments['area'];
      _cityController.text = arguments['city'];
      dropdownValue = arguments['state'];
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(
          onPressed: () {
            Navigator.of(context).pop();
          },
          title: 'Add new address',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    autofocus: false,
                    decoration: inputDecoration(fullname),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_phoneFocus);
                    },
                    onSaved: (value) {
                      _address['fullName'] = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please Enter valid name';
                      }
                      if (value.length > 30) {
                        return 'Only 30 characters allowed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    autofocus: false,
                    decoration: inputDecoration(mobileNumber),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _phoneFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_pincodeFocus);
                    },
                    onSaved: (value) {
                      _address['phone'] = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 10) {
                        return 'Please Enter valid phone';
                      }
                      if (value.length > 10) {
                        return 'Only 10 digits allowed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _pincodeController,
                    autofocus: false,
                    decoration: inputDecoration(pincode),
                    textInputAction: TextInputAction.next,
                    focusNode: _pincodeFocus,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_flatFocus);
                    },
                    onSaved: (value) {
                      _address['pincode'] = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return 'Please Enter valid pincode';
                      }
                      if (value.length > 6) {
                        return 'Pincode have 6 digits only';
                      }
                      final number = num.tryParse(value);
                      if (number == null) {
                        return 'Please enter valid pincode';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _flatController,
                    autofocus: false,
                    decoration: inputDecoration(flat),
                    textInputAction: TextInputAction.next,
                    focusNode: _flatFocus,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_areaFocus);
                    },
                    onSaved: (value) {
                      _address['flat'] = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter flat/house no';
                      }
                      if (value.length > 70) {
                        return 'Address seems to be incorrect';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _areaController,
                    autofocus: false,
                    decoration: inputDecoration(area),
                    textInputAction: TextInputAction.next,
                    focusNode: _areaFocus,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_townFocus);
                    },
                    onSaved: (value) {
                      _address['area'] = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      }
                      if (value.length > 70) {
                        return 'Address seems to be incorrect';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _cityController,
                    autofocus: false,
                    decoration: inputDecoration(city),
                    textInputAction: TextInputAction.next,
                    focusNode: _townFocus,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_stateFocus);
                    },
                    onSaved: (value) {
                      _address['city'] = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      }
                      if (value.length > 40) {
                        return 'City name is not valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 6, bottom: 6, left: 12),
                    decoration: BoxDecoration(
                      color: inputBoxColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      isExpanded: true,
                      elevation: 16,
                      iconSize: 28,
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                        _address['state'] = value;
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
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _isLoading
                          ? CircleAvatar(
                              radius: 24,
                              backgroundColor: gradient1,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : RoundButtonWithIcon(
                              height: 52,
                              width: 140,
                              buttonName: 'Save',
                              onPressed: () {
                                _saveAddress();
                              },
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
