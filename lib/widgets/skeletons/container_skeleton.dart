import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class ContainerSkeleton extends StatelessWidget {
  const ContainerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: HexColor('#F4F4F4'),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SkeletonAnimation(
        borderRadius: BorderRadius.circular(5.0),
        shimmerColor: Colors.white54,
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: const Color.fromARGB(255, 230, 230, 230),
          ),
        ),
      ),
    );
  }
}
