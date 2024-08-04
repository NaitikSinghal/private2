import 'package:flutter/material.dart';

class CircleAvatarCustom extends StatelessWidget {
  final double radius;
  final Widget child;
  const CircleAvatarCustom({this.radius = 20, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: const Color.fromARGB(255, 119, 119, 119),
      radius: radius,
      child: Align(
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
