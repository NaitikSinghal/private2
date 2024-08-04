import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/seller/seller.dart';
import 'package:pherico/resources/auth_methods.dart';
import 'package:pherico/resources/chat_resource.dart';
import 'package:pherico/resources/store_registration.dart';
import 'package:pherico/screens/become_seller.dart';
import 'package:pherico/screens/live/pre_live.dart';
import 'package:pherico/screens/seller/store_edit.dart';
import 'package:pherico/screens/splash_screen.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/utils/crop_image.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'package:pherico/widgets/buttons/round_button_with_icon.dart';
import 'package:pherico/widgets/global/inside_circle_icon.dart';
import 'package:pherico/widgets/global/inside_circle_svg.dart';
import 'package:pherico/widgets/global/my_bottom_sheet.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/widgets/seller/profile/account_cover.dart';
import 'package:pherico/widgets/seller/profile/profile_header.dart';
import 'package:pherico/widgets/seller/profile/profile_menu.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class SellerAccount extends StatefulWidget {
  const SellerAccount({super.key});

  @override
  State<SellerAccount> createState() => _SellerAccountState();
}

class _SellerAccountState extends State<SellerAccount> {
  bool isSeller = false;

  @override
  void dispose() {
    super.dispose();
  }

  showToast(String msg, bool isError) {
    context.showToast(msg, isError: isError);
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
                        Uint8List? croppedFile =
                            await cropCoverImage(pickedFile);
                        if (croppedFile != null) {
                          uploadCover(croppedFile);
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
                          uploadCover(croppedFile);
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

  uploadCover(Uint8List file) async {
    showToast('Uploading cover', false);
    String res = await StoreRegistration.updateCover(file);
    if (res != 'success') {
      showToast('Failed to upload cover', true);
    } else {
      showToast('Cover updated', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: firebaseFirestore
          .collection(storeCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: SafeArea(child: MyProgressIndicator()));
        } else {
          if (snapshot.hasError) {
            return Scaffold(
              key: UniqueKey(),
              body: const SafeArea(
                child: Center(
                  child: Text('An error occured!'),
                ),
              ),
            );
          } else {
            if (snapshot.hasData) {
              if (snapshot.data!.data()?.length == null) {
                return notASeller(context);
              } else {
                Seller sellerData = Seller.fromJson(snapshot.data!);
                return Scaffold(
                  key: UniqueKey(),
                  body: SafeArea(
                    child: Column(
                      children: [
                        AccountCoverSeller(
                          onTap: () {
                            showModalBottomSheet(
                              shape: bottomSheetBorder,
                              context: context,
                              builder: (context) {
                                return bottomSheetMenu(sellerData);
                              },
                            );
                          },
                          cover: sellerData.cover,
                          profile: sellerData.profile,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: ProfileHeaderSeller(
                              name: sellerData.shopName,
                              followers: sellerData.followers.length,
                              following: sellerData.following.length),
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
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.09),
                                  child: TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'Buyer',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 2.0),
                                  child: GradientElevatedButton(
                                    width: 140,
                                    height: 44,
                                    buttonName: 'Seller',
                                    onPressed: (() {}),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: ProfileMenuSeller(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    heroTag: 'more buttons',
                    onPressed: () {
                      showModalBottomSheet(
                        shape: bottomSheetBorder,
                        context: context,
                        builder: (context) {
                          return floatingMenu(
                              sellerData.shopName, sellerData.profile, context);
                        },
                      );
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            HexColor('#FCD1A9'),
                            HexColor('#FAB575'),
                            HexColor('#F9881F')
                          ],
                        ),
                      ),
                      child: const Icon(
                        CupertinoIcons.add,
                        size: 26,
                      ),
                    ),
                  ),
                );
              }
            } else {
              return const Center(
                child: Text('No data found'),
              );
            }
          }
        }
      },
    );
  }

  Widget bottomSheetMenu(Seller sellerData) {
    return MyBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            visualDensity: const VisualDensity(vertical: -4),
            leading: SvgPicture.asset('assets/images/icons/edit.svg'),
            contentPadding: const EdgeInsets.only(left: 0, right: 12),
            horizontalTitleGap: 0,
            title: Text(
              'Edit Store',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: HexColor('#212D3F'),
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Get.back();
              Get.to(() => const StoreEdit(),
                  transition: Transition.leftToRight, arguments: sellerData);
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.person_crop_rectangle_fill,
              color: Colors.black,
              size: 22,
            ),
            contentPadding: const EdgeInsets.only(left: 0, right: 12),
            horizontalTitleGap: 0,
            title: Text(
              'Edit Cover',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: HexColor('#212D3F'),
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () async {
              Get.back();
              await _selectImage(context);
            },
          ),
          const Divider(
            thickness: 1,
          ),
          TextButton(
            onPressed: () async {
              await ChatResource.updateStatus(false);
              await AuthMethods().signOut();
              Get.offAll(() => const SplashScreen(),
                  transition: Transition.leftToRightWithFade);
            },
            child: Text(
              'Logout',
              style: TextStyle(
                color: HexColor('#018EDE'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget floatingMenu(String shopName, String profile, BuildContext context) {
    return MyBottomSheet(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InsideCircleIcon(
              icon: CupertinoIcons.play_arrow_solid,
              label: 'Upload Clicky',
              onTap: () {},
            ),
            InsideCircleIcon(
              icon: Icons.videocam,
              iconColor: HexColor('#F6212E'),
              borderColor: HexColor('#F6212E'),
              label: 'Go Live',
              onTap: () {
                Navigator.of(context).pop();
                Get.to(
                    () => PreLive(
                          name: shopName,
                          profile: profile,
                        ),
                    transition: Transition.rightToLeft);
              },
            ),
            InsideCircleSvg(
              path: 'assets/images/icons/product.svg',
              label: 'Add Product',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget notASeller(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/logo/cry.png'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              'Oh ho !',
              style: TextStyle(
                  color: greyScale, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Your are not a seller ',
                style: TextStyle(color: greyScale),
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 22,
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: RoundButtonWithIcon(
                height: 46,
                buttonName: 'Become a seller',
                onPressed: () {
                  Get.off(() => const BecomeSeller(),
                      transition: Transition.leftToRight);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
