import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/firebase_constants.dart';

class CartTotalBadge extends StatelessWidget {
  final String iconPath;
  const CartTotalBadge({required this.iconPath, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SvgPicture.asset(
          iconPath,
        ),
        Positioned(
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: const BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firebaseFirestore
                  .collection('cart')
                  .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                return Text(
                  snapshot.hasError
                      ? '0'
                      : snapshot.hasData
                          ? snapshot.data!.docs.length.toString()
                          : '0',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
