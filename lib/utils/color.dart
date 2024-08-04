import 'package:flutter/material.dart';

svgColor({Color color = Colors.white}) {
  return ColorFilter.mode(
    color,
    BlendMode.srcIn,
  );
}
