import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';

class GradientCircle extends StatelessWidget {
  final double radius;
  final Widget child;
  const GradientCircle({this.radius = 20, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
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
          )
        ],
      ),
    );
  }
}
