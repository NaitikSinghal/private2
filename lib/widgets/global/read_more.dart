import 'package:pherico/config/my_color.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/material.dart';

class ReadMore extends StatelessWidget {
  final String text;
  final int trimLine;
  final int fontSize;
  final Color textColor;
  const ReadMore(
      {required this.text,
      this.trimLine = 2,
      super.key,
      this.fontSize = 13,
      this.textColor = const Color.fromARGB(255, 5, 20, 32)});

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      trimLines: trimLine,
      preDataTextStyle: const TextStyle(
        fontWeight: FontWeight.normal,
      ),
      style: TextStyle(color: textColor, fontSize: 14),
      colorClickableText: gradient1,
      trimMode: TrimMode.Line,
      trimCollapsedText: 'more',
      trimExpandedText: ' less',
      lessStyle: TextStyle(fontSize: fontSize.toDouble(), color: gradient1),
      moreStyle: TextStyle(fontSize: 13, color: gradient1),
    );
  }
}
