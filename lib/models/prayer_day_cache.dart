import 'package:isar/isar.dart';

part 'prayer_day_cache.g.dart';

/// تخزين مواعيد صلاة يوم واحد — للاستخدام دون نت.
@collection
class PrayerDayCache {
  Id id = Isar.autoIncrement;

  /// اليوم الذي تنتمي إليه المواعيد (بدون وقت).
  @Index()
  late DateTime date;

  double? latitude;
  double? longitude;

  /// المواعيد كـ JSON: مصفوفة من {nameAr, time, hour, minute}.
  late String timingsJson;

  PrayerDayCache();
}
