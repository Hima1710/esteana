import 'package:hijri/hijri_calendar.dart';

import '../models/occasion.dart';
import 'hijri_offset_service.dart';

/// المناسبات الإسلامية الثابتة (هجري) — يعمل بدون إنترنت.
class OccasionService {
  OccasionService._();

  static final List<Occasion> _allOccasions = [
    Occasion(id: 'ramadan', nameAr: 'رمضان', nameEn: 'Ramadan', hijriMonth: 9, hijriDay: 1, durationDays: 30, iconType: OccasionIconType.crescent),
    Occasion(id: 'eid_fitr', nameAr: 'عيد الفطر', nameEn: 'Eid al-Fitr', hijriMonth: 10, hijriDay: 1, iconType: OccasionIconType.crescent),
    Occasion(id: 'arafa', nameAr: 'يوم عرفة', nameEn: 'Day of Arafah', hijriMonth: 12, hijriDay: 9, iconType: OccasionIconType.kaaba),
    Occasion(id: 'eid_adha', nameAr: 'عيد الأضحى', nameEn: 'Eid al-Adha', hijriMonth: 12, hijriDay: 10, iconType: OccasionIconType.kaaba),
    Occasion(id: 'mawlid', nameAr: 'المولد النبوي', nameEn: 'Mawlid al-Nabi', hijriMonth: 3, hijriDay: 12, iconType: OccasionIconType.book),
    Occasion(id: 'hijri_new_year', nameAr: 'رأس السنة الهجرية', nameEn: 'Islamic New Year', hijriMonth: 1, hijriDay: 1, iconType: OccasionIconType.crescent),
    Occasion(id: 'ashura', nameAr: 'عاشوراء', nameEn: 'Ashura', hijriMonth: 1, hijriDay: 10, iconType: OccasionIconType.crescent),
  ];

  static final HijriCalendar _hijri = HijriCalendar();

  /// يُرجع المناسبة الأقرب (تاريخها القادم بعد أو يساوي اليوم الفعلي).
  static Occasion? getNearestOccasion() {
    final occasions = _occasionsWithNextDate();
    if (occasions.isEmpty) return null;
    occasions.sort((a, b) => (a.$2).compareTo(b.$2));
    return occasions.first.$1;
  }

  /// يُرجع المناسبة الأقرب مع تاريخها القادم وعدد الأيام المتبقية (0 = اليوم).
  static (Occasion occasion, DateTime nextDate, int daysLeft)? getNearestOccasionWithCountdown() {
    final list = _occasionsWithNextDate();
    if (list.isEmpty) return null;
    list.sort((a, b) => (a.$2).compareTo(b.$2));
    final occasion = list.first.$1;
    final nextDate = list.first.$2;
    final today = HijriOffsetService.effectiveToday;
    final todayStart = DateTime(today.year, today.month, today.day);
    final nextStart = DateTime(nextDate.year, nextDate.month, nextDate.day);
    final daysLeft = nextStart.difference(todayStart).inDays;
    return (occasion, nextDate, daysLeft);
  }

  /// قائمة كل المناسبات للعام الهجري الحالي مرتبة زمنياً (مع التاريخ الميلادي).
  static List<(Occasion occasion, DateTime gregorianDate)> getAllOccasions() {
    final today = HijriOffsetService.effectiveToday;
    final h = HijriCalendar.fromDate(today);
    final year = h.hYear;
    final list = <(Occasion, DateTime)>[];
    for (final o in _allOccasions) {
      try {
        final dt = _hijri.hijriToGregorian(year, o.hijriMonth, o.hijriDay);
        list.add((o, dt));
      } catch (_) {}
    }
    list.sort((a, b) => a.$2.compareTo(b.$2));
    return list;
  }

  /// هل اليوم الفعلي هو أول أيام المناسبة [occasion]؟
  static bool isFirstDayOfOccasion(Occasion occasion) {
    final today = HijriOffsetService.effectiveToday;
    final h = HijriCalendar.fromDate(today);
    return h.hMonth == occasion.hijriMonth && h.hDay == occasion.hijriDay;
  }

  /// هل اليوم الفعلي يقع ضمن أيام المناسبة (من اليوم الأول حتى durationDays)؟
  static bool isDuringOccasion(Occasion occasion) {
    final today = HijriOffsetService.effectiveToday;
    final h = HijriCalendar.fromDate(today);
    if (h.hMonth != occasion.hijriMonth) return false;
    return h.hDay >= occasion.hijriDay && h.hDay < occasion.hijriDay + occasion.durationDays;
  }

  static List<(Occasion, DateTime)> _occasionsWithNextDate() {
    final today = HijriOffsetService.effectiveToday;
    final todayStart = DateTime(today.year, today.month, today.day);
    final h = HijriCalendar.fromDate(today);
    final year = h.hYear;
    final list = <(Occasion, DateTime)>[];
    for (final o in _allOccasions) {
      try {
        var dt = _hijri.hijriToGregorian(year, o.hijriMonth, o.hijriDay);
        if (dt.isBefore(todayStart)) dt = _hijri.hijriToGregorian(year + 1, o.hijriMonth, o.hijriDay);
        list.add((o, dt));
      } catch (_) {}
    }
    return list;
  }
}
