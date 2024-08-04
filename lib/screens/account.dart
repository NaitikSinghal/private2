import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/models/user.dart';
import 'package:pherico/resources/auth_methods.dart';
import 'package:pherico/screens/seller/seller_account.dart';
import 'package:pherico/utils/crop_image.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'package:pherico/widgets/global/image_popup.dart';
import 'package:pherico/widgets/profile/profile_header.dart';
import 'package:pherico/widgets/profile/profile_menu.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  showToast(String msg, bool isError) {
    context.showToast(msg, isError: isError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: firebaseFirestore
              .collection(usersCollection)
              .doc(firebaseAuth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return const Center(
                  child: Text('An error occured!'),
                );
              } else {
                User user = User.fromSnap(snapshot.data!);
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .24,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.20,
                            width: MediaQuery.of(context).size.width,
                            imageUrl: user.cover,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 12,
                            top: 12,
                            child: InkWell(
                              onTap: () {
                                _selectImage();
                              },
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: HexColor('#EBEBEB'),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: (MediaQuery.of(context).size.width / 2) - 38,
                            child: InkWell(
                              onTap: () async {
                                await showDialog(
                                  context: context,
                                  builder: (_) =>
                                      ImagePopup(image: user.profile),
                                );
                              },
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: user.profile,
                                  fit: BoxFit.cover,
                                  height: 70,
                                  width: 70,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error, size: 40),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: ProfileHeader(
                          name: '${user.firstName} ${user.lastName}',
                          profile: user.profile,
                          following: user.following.length),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: GradientElevatedButton(
                                width: 140,
                                height: 44,
                                buttonName: 'Buyer',
                                onPressed: (() {}),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.09),
                              child: TextButton(
                                onPressed: () {
                                  Get.to(() => const SellerAccount(),
                                      transition: Transition.fadeIn);
                                },
                                child: Text(
                                  'Seller',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ProfileMenu(
                          user: user,
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }

  _selectImage() async {
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
                        Uint8List? croppedFile =
                            await cropCoverImage(pickedFile);
                        if (croppedFile != null) {
                          showToast('Uploading', false);
                          await AuthMethods.updateCover(croppedFile);
                          showToast('Cover updated', false);
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
                        Uint8List? croppedFile =
                            await cropCoverImage(pickedFile);
                        if (croppedFile != null) {
                          showToast('Uploading', false);
                          await AuthMethods.updateCover(croppedFile);
                          showToast('Cover updated', false);
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
