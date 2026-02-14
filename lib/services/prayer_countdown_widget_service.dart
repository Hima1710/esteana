import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import 'prayer_times_service.dart';

/// مفاتيح البيانات المشتركة مع ويدجت أندرويد (PrayerCountdownWidgetProvider).
class PrayerCountdownWidgetKeys {
  PrayerCountdownWidgetKeys._();
  static const String labelNext = 'widget_label_next';
  static const String dateGregorian = 'widget_date_gregorian';
  static const String dateHijri = 'widget_date_hijri';
  static const String labelRemaining = 'widget_label_remaining';
  /// اسم المناسبة الإسلامية القادمة (للعرض بجانب العد التنازلي).
  static const String occasionName = 'widget_occasion_name';
  /// عدد الأيام المتبقية للمناسبة (سلسلة جاهزة للعرض، مثل "3 أيام" أو "").
  static const String occasionDays = 'widget_occasion_days';
  /// كل صلوات اليوم: JSON مصفوفة من { "n": "اسم الصلاة", "t": epochMillis } مرتبة زمنياً.
  /// الويدجت يختار الصلاة القادمة من توقيت الجهاز ويحدّث تلقائياً بعد كل صلاة.
  static const String prayersTodayJson = 'widget_prayers_today_json';
}

/// الاسم الكامل لـ provider الويدجت في أندرويد (يجب أن يطابق الـ receiver في AndroidManifest).
const String _qualifiedAndroidWidgetName = 'com.esteana.noor.PrayerCountdownWidgetProvider';

/// يحدّث ويدجت الشاشة الرئيسية: يخزن **كل** صلوات اليوم؛ الويدجت يحدد الصلاة القادمة من توقيت الجهاز ويحوّل تلقائياً للصلاة التالية بعد انتهاء وقتها.
Future<void> updatePrayerCountdownWidget({
  required String labelNext,
  required String dateGregorianLine,
  required String dateHijriLine,
  required String labelRemaining,
  required DateTime today,
  required List<PrayerTimeEntry> times,
  String? occasionName,
  String? occasionDays,
}) async {
  if (kIsWeb) return;
  try {
    final list = times.map((e) {
      final at = DateTime(today.year, today.month, today.day, e.hour, e.minute);
      return <String, dynamic>{'n': e.nameAr, 't': at.millisecondsSinceEpoch};
    }).toList();
    final json = jsonEncode(list);

    await HomeWidget.saveWidgetData<String>(PrayerCountdownWidgetKeys.labelNext, labelNext);
    await HomeWidget.saveWidgetData<String>(PrayerCountdownWidgetKeys.dateGregorian, dateGregorianLine);
    await HomeWidget.saveWidgetData<String>(PrayerCountdownWidgetKeys.dateHijri, dateHijriLine);
    await HomeWidget.saveWidgetData<String>(PrayerCountdownWidgetKeys.labelRemaining, labelRemaining);
    await HomeWidget.saveWidgetData<String>(PrayerCountdownWidgetKeys.prayersTodayJson, json);
    await HomeWidget.saveWidgetData<String>(PrayerCountdownWidgetKeys.occasionName, occasionName ?? '');
    await HomeWidget.saveWidgetData<String>(PrayerCountdownWidgetKeys.occasionDays, occasionDays ?? '');
    await HomeWidget.updateWidget(qualifiedAndroidName: _qualifiedAndroidWidgetName);
  } catch (e) {
    debugPrint('PrayerCountdownWidget: $e');
  }
}
