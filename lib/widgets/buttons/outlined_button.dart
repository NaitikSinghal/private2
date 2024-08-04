import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';

class MyOutlinedButton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final String buttonName;
  final VoidCallback onPressed;
  const MyOutlinedButton(
      {this.radius = 50,
      this.width = 120,
      this.height = 40,
      required this.buttonName,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          side: MaterialStateProperty.all(
            BorderSide(color: black),
          ),
        ),
        child: Text(
          buttonName,
          style: TextStyle(color: black),
        ),
      ),
    );
  }
}
