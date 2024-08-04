import 'package:flutter/material.dart';

import '../../config/my_color.dart';

class AuthSubmitButton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final String buttonName;
  final VoidCallback onSubmit;
  const AuthSubmitButton(
      {this.radius = 10,
      this.width = 120,
      this.height = 50,
      required this.buttonName,
      required this.onSubmit,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: ElevatedButton(
        onPressed: onSubmit,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            padding: const EdgeInsets.all(0.0)),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          child: Container(
            constraints: BoxConstraints(
              minHeight: height,
              minWidth: width,
            ),
            alignment: Alignment.center,
            child: Text(buttonName,style: const TextStyle(fontSize: 18),),
          ),
        ),
      ),
    );
  }
}
