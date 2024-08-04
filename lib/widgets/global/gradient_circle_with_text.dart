import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';

class GradientCircleWithTitle extends StatelessWidget {
  final double radius;
  final Widget child;
  final String title;
  const GradientCircleWithTitle(
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
                gradient: gradient,
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
