import 'package:flutter/material.dart';

class FullScreenIndicator extends StatelessWidget {
  const FullScreenIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Opacity(
      opacity: 0.8,
      child: ModalBarrier(dismissible: false, color: Colors.black),
    );
  }
}
