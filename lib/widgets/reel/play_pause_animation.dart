import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class PlayPauseAnimation extends StatelessWidget {
  const PlayPauseAnimation({super.key});

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
                ? CircleAvatar(
                    radius: 30,
                    backgroundColor: HexColor('#EBEBEB'),
                    child: Icon(
                      Icons.play_arrow,
                      color: lightBlack,
                      size: 50,
                    ),
                  )
                : const SizedBox(),
      ),
    );
  }
}
