import 'package:isar/isar.dart';

import '../models/daily_task.dart';
import 'luminous_service.dart';

/// نظام موحد لتسجيل الإنجاز: مزامنة Isar (واختيارياً Supabase) عند إكمال مهمة أو ذكر،
/// لضمان تحديث الصندوق الجامع وشريط التقدم الأسبوعي تلقائياً.
class ProgressSystem {
  ProgressSystem._();

  /// تسجيل «فعل خير» في Isar (يظهر في تاب أثري وشريط التقدم الأسبوعي).
  static Future<void> recordGoodDeed(Isar isar, String title, {String? externalId}) async {
    try {
      final now = DateTime.now();
      final tasks = await isar.dailyTasks.where().sortBySortOrderDesc().findAll();
      final maxOrder = tasks.isEmpty ? 0 : (tasks.first.sortOrder + 1);
      final task = DailyTask()
        ..title = title
        ..description = null
        ..completed = true
        ..sortOrder = maxOrder
        ..createdAt = now
        ..updatedAt = now
        ..externalId = externalId ?? 'progress_${now.millisecondsSinceEpoch}';
      await isar.writeTxn(() async => await isar.dailyTasks.put(task));
    } catch (_) {}
  }

  /// إضافة قطع نورانية (تحديث الصندوق الجامع والطافي تلقائياً عبر LuminousService).
  static Future<void> addLuminousPieces(int count) async {
    await LuminousService.addPieces(count);
  }

  /// عند إكمال ذكر أو مهمة: إضافة قطع نورانية + تسجيل فعل خير إن رُغب.
  /// [luminousCount] يُضاف للصندوق، [goodDeedTitle] إن وُجد يُسجّل كـ DailyTask مكتمل.
  static Future<void> recordCompletion({
    required Isar isar,
    int luminousCount = 0,
    String? goodDeedTitle,
    String? externalId,
  }) async {
    if (luminousCount > 0) await addLuminousPieces(luminousCount);
    if (goodDeedTitle != null && goodDeedTitle.isNotEmpty) {
      await recordGoodDeed(isar, goodDeedTitle, externalId: externalId);
    }
  }

  /// مزامنة مع Supabase (placeholder للمستقبل — إنجازات سحابية).
  static Future<void> syncAchievementToSupabase(String title, {int luminousValue = 0}) async {
    // TODO: عند توفر جدول achievements أو user_progress في Supabase
    await Future<void>.value();
  }
}
