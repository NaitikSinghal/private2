import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/config/text_size.dart';
import 'package:pherico/models/seller/seller.dart';
import 'package:pherico/resources/seller_resources.dart';
import 'package:pherico/screens/chats/chat.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/utils/color.dart';
import 'package:pherico/utils/text_input.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'package:pherico/widgets/buttons/outlined_button.dart';
import 'package:pherico/widgets/global/my_bottom_sheet.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/screens/clicky/seller_profile_clicky_list.dart';
import 'package:pherico/widgets/seller/product/product_list.dart';
import 'package:pherico/widgets/seller/profile/account_cover.dart';

class SellerProfile extends StatefulWidget {
  final String sellerId;
  const SellerProfile({super.key, required this.sellerId});

  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  final TextEditingController _textFieldController = TextEditingController();
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _stream;

  Future<void> _displayTextInputDialog(
      BuildContext context, String sellerId) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          titleTextStyle: TextStyle(fontSize: 16, color: brownText),
          shape: borderShape(radius: 12),
          title: const Text('Write your issue here'),
          content: TextFormField(
            controller: _textFieldController,
            maxLines: 4,
            decoration: inputDecoration('Say something...'),
          ),
          actionsPadding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyOutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    buttonName: 'Cancel'),
                GradientElevatedButton(
                  buttonName: 'Submit',
                  onPressed: () {
                    if (_textFieldController.text.trim().isEmpty) {
                      context.showToast('Field can not be empty',
                          isError: true);
                    } else {
                      reportToSeller(
                          _textFieldController.text.trim(), sellerId);
                      Get.back();
                      context.showToast('Submitted');
                      _textFieldController.text = '';
                    }
                  },
                  height: 41,
                )
              ],
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _stream = firebaseFirestore
        .collection(storeCollection)
        .doc(widget.sellerId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MyProgressIndicator();
            }
            if (snapshot.hasError) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Something went wrong! Please try again after some time',
                    overflow: TextOverflow.visible,
                    softWrap: true,
                    maxLines: 2,
                  ),
                ),
              );
            }
            if (snapshot.hasData && snapshot.data!.data()!.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'No seller found',
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
              );
            }
            Seller seller = Seller.fromJson(snapshot.data!);

            return DefaultTabController(
              length: 3,
              child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        _header(seller, context),
                      ),
                    ),
                  ];
                },
                body: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Text(
                          'Products',
                          style: TextStyle(color: brownText),
                        ),
                        Text('Clickies', style: TextStyle(color: brownText)),
                        Text('Videos', style: TextStyle(color: brownText)),
                      ],
                      labelPadding: const EdgeInsets.all(8),
                      indicatorColor: gradient1,
                      indicatorSize: TabBarIndicatorSize.label,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ProductListSellerProfile(uid: seller.uid),
                          SellerProfileClickyList(uid: seller.uid),
                          ProductListSellerProfile(uid: seller.uid),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _header(Seller sellerData, BuildContext context) {
    return [
      Column(
        children: [
          AccountCoverSeller(
            cover: sellerData.cover,
            profile: sellerData.profile,
            onTap: () {
              showModalBottomSheet(
                shape: bottomSheetBorder,
                context: context,
                builder: (context) {
                  return bottomSheetMenu(sellerData, context);
                },
              );
            },
          ),
          const SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              sellerData.shopName,
              style: TextStyle(
                  color: textColor,
                  fontSize: TextSize.textSize16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Followers | ',
                style: TextStyle(
                    color: gradient1,
                    fontSize: TextSize.textSize14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                sellerData.followers.length < 1000
                    ? sellerData.followers.length.toString()
                    : '${sellerData.followers.length / 1000}k',
                style: TextStyle(
                    color: textColor,
                    fontSize: TextSize.textSize14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          sellerData.uid == firebaseAuth.currentUser!.uid
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sellerData.followers
                              .contains(firebaseAuth.currentUser!.uid)
                          ? MyOutlinedButton(
                              buttonName: 'Unfollow',
                              onPressed: () {
                                unFollowSeller(sellerData.uid);
                              })
                          : GradientElevatedButton(
                              buttonName: 'Follow',
                              onPressed: () {
                                followSeller(sellerData.uid);
                              },
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      MyOutlinedButton(
                        buttonName: 'Message',
                        onPressed: () {
                          Get.to(() => const Chat(),
                              transition: Transition.rightToLeft,
                              arguments: sellerData);
                        },
                      )
                    ],
                  ),
                ),
          Container(
            height: MediaQuery.of(context).size.height * 0.14,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
            decoration: BoxDecoration(
              border: Border.all(color: greyColor),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    desc,
                    style: TextStyle(
                      color: black,
                      fontSize: TextSize.textSize16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        sellerData.bio,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ];
  }

  Widget bottomSheetMenu(Seller sellerData, BuildContext context) {
    return MyBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          firebaseAuth.currentUser!.uid == sellerData.uid
              ? Container()
              : menuListStyle(
                  'assets/images/navigation-icon/comment.svg',
                  'Chat With Seller',
                  () {
                    Get.to(() => const Chat(),
                        arguments: sellerData,
                        transition: Transition.rightToLeft);
                  },
                ),
          firebaseAuth.currentUser!.uid == sellerData.uid
              ? Container()
              : const Divider(
                  thickness: 1,
                ),
          firebaseAuth.currentUser!.uid == sellerData.uid
              ? Container()
              : menuListStyle(
                  'assets/images/icons/heart-add.svg',
                  'Add To Favourites',
                  () {
                    Get.back();
                    addSellerToFavourites(sellerData.uid);
                    context.showToast('Added To Favrioute');
                  },
                ),
          firebaseAuth.currentUser!.uid == sellerData.uid
              ? Container()
              : const Divider(
                  thickness: 1,
                ),
          menuListStyle(
            'assets/images/icons/share.svg',
            'Share To',
            () {},
          ),
          firebaseAuth.currentUser!.uid == sellerData.uid
              ? Container()
              : const Divider(
                  thickness: 1,
                ),
          firebaseAuth.currentUser!.uid == sellerData.uid
              ? Container()
              : ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  leading: const Icon(
                    CupertinoIcons.exclamationmark_circle_fill,
                    size: 28,
                    color: Colors.red,
                  ),
                  contentPadding: const EdgeInsets.only(left: 0, right: 12),
                  horizontalTitleGap: 0,
                  title: const Text(
                    'Report Store',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    _displayTextInputDialog(context, sellerData.uid);
                  },
                ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget menuListStyle(String svg, String label, VoidCallback onTap) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      leading: SvgPicture.asset(
        svg,
        height: 25,
        colorFilter: svgColor(color: iconColor),
      ),
      contentPadding: const EdgeInsets.only(left: 0, right: 12),
      horizontalTitleGap: 0,
      title: Text(
        label,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: brownText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
