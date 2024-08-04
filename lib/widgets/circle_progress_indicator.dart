import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';

class CircleProgressIndicator extends StatelessWidget {
  const CircleProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: Colors.white,
      backgroundColor: gradient1,
    );
  }
}
