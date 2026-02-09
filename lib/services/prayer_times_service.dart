import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/prayer_day_cache.dart';
import '../models/prayer_month_cache.dart';
import 'isar_service.dart';

/// مواعيد الصلاة — من Aladhan API حسب الموقع؛ تُحفظ في قاعدة الجهاز لاستخدامها دون نت.
class PrayerTimesService {
  PrayerTimesService._();

  static const _baseUrl = 'https://api.aladhan.com/v1';
  static const _userAgent = 'Noor/1.0 (Flutter)';

  /// قيم احتياطية عند فشل API أو عدم وجود موقع.
  static const List<({String nameAr, String nameEn, String key, int hour, int minute})> _defaultTimes = [
    (nameAr: 'الفجر', nameEn: 'Fajr', key: 'Fajr', hour: 5, minute: 42),
    (nameAr: 'الشروق', nameEn: 'Sunrise', key: 'Sunrise', hour: 7, minute: 5),
    (nameAr: 'الظهر', nameEn: 'Dhuhr', key: 'Dhuhr', hour: 12, minute: 30),
    (nameAr: 'العصر', nameEn: 'Asr', key: 'Asr', hour: 15, minute: 45),
    (nameAr: 'المغرب', nameEn: 'Maghrib', key: 'Maghrib', hour: 18, minute: 24),
    (nameAr: 'العشاء', nameEn: 'Isha', key: 'Isha', hour: 19, minute: 50),
  ];

  /// نموذج وقت صلاة واحدة.
  static List<PrayerTimeEntry> get defaultTimes => _defaultTimes
      .map((e) => PrayerTimeEntry(
            nameAr: e.nameAr,
            time: '${e.hour.toString().padLeft(2, '0')}:${e.minute.toString().padLeft(2, '0')}',
            hour: e.hour,
            minute: e.minute,
          ))
      .toList();

  static String? _cacheKey;
  static List<PrayerTimeEntry>? _cachedTimes;

  /// جلب مواعيد اليوم: من الشبكة إن وُجدت (مع الحفظ في Isar)، وإلا من قاعدة الجهاز أو القيم الافتراضية.
  static Future<List<PrayerTimeEntry>> fetchTodayTimes() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dayKey = '${now.year}-${now.month}-${now.day}';

    try {
      final position = await _getPosition();
      if (position != null) {
        final key = '${position.latitude.toStringAsFixed(2)}_${position.longitude.toStringAsFixed(2)}';
        final cacheKey = '${dayKey}_$key';
        if (_cacheKey == cacheKey && _cachedTimes != null) {
          return _cachedTimes!;
        }

        final list = await _fetchFromAladhan(position.latitude, position.longitude);
        if (list.isNotEmpty) {
          _cacheKey = cacheKey;
          _cachedTimes = list;
          await _saveToDb(today, position.latitude, position.longitude, list);
          return list;
        }
      }
    } catch (_) {
      // استعمال المحفوظ أو الافتراضي
    }

    final fromDb = await _loadFromDb(today);
    if (fromDb.isNotEmpty) {
      _cacheKey = '${dayKey}_db';
      _cachedTimes = fromDb;
      return fromDb;
    }

    final fallback = _defaultList(now);
    _cacheKey = '${dayKey}_fallback';
    _cachedTimes = fallback;
    return fallback;
  }

  static Future<void> _saveToDb(DateTime date, double lat, double lon, List<PrayerTimeEntry> list) async {
    if (!IsarService.isInitialized) return;
    try {
      final isar = IsarService.isar;
      final json = _timingsToJson(list);
      await isar.writeTxn(() async {
        final q = isar.prayerDayCaches.filter().dateEqualTo(date);
        await (q as dynamic).deleteAll();
        final cache = PrayerDayCache()
          ..date = date
          ..latitude = lat
          ..longitude = lon
          ..timingsJson = json;
        await isar.prayerDayCaches.put(cache);
      });
    } catch (_) {}
  }

  static Future<List<PrayerTimeEntry>> _loadFromDb(DateTime date) async {
    if (!IsarService.isInitialized) return [];
    try {
      final isar = IsarService.isar;
      final q = isar.prayerDayCaches.filter().dateEqualTo(date);
      final cache = await (q as dynamic).findFirst() as PrayerDayCache?;
      if (cache != null && cache.timingsJson.isNotEmpty) {
        return _timingsFromJson(cache.timingsJson);
      }
    } catch (_) {}
    return [];
  }

  static String _timingsToJson(List<PrayerTimeEntry> list) {
    return jsonEncode(list
        .map((e) => {'nameAr': e.nameAr, 'time': e.time, 'hour': e.hour, 'minute': e.minute})
        .toList());
  }

  static List<PrayerTimeEntry> _timingsFromJson(String s) {
    try {
      final list = jsonDecode(s) as List<dynamic>?;
      if (list == null) return [];
      return list.map((e) {
        final m = e as Map<String, dynamic>;
        return PrayerTimeEntry(
          nameAr: m['nameAr'] as String? ?? '',
          time: m['time'] as String? ?? '00:00',
          hour: (m['hour'] as num?)?.toInt() ?? 0,
          minute: (m['minute'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  static List<PrayerTimeEntry> _defaultList(DateTime date) {
    return _defaultTimes
        .map((e) => PrayerTimeEntry(
              nameAr: e.nameAr,
              time: '${e.hour.toString().padLeft(2, '0')}:${e.minute.toString().padLeft(2, '0')}',
              hour: e.hour,
              minute: e.minute,
            ))
        .toList();
  }

  static Future<Position?> _getPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return null;
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested != LocationPermission.whileInUse && requested != LocationPermission.always) {
        return null;
      }
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
    );
  }

  static Future<List<PrayerTimeEntry>> _fetchFromAladhan(double lat, double lon) async {
    final uri = Uri.parse('$_baseUrl/timings').replace(
      queryParameters: {'latitude': lat.toString(), 'longitude': lon.toString()},
    );
    final response = await http.get(uri, headers: {'User-Agent': _userAgent}).timeout(
      const Duration(seconds: 10),
    );
    if (response.statusCode != 200) return [];

    final json = jsonDecode(response.body) as Map<String, dynamic>?;
    final data = json?['data'] as Map<String, dynamic>?;
    final timings = data?['timings'] as Map<String, dynamic>?;
    if (timings == null) return [];

    final order = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    final names = {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    };
    final list = <PrayerTimeEntry>[];
    for (final key in order) {
      final value = timings[key] as String?;
      if (value == null) continue;
      final parts = value.split(':');
      if (parts.length < 2) continue;
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      list.add(PrayerTimeEntry(
        nameAr: names[key] ?? key,
        time: value.length >= 5 ? value.substring(0, 5) : value,
        hour: hour,
        minute: minute,
      ));
    }
    return list;
  }

  /// الصلاة القادمة من قائمة مواعيد اليوم.
  static ({String nameAr, String time, DateTime at})? getNextPrayer(DateTime now, List<PrayerTimeEntry> todayTimes) {
    if (todayTimes.isEmpty) return null;
    final today = DateTime(now.year, now.month, now.day);
    for (final e in todayTimes) {
      final at = today.add(Duration(hours: e.hour, minutes: e.minute));
      if (at.isAfter(now)) {
        return (nameAr: e.nameAr, time: e.time, at: at);
      }
    }
    final first = todayTimes.first;
    final tomorrow = today.add(const Duration(days: 1));
    final at = tomorrow.add(Duration(hours: first.hour, minutes: first.minute));
    return (nameAr: first.nameAr, time: first.time, at: at);
  }

  /// مدة متبقية حتى [target] بصيغة "HH:mm:ss".
  static String countdown(DateTime now, DateTime target) {
    var d = target.difference(now);
    if (d.isNegative) return '00:00:00';
    final h = d.inHours;
    d = d - Duration(hours: h);
    final m = d.inMinutes;
    final s = d.inSeconds - m * 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /// جلب مواعيد شهر كامل من Aladhan (تقويم) — مع التاريخ الهجري والميلادي.
  /// يُحفظ في قاعدة الجهاز؛ عند انقطاع النت يُعاد المحفوظ إن وُجد.
  static Future<List<PrayerDayRow>> fetchMonthCalendar({
    required int year,
    required int month,
    required double latitude,
    required double longitude,
    bool isArabic = true,
  }) async {
    final key = year * 100 + month;
    try {
      final result = await _fetchMonthFromApi(year: year, month: month, latitude: latitude, longitude: longitude, isArabic: isArabic);
      if (result.isNotEmpty && IsarService.isInitialized) {
        await _saveMonthToDb(year: year, month: month, key: key, rows: result);
      }
      return result;
    } catch (_) {
      if (IsarService.isInitialized) {
        final cached = await _loadMonthFromDb(key);
        if (cached.isNotEmpty) return cached;
      }
      return [];
    }
  }

  static Future<void> _saveMonthToDb({required int year, required int month, required int key, required List<PrayerDayRow> rows}) async {
    try {
      final isar = IsarService.isar;
      final json = _monthRowListToJson(rows);
      await isar.writeTxn(() async {
        final q = isar.prayerMonthCaches.filter().yearMonthKeyEqualTo(key);
        await (q as dynamic).deleteAll();
        final cache = PrayerMonthCache()
          ..yearMonthKey = key
          ..year = year
          ..month = month
          ..dataJson = json;
        await isar.prayerMonthCaches.put(cache);
      });
    } catch (_) {}
  }

  static Future<List<PrayerDayRow>> _loadMonthFromDb(int yearMonthKey) async {
    try {
      final isar = IsarService.isar;
      final q = isar.prayerMonthCaches.filter().yearMonthKeyEqualTo(yearMonthKey);
      final cache = await (q as dynamic).findFirst() as PrayerMonthCache?;
      if (cache != null && cache.dataJson.isNotEmpty) {
        return _monthRowListFromJson(cache.dataJson);
      }
    } catch (_) {}
    return [];
  }

  static String _monthRowListToJson(List<PrayerDayRow> rows) {
    return jsonEncode(rows.map((r) => {
      'dateGregorian': r.dateGregorian,
      'dateHijri': r.dateHijri,
      'times': r.times.map((e) => {'nameAr': e.nameAr, 'time': e.time, 'hour': e.hour, 'minute': e.minute}).toList(),
    }).toList());
  }

  static List<PrayerDayRow> _monthRowListFromJson(String s) {
    try {
      final list = jsonDecode(s) as List<dynamic>?;
      if (list == null) return [];
      return list.map((e) {
        final m = e as Map<String, dynamic>;
        final timesList = m['times'] as List<dynamic>?;
        final times = (timesList ?? []).map((t) {
          final x = t as Map<String, dynamic>;
          return PrayerTimeEntry(
            nameAr: x['nameAr'] as String? ?? '',
            time: x['time'] as String? ?? '00:00',
            hour: (x['hour'] as num?)?.toInt() ?? 0,
            minute: (x['minute'] as num?)?.toInt() ?? 0,
          );
        }).toList();
        return PrayerDayRow(
          dateGregorian: m['dateGregorian'] as String? ?? '',
          dateHijri: m['dateHijri'] as String? ?? '',
          times: times,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<PrayerDayRow>> _fetchMonthFromApi({
    required int year,
    required int month,
    required double latitude,
    required double longitude,
    bool isArabic = true,
  }) async {
    final uri = Uri.parse('$_baseUrl/calendar').replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'month': month.toString(),
        'year': year.toString(),
      },
    );
    final response = await http.get(uri, headers: {'User-Agent': _userAgent}).timeout(
      const Duration(seconds: 15),
    );
    if (response.statusCode != 200) return [];

    final json = jsonDecode(response.body) as Map<String, dynamic>?;
    final dataList = json?['data'] as List<dynamic>?;
    if (dataList == null || dataList.isEmpty) return [];

    const order = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    const names = {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    };
    final monthNames = isArabic ? _gregorianMonthNamesAr : _gregorianMonthNamesEn;
    final result = <PrayerDayRow>[];

    for (final item in dataList) {
      final map = item as Map<String, dynamic>?;
      if (map == null) continue;
      final timings = map['timings'] as Map<String, dynamic>?;
      final date = map['date'] as Map<String, dynamic>?;
      final gregorian = date?['gregorian'] as Map<String, dynamic>?;
      final hijri = date?['hijri'] as Map<String, dynamic>?;
      if (timings == null || gregorian == null || hijri == null) continue;

      final gDay = gregorian['day'] as String? ?? '';
      final gMonthNum = (gregorian['month'] as Map<String, dynamic>?)?['number'] as int?;
      final gYear = gregorian['year'] as String? ?? '';
      final monthName = (gMonthNum != null && gMonthNum >= 1 && gMonthNum <= 12)
          ? monthNames[gMonthNum - 1]
          : '';
      final dateGregorian = '$gDay $monthName $gYear';

      final hDay = hijri['day'] as String? ?? '';
      final hMonth = (hijri['month'] as Map<String, dynamic>?)?['ar'] as String? ?? '';
      final hYear = hijri['year'] as String? ?? '';
      final dateHijri = '$hDay $hMonth $hYear';

      final list = <PrayerTimeEntry>[];
      for (final key in order) {
        final value = timings[key] as String?;
        if (value == null) continue;
        final timeStr = value.length >= 5 ? value.substring(0, 5) : value;
        final parts = timeStr.split(':');
        if (parts.length < 2) continue;
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        list.add(PrayerTimeEntry(
          nameAr: names[key] ?? key,
          time: timeStr,
          hour: hour,
          minute: minute,
        ));
      }
      result.add(PrayerDayRow(dateGregorian: dateGregorian, dateHijri: dateHijri, times: list));
    }
    return result;
  }
}

/// عنصر وقت صلاة واحد.
class PrayerTimeEntry {
  const PrayerTimeEntry({
    required this.nameAr,
    required this.time,
    required this.hour,
    required this.minute,
  });

  final String nameAr;
  final String time;
  final int hour;
  final int minute;
}

/// يوم واحد من تقويم الشهر: التاريخ هجري + ميلادي ومواعيد اليوم.
class PrayerDayRow {
  const PrayerDayRow({
    required this.dateGregorian,
    required this.dateHijri,
    required this.times,
  });

  final String dateGregorian;
  final String dateHijri;
  final List<PrayerTimeEntry> times;
}

/// أسماء الأشهر الميلادية بالعربية (للنظام الموحد).
const List<String> _gregorianMonthNamesAr = [
  'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
  'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
];
const List<String> _gregorianMonthNamesEn = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
