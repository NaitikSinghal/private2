import 'package:flutter/material.dart';

class CircleImageBorder extends StatelessWidget {
  final String profileUrl;
  const CircleImageBorder({super.key, required this.profileUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      height: 62,
      child: Center(
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image(
              image: NetworkImage(profileUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
