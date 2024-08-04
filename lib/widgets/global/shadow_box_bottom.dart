import 'package:flutter/material.dart';

class ShadowBoxBottom extends StatelessWidget {
  final Widget child;
  final double height;
  const ShadowBoxBottom({required this.child, this.height = 150, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 0.1,
            spreadRadius: 0,
            offset: Offset(0, 0.8),
          )
        ],
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }
}
