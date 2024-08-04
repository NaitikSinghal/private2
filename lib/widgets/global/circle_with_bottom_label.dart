import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class CircleWithBottomLabel extends StatelessWidget {
  final double radius;
  final Widget child;
  final String title;
  const CircleWithBottomLabel(
      {this.radius = 26, required this.child, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(
        radius: radius,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HexColor('#061023'),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: child,
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 6,
      ),
      Text(title)
    ]);
  }
}
