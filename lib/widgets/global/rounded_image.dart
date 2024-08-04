import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class RoundedImage extends StatelessWidget {
  final String image;
  final double radius;
  final double height;
  final double width;
  final bool isNetwork;
  const RoundedImage(
      {required this.image,
      this.radius = 14,
      this.height = 110,
      this.width = 110,
      this.isNetwork = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: width,
        child: isNetwork
            ? CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return SkeletonAnimation(
                    shimmerColor: const Color.fromARGB(255, 207, 207, 207),
                    borderRadius: BorderRadius.circular(radius),
                    child: Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: const Color.fromRGBO(230, 230, 230, 1),
                      ),
                    ),
                  );
                },
              )
            : Image.asset(
                image,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
