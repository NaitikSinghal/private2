import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';
import '../../../config/text_size.dart';

class ProfileHeaderSeller extends StatelessWidget {
  final String name;
  final int followers;
  final int following;

  const ProfileHeaderSeller(
      {required this.name,
      required this.followers,
      required this.following,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
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
              'Followers | ',
              style: TextStyle(
                  color: gradient1,
                  fontSize: TextSize.textSize14,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              followers < 1000 ? followers.toString() : '${followers / 1000}k',
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
