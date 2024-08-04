import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';

class FollowIcon extends StatelessWidget {
  const FollowIcon({super.key});

  Future<int> tempFuture() async {
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: tempFuture(),
        builder: (context, snapshot) =>
            snapshot.connectionState != ConnectionState.done
                ? Icon(
                    Icons.person_add_alt,
                    size: 110,
                    color: white,
                  )
                : const SizedBox(),
      ),
    );
  }
}
