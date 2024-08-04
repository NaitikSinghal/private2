import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/models/category_model.dart';
import 'package:pherico/screens/chats/chats.dart';
import 'package:pherico/screens/home/home_live_section.dart';
import 'package:pherico/screens/notifications.dart';
import 'package:pherico/screens/products/product_list.dart';
import 'package:pherico/utils/color.dart';
import 'package:pherico/widgets/buttons/round_button.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:card_swiper/card_swiper.dart';

List<String> imgList = [
  'assets/images/slider/special.png',
  'assets/images/slider/slider_1.png',
  'assets/images/slider/slider_2.png',
];

class MainHome extends HookWidget {
  const MainHome({super.key});

  Future<QuerySnapshot<Map<String, dynamic>>> getCategories() async {
    return await firebaseFirestore.collection(categoryCollection).get();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final future = useMemoized(() async {
      return getCategories();
    });

    final deviceSize = MediaQuery.of(context).size;
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            key: scaffoldKey,
            drawer: Drawer(
              width: deviceSize.width * 0.7,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Shop by category',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            CategoryModel category = CategoryModel.fromSnap(
                                snapshot.data!.docs[index]);
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Get.to(() => const ProductList(),
                                        arguments: category.id.toString(),
                                        transition: Transition.rightToLeft);
                                  },
                                  style: ListTileStyle.drawer,
                                  leading: CircleAvatar(
                                    radius: 22,
                                    backgroundColor:
                                        const Color.fromARGB(12, 223, 73, 67),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: CachedNetworkImage(
                                        imageUrl: category.image,
                                      ),
                                    ),
                                  ),
                                  title:
                                      Text(snapshot.data!.docs[index]['name']),
                                  trailing: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: HexColor('#292D32'),
                                  ),
                                ),
                                const Divider()
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
            appBar: AppBar(
              leadingWidth: 38,
              leading: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: SvgPicture.asset(
                    'assets/images/navigation-icon/3_line.svg',
                    colorFilter: svgColor(color: iconColor),
                  ),
                ),
                onTap: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              ),
              titleSpacing: 10,
              title: Image.asset(
                'assets/images/logo/logo.png',
                fit: BoxFit.contain,
                width: 100,
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 10,
              actions: [
                IconButton(
                  padding: const EdgeInsets.only(right: 8),
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Get.to(() => const UserNotifications(),
                        transition: Transition.leftToRight);
                  },
                  icon: SvgPicture.asset(
                    'assets/images/navigation-icon/bell.svg',
                    colorFilter: svgColor(
                      color: HexColor('#F76436'),
                    ),
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.only(right: 8),
                  onPressed: () {
                    Get.to(() => const Chats(),
                        transition: Transition.leftToRight);
                  },
                  icon: SvgPicture.asset(
                    'assets/images/navigation-icon/chat.svg',
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: deviceSize.width,
                        height: 56,
                        child: FormHelper.inputFieldWidget(
                          context,
                          'search',
                          'What are you looking for...',
                          hintColor: HexColor('#4F5663'),
                          hintFontSize: 13,
                          showPrefixIcon: true,
                          focusedErrorBorderWidth: 0,
                          focusedBorderWidth: 0,
                          enabledBorderWidth: 0,
                          borderFocusColor: Colors.transparent,
                          prefixIcon: Icon(
                            CupertinoIcons.search,
                            color: lightBlack,
                          ),
                          suffixIcon: Icon(
                            Icons.mic,
                            color: lightBlack,
                          ),
                          prefixIconPaddingLeft: 4,
                          prefixIconPaddingRight: 6,
                          borderRadius: 26,
                          paddingLeft: 0,
                          paddingRight: 0,
                          borderColor: Colors.transparent,
                          backgroundColor: HexColor('#F6F6F6'),
                          () {},
                          () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: SizedBox(
                          height: 45,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length + 1,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 16.0, bottom: 2, top: 2),
                                child: index == 0
                                    ? RoundButton(
                                        buttonName: 'Popular',
                                        onPressed: () {},
                                        color: '#ffffff',
                                        bgColorCode: '#40258B',
                                      )
                                    : RoundButton(
                                        buttonName: snapshot
                                            .data!.docs[index - 1]['name'],
                                        onPressed: () {
                                          Get.to(() => const ProductList(),
                                              arguments: snapshot
                                                  .data!.docs[index - 1]['id']
                                                  .toString(),
                                              transition:
                                                  Transition.leftToRight);
                                        },
                                      ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: deviceSize.height / 5,
                        width: deviceSize.width,
                        margin: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 0),
                        child: Swiper(
                            layout: SwiperLayout.CUSTOM,
                            customLayoutOption: CustomLayoutOption(
                                startIndex: -1, stateCount: 3),
                            itemWidth: deviceSize.width,
                            itemHeight: deviceSize.height * 0.2,
                            autoplay: true,
                            autoplayDelay: 3000,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: gradient,
                                  image: DecorationImage(
                                    image: AssetImage(
                                      imgList[index],
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              );
                            },
                            pagination: const SwiperPagination(
                                margin: EdgeInsets.all(5.0),
                                builder: SwiperPagination.dots),
                            itemCount: imgList.length),
                      ),
                      const HomeLiveSection(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
