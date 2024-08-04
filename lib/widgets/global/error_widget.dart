import 'package:flutter/cupertino.dart';
import 'package:pherico/config/my_color.dart';

class SomethingWentWrongError extends StatelessWidget {
  const SomethingWentWrongError({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          CupertinoIcons.exclamationmark_triangle_fill,
          color: gradient1,
          size: 100,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Oops! Something went wrong',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: iconColor,
          ),
        ),
      ],
    );
  }
}
