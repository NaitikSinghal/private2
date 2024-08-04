import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/utils/color.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class ProfileMenuSvg extends StatelessWidget {
  final String label;
  final String path;
  final VoidCallback onTap;
  const ProfileMenuSvg(
      {required this.label,
      required this.path,
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
        leading: SvgPicture.asset(
          path,
          width: 26,
          colorFilter: svgColor(color: iconColor),
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
