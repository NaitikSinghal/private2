import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class MyBottomSheet extends StatelessWidget {
  final Widget child;
  final String title;
  const MyBottomSheet({super.key, required this.child, this.title = ''});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: HexColor('#EBEBEB'),
                    child: const Icon(
                      Icons.clear,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ]),
            child
          ],
        ),
      ),
    ]);
  }
}
