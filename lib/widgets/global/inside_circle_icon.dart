import 'package:flutter/material.dart';

class InsideCircleIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final String label;
  final int labelGap;
  final int fontSize;
  final int radius;
  final VoidCallback onTap;
  const InsideCircleIcon(
      {super.key,
      required this.icon,
      this.iconColor = const Color.fromARGB(255, 41, 45, 50),
      this.borderColor = const Color.fromARGB(255, 41, 45, 50),
      this.label = '',
      this.labelGap = 6,
      this.fontSize = 14,
      this.radius = 16,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(radius.toDouble()),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
        ),
        SizedBox(
          height: labelGap.toDouble(),
        ),
        label != ''
            ? Text(
                label,
                style:
                    TextStyle(color: iconColor, fontSize: fontSize.toDouble()),
              )
            : Container()
      ],
    );
  }
}
