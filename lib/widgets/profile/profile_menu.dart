import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/models/user.dart';
import 'package:pherico/resources/auth_methods.dart';
import 'package:pherico/resources/chat_resource.dart';
import 'package:pherico/screens/address.dart';
import 'package:pherico/screens/customer_support.dart';
import 'package:pherico/screens/edit_profile.dart';
import 'package:pherico/screens/fav_seller.dart';
import 'package:pherico/screens/notifications.dart';
import 'package:pherico/screens/orders/order_history.dart';
import 'package:pherico/screens/saved_items.dart';
import 'package:pherico/screens/welcome_screen.dart';
import 'package:pherico/widgets/buttons/outlined_button.dart';
import 'package:pherico/widgets/profile/profile_with_svg_image.dart';
import 'profile_menu_item.dart';

class ProfileMenu extends StatelessWidget {
  final User user;
  const ProfileMenu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          thickness: 1,
        ),
        ProfileMenuSvg(
          label: 'Edit Profile',
          path: 'assets/images/navigation-icon/edit_user.svg',
          onTap: () {
            Get.to(
                () => EditProfile(
                      user: user,
                    ),
                transition: Transition.rightToLeft);
          },
        ),
        const Divider(
          thickness: 1,
        ),
        ProfileMenuItem(
          label: 'Orders',
          icon: Icons.shopping_bag,
          onTap: () {
            Get.to(() => const OrderHistory(),
                transition: Transition.rightToLeft);
          },
        ),
        const Divider(
          thickness: 1,
        ),
        ProfileMenuItem(
          label: 'Saved Address',
          icon: Icons.location_on,
          onTap: () {
            Get.to(() => const MyAddress(),
                transition: Transition.rightToLeft, arguments: false);
          },
        ),
        const Divider(
          thickness: 1,
        ),
        ProfileMenuItem(
          label: 'Saved Items',
          icon: CupertinoIcons.bookmark_solid,
          onTap: () {
            Get.to(() => const SavedItems(),
                transition: Transition.rightToLeft);
          },
        ),
        const Divider(
          thickness: 1,
        ),
        ProfileMenuSvg(
          label: 'Favourite Sellers',
          path: 'assets/images/icons/fav-seller.svg',
          onTap: () {
            Get.to(() => const FavSeller(), transition: Transition.rightToLeft);
          },
        ),
        const Divider(
          thickness: 1,
        ),
        ProfileMenuItem(
          label: 'Customer Support',
          icon: Icons.support,
          onTap: () {
            Get.to(() => const CustomerSupport(),
                transition: Transition.rightToLeft);
          },
        ),
        const Divider(
          thickness: 1,
        ),
        ProfileMenuItem(
          label: 'Notification',
          icon: Icons.notifications_active,
          onTap: () {
            Get.to(() => const UserNotifications(),
                transition: Transition.rightToLeft);
          },
        ),
        const Divider(
          thickness: 1,
        ),
        ProfileMenuItem(
          label: 'Privacy',
          icon: Icons.security_outlined,
          onTap: () {},
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.12,
            vertical: 16,
          ),
          child: MyOutlinedButton(
            buttonName: 'Logout',
            onPressed: () async {
              await ChatResource.updateStatus(false);
              await AuthMethods().signOut();
              Get.to(() => WelcomeScreen(), transition: Transition.fadeIn);
            },
            width: MediaQuery.of(context).size.width,
            height: 44,
          ),
        ),
      ],
    );
  }
}
