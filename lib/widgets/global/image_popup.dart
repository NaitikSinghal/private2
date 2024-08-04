import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagePopup extends StatelessWidget {
  final String image;
  const ImagePopup({super.key, required this.image});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 16,
          height: 300,
          child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error, size: 40)),
          ),
        ),
      ),
    );
  }
}
