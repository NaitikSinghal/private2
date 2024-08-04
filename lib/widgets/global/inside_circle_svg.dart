import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InsideCircleSvg extends StatelessWidget {
  final String path;
  final Color labelColor;
  final Color borderColor;
  final String label;
  final int labelGap;
  final VoidCallback onTap;
  const InsideCircleSvg(
      {super.key,
      required this.path,
      this.labelColor = const Color.fromARGB(255, 41, 45, 50),
      this.borderColor = const Color.fromARGB(255, 41, 45, 50),
      this.label = '',
      this.labelGap = 6,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1),
            ),
            child: SvgPicture.asset(
              path,
            ),
          ),
        ),
        SizedBox(
          height: labelGap.toDouble(),
        ),
        label != ''
            ? Text(
                label,
                style: TextStyle(color: labelColor),
              )
            : Container()
      ],
    );
  }
}
