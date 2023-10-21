// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class myDateUtil {
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  // get formetted time to read and send
  static getMessagesTime(
      {required BuildContext context, required String time}) {
    final DateTime sent =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    
    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }
    return now.year == sent.year
    ? '$formattedTime - ${sent.day} ${_getMonth(sent)}' 
    : '$formattedTime - ${sent.day} ${_getMonth(sent)} ${sent.year}';
  }

  // get last message time...

  static getLastMessagesTime(
      {required BuildContext context, required String time}) {
    final DateTime sentTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sentTime.day &&
        now.month == sentTime.month &&
        now.year == sentTime.year) {
      return TimeOfDay.fromDateTime(sentTime).format(context);
    }
    return '${sentTime.day} ${_getMonth(sentTime)}';
  }

  // get last active time ..
  static getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    // if time is not avalabel
    if (i == -1) return "Last seen not avaleble";

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);

    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return 'Last seen Today at $formattedTime';
    }
    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last een yesterday $formattedTime';
    }

    String month = _getMonth(time);
    return 'Last seen on ${time.day} $month on $formattedTime';
  }

  // get status post date and time
  static getStatusPostTime(
      {required BuildContext context, required String statusPostTime}) {
    final int i = int.tryParse(statusPostTime) ?? -1;

    // if time is not avalabel
    if (i == -1) return "Time avaleble";

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);

    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return 'Make at Today at $formattedTime';
    }
    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Make at yesterday $formattedTime';
    }

    String month = _getMonth(time);
    return 'Last seen on ${time.day} $month on $formattedTime';
  }


  // get last message month no
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
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}
