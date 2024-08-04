import 'package:flutter/material.dart';

class GlobalDialog {
  static GlobalKey<NavigatorState> dialogNavigatorKey =
      GlobalKey<NavigatorState>();

  static void showGlobalDialog(BuildContext context) {
    showDialog(
      context: dialogNavigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Global Dialog'),
          content: const Text('This is a global dialog.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
