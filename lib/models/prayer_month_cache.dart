import 'package:isar/isar.dart';

part 'prayer_month_cache.g.dart';

/// تخزين مواعيد شهر كامل — للاستخدام دون نت (عرض الشهر بالكامل).
@collection
class PrayerMonthCache {
  Id id = Isar.autoIncrement;

  /// مفتاح فريد: year * 100 + month (مثلاً 202602 لشهر فبراير 2026).
  @Index()
  late int yearMonthKey;

  late int year;
  late int month;

  /// بيانات الشهر كـ JSON: مصفوفة من {dateGregorian, dateHijri, times: [{nameAr, time, hour, minute}]}.
  late String dataJson;

  PrayerMonthCache();
}
