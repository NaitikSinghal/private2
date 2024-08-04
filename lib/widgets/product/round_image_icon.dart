import 'package:flutter/material.dart';

import '../global/circle_avatar.dart';

class RoundImageIcon extends StatelessWidget {
  const RoundImageIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(
                'assets/images/products/girl_top.jpg',
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        const Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: CircleAvatarCustom(
              child: Icon(Icons.favorite_rounded),
            ),
          ),
        ),
      ],
    );
  }
}
