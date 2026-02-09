import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/daily_task.dart';
import '../models/action_of_the_day_entry.dart';
import '../models/prayer_request.dart';
import '../models/last_read_entry.dart';
import '../models/bookmark_entry.dart';
import '../models/prayer_day_cache.dart';
import '../models/prayer_month_cache.dart';
import '../models/luminous_wallet.dart';
import '../models/dhikr_day_progress.dart';
import '../models/mushaf_surah.dart';
import '../models/mushaf_page_progress.dart';

/// تهيئة قاعدة بيانات Isar عند تشغيل التطبيق.
class IsarService {
  IsarService._();

  static Isar? _instance;
  static Future<Isar>? _initFuture;

  static Future<Isar> init() async {
    if (_instance != null) return _instance!;
    _initFuture ??= _open();
    _instance = await _initFuture;
    return _instance!;
  }

  static Future<Isar> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [DailyTaskSchema, ActionOfTheDayEntrySchema, PrayerRequestSchema, LastReadEntrySchema, BookmarkEntrySchema, PrayerDayCacheSchema, PrayerMonthCacheSchema, LuminousWalletSchema, DhikrDayProgressSchema, MushafSurahSchema, MushafPageProgressSchema],
      directory: dir.path,
    );
  }

  static Isar get isar {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'IsarService not initialized. Call await IsarService.init() before accessing isar.',
      );
    }
    return i;
  }

  static bool get isInitialized => _instance != null;
}
