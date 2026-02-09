import 'dart:math';
import 'package:isar/isar.dart';

import '../models/daily_task.dart';
import '../models/action_of_the_day_entry.dart';
import '../models/prayer_request.dart';
import 'isar_service.dart';
import 'daily_challenge_service.dart' as daily_challenge;

/// قائمة تحيات اليوم الخاصة (عشوائية يومياً).
final List<({String key, String titleAr, String titleEn})> kActionOfTheDayTasks = [
  (key: 'help_parents', titleAr: 'مساعدة الوالدين', titleEn: 'Help your parents'),
  (key: 'read_page', titleAr: 'اقرأ صفحة من كتاب نافع', titleEn: 'Read a page from a beneficial book'),
  (key: 'smile_ten', titleAr: 'ابتسم لعشرة أشخاص', titleEn: 'Smile at ten people'),
  (key: 'give_sadaqa', titleAr: 'تصدّق ولو بقليل', titleEn: 'Give charity, even a little'),
  (key: 'call_relative', titleAr: 'اتصل بأحد أقاربك', titleEn: 'Call a relative'),
  (key: 'thank_allah', titleAr: 'احمد الله على نعمة واحدة', titleEn: 'Thank Allah for one blessing'),
];

/// مهام يومية افتراضية (مفتاح للترجمة + عنوان عربي للبذر).
final List<({String externalId, String titleAr})> kDefaultDailyTasks = [
  (externalId: 'daily_prayers', titleAr: 'الصلوات الخمس'),
  (externalId: 'smile', titleAr: 'الابتسامة'),
  (externalId: 'gratitude', titleAr: 'الامتنان والحمد'),
];

/// طلبات دعاء وهمية للمجلس.
final List<String> kDummyPrayerRequests = [
  'دعاء لوالدي بالشفاء',
  'طلب دعاء لامتحان ناجح',
  'ادعُ لأختي بالزواج السعيد',
  'دعاء لصديق في ضائقة',
];

/// تشغيل كل البذر عند أول تشغيل + ضمان وجود تحدي اليوم.
Future<void> runAllSeeds() async {
  final isar = IsarService.isar;
  await seedDefaultDailyTasks(isar);
  await seedDummyPrayerRequests(isar);
  final fromSupabase = await daily_challenge.getOrCreateDailyChallengeFromSupabase(IsarService.isar);
  if (fromSupabase == null) await getOrCreateActionOfTheDay(isar);
}

/// ملء المهام اليومية الافتراضية إذا كانت الجدول فارغاً.
Future<void> seedDefaultDailyTasks(Isar isar) async {
  final count = await isar.dailyTasks.count();
  if (count > 0) return;

  final now = DateTime.now();
  final tasks = kDefaultDailyTasks.asMap().entries.map((e) {
    final t = DailyTask()
      ..title = e.value.titleAr
      ..description = null
      ..completed = false
      ..sortOrder = e.key
      ..createdAt = now
      ..updatedAt = null
      ..externalId = e.value.externalId;
    return t;
  }).toList();

  await isar.writeTxn(() async => await isar.dailyTasks.putAll(tasks));
}

/// إنشاء طلبات دعاء وهمية إذا كانت الجدول فارغاً.
Future<void> seedDummyPrayerRequests(Isar isar) async {
  final count = await isar.prayerRequests.count();
  if (count > 0) return;

  final now = DateTime.now();
  final requests = kDummyPrayerRequests.asMap().entries.map((e) {
    final r = PrayerRequest()
      ..text = e.value
      ..createdAt = now.add(Duration(minutes: -e.key * 10))
      ..prayedByMe = false;
    return r;
  }).toList();

  await isar.writeTxn(() async => await isar.prayerRequests.putAll(requests));
}

/// تاريخ اليوم كـ yyyyMMdd (للاستخدام في الواجهات والاستعلام).
int todayKey() {
  final n = DateTime.now();
  return n.year * 10000 + n.month * 100 + n.day;
}

int _todayKey() => todayKey();

/// الحصول على تحدي اليوم أو إنشاؤه (عشوائي) ليوم واحد فقط.
Future<ActionOfTheDayEntry> getOrCreateActionOfTheDay(Isar isar) async {
  final key = _todayKey();
  final existing = await isar.actionOfTheDayEntrys.filter().dateKeyEqualTo(key).findFirst();
  if (existing != null) return existing;

  final random = Random();
  final task = kActionOfTheDayTasks[random.nextInt(kActionOfTheDayTasks.length)];
  final entry = ActionOfTheDayEntry()
    ..dateKey = key
    ..taskKey = task.key
    ..titleAr = task.titleAr
    ..titleEn = task.titleEn
    ..completed = false
    ..completedAt = null;

  await isar.writeTxn(() async => await isar.actionOfTheDayEntrys.put(entry));
  return entry;
}
