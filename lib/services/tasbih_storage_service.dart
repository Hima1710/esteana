import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/dhikr_day_progress.dart';
import 'dhikr_progress_service.dart';
import 'isar_service.dart';

const String _kTasbihCategoryId = 'tasbih';

int _todayKey() {
  final n = DateTime.now();
  return n.year * 10000 + n.month * 100 + n.day;
}

/// تحميل عداد التسبيح (السبحة) لليوم من التخزين المحلي.
/// يُرجع 0 إن لم يُحفظ شيء لهذا اليوم.
Future<int> getTasbihCountToday(Isar isar) async {
  if (!IsarService.isInitialized) return 0;
  final p = await getTodayProgress(isar, _kTasbihCategoryId);
  if (p == null) return 0;
  final list = DhikrDayProgress.parseCounts(p.countsJson);
  return list.isEmpty ? 0 : list.first;
}

/// حفظ عداد التسبيح لليوم محلياً وفي Supabase (إن كان المستخدم مسجلاً).
Future<void> saveTasbihCountToday(Isar isar, int count) async {
  if (!IsarService.isInitialized) return;
  await saveTodayProgress(isar, _kTasbihCategoryId, [count]);

  try {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    final dateKey = _todayKey();
    await Supabase.instance.client.from('tasbih_daily').upsert(
      {
        'user_id': userId,
        'date_key': dateKey,
        'count': count,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      },
      onConflict: 'user_id,date_key',
    );
  } catch (e) {
    if (kDebugMode) debugPrint('TasbihStorage: Supabase sync failed: $e');
  }
}
