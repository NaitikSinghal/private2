import 'package:flutter/material.dart';

class ShadowBoxNoRadius extends StatelessWidget {
  final Widget child;
  final Color bgColor;
  final int height;
  const ShadowBoxNoRadius(
      {required this.child,
      this.bgColor = Colors.white,
      this.height = 162,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: EdgeInsets.zero,
      child: child,
    );
  }
}
