import 'package:flutter/material.dart';

class ChatTimeFormatter {
  static String getFromattedTime(BuildContext context, String orderTime) {
    // final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    // return TimeOfDay.fromDateTime(date).format(context);

    final int i = int.tryParse(orderTime) ?? -1;

    if (i == -1) {
      return 'Not available';
    }

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);

    if (now.day == time.day &&
        now.month == time.month &&
        now.year == time.year) {
      return 'today at $formattedTime';
    }

    if (now.difference(time).inHours / 24.round() == 1) {
      return 'yesterday at $formattedTime';
    }

    String month = _getMonth(time);

    return '${time.day} $month at $formattedTime';
  }

  static String formattedTime(BuildContext context, String orderTime) {
    final int i = int.tryParse(orderTime) ?? -1;

    if (i == -1) {
      return 'NA';
    }

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);

    return formattedTime;
  }

  static String formattedDate(BuildContext context, String orderTime) {
    final int i = int.tryParse(orderTime) ?? -1;

    if (i == -1) {
      return 'NA';
    }

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);

    String month = _getMonth(time);

    if (time.day < 10) {
      return '0${time.day} $month';
    } else {
      return '${time.day} $month';
    }
  }

  static String getLastMessageTime(BuildContext context, String time) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return '${sent.day} ${_getMonth(sent)}';
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Now';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }

  static String getLastActiveTime(BuildContext context, String lastActive) {
    final int i = int.tryParse(lastActive) ?? -1;

    if (i == -1) {
      return 'Last seen not active';
    }

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);

    if (now.day == time.day &&
        now.month == time.month &&
        now.year == time.year) {
      return 'Last seen today at $formattedTime';
    }

    if (now.difference(time).inHours / 24.round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);

    return 'Last seen on ${time.day} $month on $formattedTime';
  }

  static String getMessageTime(String time, BuildContext context) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(sent).format(context);

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }

    return now.year == sent.year
        ? '${sent.day} ${_getMonth(sent)} $formattedTime'
        : '${sent.day} ${_getMonth(sent)} ${sent.year} $formattedTime - ';
  }

  static String getFormattedDateTime(BuildContext context, String lastActive) {
    final int i = int.tryParse(lastActive) ?? -1;

    if (i == -1) {
      return 'Not available';
    }

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);

    if (now.day == time.day &&
        now.month == time.month &&
        now.year == time.year) {
      return 'today at $formattedTime';
    }

    if (now.difference(time).inHours / 24.round() == 1) {
      return 'Yesterday at $formattedTime';
    }

    String month = _getMonth(time);

    return '${time.day} $month at $formattedTime';
  }

  static String getSince(String lastActive) {
    final int i = int.tryParse(lastActive) ?? -1;

    if (i == -1) {
      return 'Not available';
    }

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);

    String month = _getMonth(time);

    return 'Since ${time.day} $month ${time.year}';
  }
}
