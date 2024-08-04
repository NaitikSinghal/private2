import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const RoundButton({required this.icon, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.white,
          minimumSize: const Size.fromRadius(14),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      child: Icon(icon, color: HexColor('#4F5663')),
    );
  }
}
