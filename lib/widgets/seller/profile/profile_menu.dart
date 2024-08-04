import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/screens/seller/analytics.dart';
import 'package:pherico/screens/seller/clickies.dart';
import 'package:pherico/screens/seller/orders/orders.dart';
import 'package:pherico/screens/seller/product/products.dart';
import 'package:pherico/screens/seller/settings.dart';
import 'package:pherico/widgets/profile/profile_menu_item.dart';
import 'package:pherico/widgets/profile/profile_with_svg_image.dart';

class ProfileMenuSeller extends StatelessWidget {
  const ProfileMenuSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          thickness: 1,
        ),
        ProfileMenuItem(
          label: 'Orders',
          icon: CupertinoIcons.cube_box_fill,
          onTap: () {
            Get.to(() => const ReceivedOrders(),
                transition: Transition.leftToRight);
          },
        ),
        const Divider(
          thickness: 1,
        ),
        ProfileMenuSvg(
          label: 'Products',
          path: 'assets/images/icons/product.svg',
          onTap: () {
            Get.to(() => const SellerProducts(),
                transition: Transition.leftToRight);
          },
        ),
        const Divider(
          thickness: 1,
        ),
        ProfileMenuItem(
          label: 'Clickies',
          icon: CupertinoIcons.play_rectangle_fill,
          onTap: () {
            Get.to(() => const SellerClickies(),
                transition: Transition.leftToRight);
          },
        ),
        const Divider(
          thickness: 1,
        ),
        ProfileMenuItem(
          label: 'Live Shows',
          icon: Icons.video_library,
          onTap: () {},
        ),
        const Divider(
          thickness: 1,
        ),
        ProfileMenuSvg(
          label: 'Analytics',
          path: 'assets/images/icons/analytic.svg',
          onTap: () {
            Get.to(() => const Analytics(), transition: Transition.leftToRight);
          },
        ),
        const Divider(
          thickness: 1,
        ),
        ProfileMenuSvg(
          label: 'Settings',
          onTap: () {
            Get.to(() => const StoreSettings(),
                transition: Transition.leftToRight);
          },
          path: 'assets/images/icons/setting.svg',
        ),
        const Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
