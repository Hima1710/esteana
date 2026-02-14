import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kHijriOffsetDaysKey = 'hijri_date_offset_days';

/// تخزين وتحميل تعديل التاريخ الهجري (+1 أو -1 يوم) لضبط التطبيق عند اختلاف الرؤية عن الحساب الفلكي.
class HijriOffsetService {
  HijriOffsetService._();

  static int _cachedOffset = 0;
  static bool _loaded = false;

  /// للاستماع عند تغيير التعديل حتى تُحدّث الواجهة (المحراب، الإعدادات).
  static final ValueNotifier<int> offsetNotifier = ValueNotifier<int>(0);

  /// عدد الأيام المُضافة لتاريخ «اليوم» عند حساب الهجري (سالب = تأخير يوم).
  static int get offsetDays => _cachedOffset;

  /// تحميل القيمة من التخزين (يُستدعى عند بدء التطبيق أو قبل استخدام الهجري).
  static Future<int> loadOffset() async {
    if (_loaded) return _cachedOffset;
    final prefs = await SharedPreferences.getInstance();
    _cachedOffset = prefs.getInt(_kHijriOffsetDaysKey) ?? 0;
    _loaded = true;
    offsetNotifier.value = _cachedOffset;
    return _cachedOffset;
  }

  /// حفظ التعديل (مثلاً +1 أو -1).
  static Future<void> setOffsetDays(int days) async {
    _cachedOffset = days.clamp(-2, 2);
    _loaded = true;
    offsetNotifier.value = _cachedOffset;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kHijriOffsetDaysKey, _cachedOffset);
  }

  /// إضافة يوم واحد للعرض الهجري (رؤية أعلنت قبل الحساب).
  static Future<void> addOneDay() async {
    await setOffsetDays(_cachedOffset + 1);
  }

  /// طرح يوم واحد للعرض الهجري (رؤية أعلنت بعد الحساب).
  static Future<void> subtractOneDay() async {
    await setOffsetDays(_cachedOffset - 1);
  }

  /// تاريخ «اليوم الفعلي» المستخدم في حساب الهجري والمناسبات (مع التعديل).
  static DateTime get effectiveToday {
    return DateTime.now().add(Duration(days: _cachedOffset));
  }
}
