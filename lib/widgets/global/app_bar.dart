import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const CustomAppbar({required this.title, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: AppBar(
        key: Key(title),
        leading: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
