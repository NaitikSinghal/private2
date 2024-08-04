import 'package:flutter/material.dart';
import 'package:pherico/widgets/seller/profile/profile_menu.dart';

import '../../../config/my_color.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: gradient1,
          ),
          child: const Text('Drawer Header'),
        ),
        const ProfileMenuSeller()
      ],
    );
  }
}
