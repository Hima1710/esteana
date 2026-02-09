import 'package:isar/isar.dart';

import '../models/dhikr_day_progress.dart';
import 'isar_service.dart';

int _todayKey() {
  final n = DateTime.now();
  return n.year * 10000 + n.month * 100 + n.day;
}

/// تحميل تقدم اليوم لفئة معينة. إن لم يوجد يُرجع null (استخدم القيم الافتراضية من JSON).
Future<DhikrDayProgress?> getTodayProgress(Isar isar, String categoryId) async {
  if (!IsarService.isInitialized) return null;
  final key = _todayKey();
  return isar.dhikrDayProgress
      .filter()
      .dateKeyEqualTo(key)
      .categoryIdEqualTo(categoryId)
      .findFirst();
}

/// حفظ تقدم اليوم لفئة معينة.
Future<void> saveTodayProgress(Isar isar, String categoryId, List<int> counts, {int? tawbaSingleCount}) async {
  if (!IsarService.isInitialized) return;
  final key = _todayKey();
  final now = DateTime.now();
  final existing = await getTodayProgress(isar, categoryId);
  final countsJson = DhikrDayProgress.serializeCounts(counts);
  if (existing != null) {
    existing.countsJson = countsJson;
    existing.updatedAt = now;
    await isar.writeTxn(() async => await isar.dhikrDayProgress.put(existing));
  } else {
    final p = DhikrDayProgress()
      ..dateKey = key
      ..categoryId = categoryId
      ..countsJson = countsJson
      ..updatedAt = now;
    await isar.writeTxn(() async => await isar.dhikrDayProgress.put(p));
  }
}

/// للتوبة: حفظ عداد واحد (المتبقي من 100).
Future<void> saveTodayTawbaProgress(Isar isar, int remainingCount) async {
  await saveTodayProgress(isar, 'tawba', [remainingCount]);
}

/// نسبة إكمال اليوم (0..1): عدد الفئات المكتملة / 5.
Future<double> getTodayDhikrCompletionRatio(Isar isar) async {
  if (!IsarService.isInitialized) return 0;
  final key = _todayKey();
  final list = await isar.dhikrDayProgress.filter().dateKeyEqualTo(key).findAll();
  if (list.isEmpty) return 0;
  int completed = 0;
  for (final p in list) {
    final counts = DhikrDayProgress.parseCounts(p.countsJson);
    final allZero = counts.isEmpty || counts.every((c) => c == 0);
    if (allZero) completed++;
  }
  return completed / 5;
}

/// تقدم اليوم لجميع الفئات (لشريط المحراب): (مكتمل، إجمالي) = (عدد الفئات المكتملة، 5).
Future<({int completed, int total})> getTodayDhikrSummary(Isar isar) async {
  if (!IsarService.isInitialized) return (completed: 0, total: 5);
  final key = _todayKey();
  final list = await isar.dhikrDayProgress.filter().dateKeyEqualTo(key).findAll();
  int completed = 0;
  for (final p in list) {
    final counts = DhikrDayProgress.parseCounts(p.countsJson);
    if (counts.isEmpty || counts.every((c) => c == 0)) completed++;
  }
  return (completed: completed, total: 5);
}

/// سجل التزام الفئة خلال الأيام الماضية (للتاريخ).
Future<List<({int dateKey, bool completed})>> getCategoryHistory(Isar isar, String categoryId, {int days = 14}) async {
  if (!IsarService.isInitialized) return [];
  final key = _todayKey();
  final all = await isar.dhikrDayProgress
      .filter()
      .categoryIdEqualTo(categoryId)
      .dateKeyLessThan(key)
      .sortByDateKeyDesc()
      .limit(days)
      .findAll();
  return all.map((p) {
    final counts = DhikrDayProgress.parseCounts(p.countsJson);
    final completed = counts.isEmpty || counts.every((c) => c == 0);
    return (dateKey: p.dateKey, completed: completed);
  }).toList();
}
