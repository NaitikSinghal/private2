import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class RoundButton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final String buttonName;
  final String bgColorCode;
  final String color;
  final VoidCallback onPressed;
  const RoundButton(
      {this.radius = 50,
      this.width = 120,
      this.height = 40,
      this.bgColorCode = '#F6F6FA',
      this.color = '#cccccc',
      required this.buttonName,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: HexColor(bgColorCode),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: const EdgeInsets.all(0.0),
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          constraints: BoxConstraints(minHeight: height),
          alignment: Alignment.center,
          child: Text(
            buttonName,
            style: TextStyle(
              color: HexColor(color),
            ),
          ),
        ),
      ),
    );
  }
}
