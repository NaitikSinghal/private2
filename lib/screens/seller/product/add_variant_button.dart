import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';

// ignore: must_be_immutable
class AddVariantButton extends StatelessWidget {
  VoidCallback onTap;
  IconData icon;
  AddVariantButton({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(25),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: onTap,
            child: SizedBox(
              height: 46,
              width: 46,
              child: Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          'Add Variant',
          style: TextStyle(fontSize: 16),
        )
      ],
    );
  }
}
