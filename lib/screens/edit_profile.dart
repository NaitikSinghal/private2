import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/models/user.dart';
import 'package:pherico/resources/auth_methods.dart';
import 'package:pherico/utils/crop_image.dart';
import 'package:pherico/utils/text_input.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button_with_indicator.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../widgets/global/app_bar.dart';

class EditProfile extends StatefulWidget {
  final User user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _form = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  bool _isLoading = false;
  String error = '';
  Uint8List? _file;

  @override
  void dispose() {
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
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
                      Get.back();
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        Uint8List? croppedFile = await cropImage(pickedFile);
                        if (croppedFile != null) {
                          setState(() {
                            _file = croppedFile;
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
                      Get.back();
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (pickedFile != null) {
                        Uint8List? croppedFile = await cropImage(pickedFile);
                        if (croppedFile != null) {
                          setState(() {
                            _file = croppedFile;
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

  showToaster(String msg, isError) {
    context.showToast(msg, isError: isError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Edit Profile',
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
                                      imageUrl: widget.user.profile,
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
                          controller: _usernameController
                            ..text = widget.user.username,
                          autofocus: false,
                          decoration: inputDecoration(username),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_firstNameFocus);
                          },
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return 'Atleast 4 charcters needed';
                            }
                            if (value.length > 20) {
                              return 'Only 20 characters allowed';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _firstNameController
                            ..text = widget.user.firstName,
                          autofocus: false,
                          decoration: inputDecoration(enterFirstName),
                          textInputAction: TextInputAction.next,
                          focusNode: _firstNameFocus,
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_lastNameFocus);
                          },
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return 'Atleast 4 charcters needed';
                            }
                            if (value.length > 20) {
                              return 'Only 20 characters allowed';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _lastNameController
                            ..text = widget.user.lastName,
                          autofocus: false,
                          decoration: inputDecoration(enterLastName),
                          textInputAction: TextInputAction.next,
                          focusNode: _lastNameFocus,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return 'Atleast 4 charcters needed';
                            }
                            if (value.length > 20) {
                              return 'Only 20 characters allowed';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _isLoading
                  ? const MyProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GradientElevatedButtonWithIndicator(
                        height: 46,
                        child: const Text('Update'),
                        onPressed: () async {
                          await _updateProfile();
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  _updateProfile() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      setState(() {
        _isLoading = true;
      });
      String res = '';
      if (_file == null) {
        res = await AuthMethods.updateUserProfileWithoutImage(
          _usernameController.text.trim(),
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
        );
      } else {
        res = await AuthMethods.updateUserProfileWithImage(
          _file!,
          _usernameController.text.trim(),
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
        );
      }
      if (res == 'username') {
        setState(() {
          error = 'Username already taken';
        });
      } else if (res == 'success') {
        showToaster('Profile updated', false);
        _file == null;
        Get.back();
      } else {
        showToaster('Failed to update', true);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      showToaster('Failed to update', true);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
