import 'package:flutter/material.dart';
import 'package:pherico/utils/border.dart';

import '../../config/my_color.dart';

class CustomTextFromField extends StatelessWidget {
  final Widget child;
  const CustomTextFromField({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 1,
        borderRadius: borderShape(),
        shadowColor: shadowColorInput,
        child: child);
  }
}
