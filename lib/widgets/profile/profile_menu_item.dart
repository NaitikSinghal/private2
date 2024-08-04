import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class ProfileMenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const ProfileMenuItem(
      {required this.label,
      required this.icon,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        visualDensity: const VisualDensity(
          vertical: -2,
        ),
        leading: Icon(
          icon,
          color: iconColor,
          size: 26,
        ),
        horizontalTitleGap: 8,
        title: Text(
          label,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: iconColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
