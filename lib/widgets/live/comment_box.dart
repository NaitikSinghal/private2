import 'package:flutter/material.dart';
import 'package:pherico/widgets/global/gradient_circle.dart';
import '../../config/my_color.dart';

class CommentBox extends StatelessWidget {
  final String productId;
  const CommentBox({required this.productId, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 108,
          height: 40,
          child: TextFormField(
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Say Something...',
              hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(28),
                ),
                borderSide: BorderSide(
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28.0),
                borderSide: BorderSide(color: white, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28.0),
                borderSide: BorderSide(color: white, width: 1),
              ),
              contentPadding: const EdgeInsets.fromLTRB(16.0, 6.0, 12.0, 6.0),
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        const GradientCircle(
          radius: 36,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.breakfast_dining,
                size: 24,
              ),
              Text(
                'view\nproduct',
                style: TextStyle(
                  fontSize: 12,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
