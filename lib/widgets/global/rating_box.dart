import 'package:flutter/material.dart';

class RatingBox extends StatelessWidget {
  final double radius;
  final Widget child;
  const RatingBox({this.radius = 14, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(radius),
        color: const Color.fromARGB(250, 252, 248, 250),
        backgroundBlendMode: BlendMode.softLight,
      ),
      child: child,
    );
  }
}
