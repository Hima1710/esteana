import 'package:flutter/material.dart';

/// تنسيق وقت العرض حسب نظام الوقت في الجهاز (12 أو 24 ساعة).
class TimeFormat {
  TimeFormat._();

  /// يعيد وقت الساعة [hour]:[minute] بصيغة الجهاز (12 أو 24 ساعة).
  /// يستخدم [MediaQuery.alwaysUse24HourFormat] و [MaterialLocalizations.formatTimeOfDay].
  static String formatTime(BuildContext context, int hour, int minute) {
    final use24 = MediaQuery.of(context).alwaysUse24HourFormat ?? true;
    final tod = TimeOfDay(hour: hour, minute: minute);
    return MaterialLocalizations.of(context).formatTimeOfDay(tod, alwaysUse24HourFormat: use24);
  }
}
