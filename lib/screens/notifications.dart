import 'package:flutter/material.dart';
import 'package:pherico/widgets/notification/notification_content.dart';

import '../widgets/global/app_bar.dart';

class UserNotifications extends StatelessWidget {
  static const routeName = '/notification';
  const UserNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Notifications',
          onPressed: () {
            Navigator.of(context).pushNamed('/home');
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
              itemCount: 2,
              itemBuilder: (ctx, i) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: NotificationContent(),
                );
              }),
        ),
      ),
    );
  }
}
