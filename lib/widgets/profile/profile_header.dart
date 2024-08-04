import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/text_size.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String profile;
  final int following;

  const ProfileHeader(
      {required this.name,
      required this.profile,
      required this.following,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Hi, $name',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ' Following | ',
              style: TextStyle(
                  color: gradient1,
                  fontSize: TextSize.textSize14,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              following < 1000 ? following.toString() : '${following / 1000}k',
              style: TextStyle(
                  color: textColor,
                  fontSize: TextSize.textSize14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
