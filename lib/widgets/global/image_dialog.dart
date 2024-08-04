import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final String path;
  const ImageDialog({required this.path, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          image:
              DecorationImage(image: ExactAssetImage(path), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
