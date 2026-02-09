import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

/// طلب دعاء من السحاب (Supabase).
class PrayerRequestDto {
  const PrayerRequestDto({
    required this.id,
    required this.text,
    required this.createdAt,
    this.prayedCount = 0,
    this.iPrayed = false,
  });

  final String id;
  final String text;
  final DateTime createdAt;
  final int prayedCount;
  final bool iPrayed;
}

/// خدمة طلبات الدعاء — Supabase.
class PrayerRequestsService {
  PrayerRequestsService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static String? get _userId => _client.auth.currentUser?.id;
  static String get _anonId {
    if (_cachedAnonId != null) return _cachedAnonId!;
    _cachedAnonId = 'anon_${DateTime.now().millisecondsSinceEpoch}';
    return _cachedAnonId!;
  }

  static String? _cachedAnonId;

  /// جلب القائمة مرة واحدة مع حالة "دعوت لك" للمستخدم الحالي.
  static Future<List<PrayerRequestDto>> getRequests() async {
    final userId = _userId ?? _anonId;
    final res = await _client
        .from('prayer_requests')
        .select()
        .order('created_at', ascending: false);
    final list = res as List<dynamic>;
    if (list.isEmpty) return [];
    final ids = list.map((e) => e['id'] as String).toList();
    final prayedIds = await _getPrayedRequestIds(userId, ids);
    return list.map((row) {
      final id = row['id'] as String;
      return PrayerRequestDto(
        id: id,
        text: row['text'] as String,
        createdAt: DateTime.parse(row['created_at'] as String),
        prayedCount: (row['prayed_count'] as num?)?.toInt() ?? 0,
        iPrayed: prayedIds.contains(id),
      );
    }).toList();
  }

  static Future<Set<String>> _getPrayedRequestIds(String userId, List<String> requestIds) async {
    if (requestIds.isEmpty) return {};
    final res = await _client
        .from('prayer_prays')
        .select('request_id')
        .eq('user_id', userId)
        .inFilter('request_id', requestIds);
    return (res as List<dynamic>).map((e) => e['request_id'] as String).toSet();
  }

  /// تيار طلبات الدعاء — يُصدِر فوراً ثم كل 8 ثوانٍ.
  static Stream<List<PrayerRequestDto>> watchRequests() async* {
    yield await getRequests();
    await for (final _ in Stream.periodic(const Duration(seconds: 8))) {
      yield await getRequests();
    }
  }

  /// إضافة طلب دعاء (للمسجّلين أو الضيف — author_id اختياري).
  static Future<void> addRequest(String text) async {
    await _client.from('prayer_requests').insert({
      'text': text,
      'author_id': _userId,
    });
  }

  /// تسجيل "دعوت لك" وزيادة العداد في السحاب.
  static Future<void> markPrayed(String requestId) async {
    final userId = _userId ?? _anonId;
    try {
      await _client.from('prayer_prays').insert({
        'request_id': requestId,
        'user_id': userId,
      });
    } catch (_) {}
  }
}
