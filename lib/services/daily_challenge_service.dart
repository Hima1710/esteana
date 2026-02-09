import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:isar/isar.dart';

import '../models/action_of_the_day_entry.dart';

/// نتيجة تحدي يومي من Supabase.
class DailyChallengeResult {
  const DailyChallengeResult({
    required this.titleAr,
    required this.titleEn,
    this.luminousValue = 1,
  });
  final String titleAr;
  final String titleEn;
  final int luminousValue;
}

int _todayKey() {
  final n = DateTime.now();
  return n.year * 10000 + n.month * 100 + n.day;
}

/// جلب تحدي اليوم من Supabase (عشوائي حسب تاريخ اليوم) وحفظه في Isar.
Future<ActionOfTheDayEntry?> getOrCreateDailyChallengeFromSupabase(Isar isar) async {
  final key = _todayKey();
  final existing = await isar.actionOfTheDayEntrys.filter().dateKeyEqualTo(key).findFirst();
  if (existing != null) return existing;

  final challenge = await _fetchDailyChallengeForToday();
  if (challenge == null) return null;

  final entry = ActionOfTheDayEntry()
    ..dateKey = key
    ..taskKey = 'supabase_$key'
    ..titleAr = challenge.titleAr
    ..titleEn = challenge.titleEn
    ..completed = false
    ..completedAt = null;

  await isar.writeTxn(() async => await isar.actionOfTheDayEntrys.put(entry));
  return entry;
}

/// جلب تحدي واحد من daily_challenges حسب تاريخ اليوم (نفس اليوم = نفس التحدي).
Future<DailyChallengeResult?> _fetchDailyChallengeForToday() async {
  try {
    final client = Supabase.instance.client;
    final res = await client.from('daily_challenges').select('challenge_text_ar, challenge_text_en, luminous_value');
    final list = res as List<dynamic>?;
    if (list == null || list.isEmpty) return null;

    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final index = dayOfYear % list.length;
    final row = list[index] as Map<String, dynamic>;
    return DailyChallengeResult(
      titleAr: row['challenge_text_ar'] as String? ?? '',
      titleEn: row['challenge_text_en'] as String? ?? '',
      luminousValue: (row['luminous_value'] as num?)?.toInt() ?? 1,
    );
  } catch (_) {
    return null;
  }
}
