import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class CartAmount extends StatelessWidget {
  final String title;
  final double amount;
  const CartAmount({required this.title, required this.amount, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: HexColor('#4F5663'),
          ),
        ),
        Text(
          '\u{20B9}$amount',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
