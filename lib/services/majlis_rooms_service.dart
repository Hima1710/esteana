import 'package:supabase_flutter/supabase_flutter.dart';

/// نموذج مقرأة عامة من Supabase.
class MajlisRoomDto {
  MajlisRoomDto({
    required this.id,
    required this.roomId,
    required this.creatorName,
    required this.creatorId,
    required this.isPublic,
    required this.createdAt,
    this.shortCode,
  });

  factory MajlisRoomDto.fromJson(Map<String, dynamic> json) {
    final roomId = json['room_id'] as String;
    final short = json['short_code'] as String?;
    return MajlisRoomDto(
      id: json['id'] as String,
      roomId: roomId,
      creatorName: json['creator_name'] as String,
      creatorId: json['creator_id'] as String?,
      isPublic: json['is_public'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      shortCode: short ?? (roomId.length >= 8 ? roomId.substring(0, 8) : roomId),
    );
  }

  final String id;
  final String roomId;
  final String creatorName;
  final String? creatorId;
  final bool isPublic;
  final DateTime createdAt;
  /// رمز قصير للعرض والمشاركة (انضم برمز).
  final String? shortCode;
}

/// خدمة المقرآت النشطة — جلب وإضافة وحذف.
class MajlisRoomsService {
  static const _table = 'majlis_rooms';
  static const _activeWithinHours = 3;

  static Future<List<MajlisRoomDto>> fetchActiveRooms() async {
    final since = DateTime.now().toUtc().subtract(Duration(hours: _activeWithinHours));
    final res = await Supabase.instance.client
        .from(_table)
        .select()
        .eq('is_public', true)
        .gte('created_at', since.toIso8601String())
        .order('created_at', ascending: false);

    return (res as List<dynamic>)
        .map((e) => MajlisRoomDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }


  /// إنشاء غرفة: room_id = UUID كامل (لـ Jitsi/Realtime)، short_code = أول 8 أحرف للعرض والمشاركة.
  static Future<void> createRoom({
    required String roomId,
    required String creatorName,
    String? creatorId,
    bool isPublic = true,
  }) async {
    final shortCode = roomId.length >= 8 ? roomId.substring(0, 8) : roomId;
    await Supabase.instance.client.from(_table).insert({
      'room_id': roomId,
      'short_code': shortCode,
      'creator_name': creatorName,
      'creator_id': creatorId,
      'is_public': isPublic,
    });
  }

  /// جلب غرفة بالرمز القصير (انضم برمز) — يُرجع room_id الكامل للدخول.
  static Future<MajlisRoomDto?> getRoomByShortCode(String shortCode) async {
    final code = shortCode.trim().toLowerCase();
    if (code.isEmpty) return null;
    final res = await Supabase.instance.client
        .from(_table)
        .select()
        .or('short_code.eq.$code,room_id.eq.$code')
        .maybeSingle();
    if (res == null) return null;
    return MajlisRoomDto.fromJson(Map<String, dynamic>.from(res as Map));
  }

  static Future<void> deleteRoom(String roomId) async {
    await Supabase.instance.client.from(_table).delete().eq('room_id', roomId);
  }

  /// تحديث الصفحة الحالية للجلسة (يستدعيها المعلم عند تقليب الصفحة).
  static Future<void> updateCurrentPage({required String roomId, required int page}) async {
    await Supabase.instance.client
        .from(_table)
        .update({'current_page': page, 'updated_at': DateTime.now().toUtc().toIso8601String()})
        .eq('room_id', roomId);
  }

  /// جلب الصفحة الحالية من جدول الجلسة (للطالب عند الدخول أول مرة).
  static Future<int?> getCurrentPage(String roomId) async {
    final res = await Supabase.instance.client
        .from(_table)
        .select('current_page')
        .eq('room_id', roomId)
        .maybeSingle();
    if (res == null) return null;
    final page = res['current_page'];
    if (page is int) return page;
    if (page is num) return page.toInt();
    return null;
  }

  static const _logsTable = 'majlis_session_logs';

  /// تسجيل نهاية مقرأة وحفظها في السجل، ثم حذفها من القائمة النشطة.
  static Future<void> endAndLogSession({
    required String roomId,
    required String endedByUserId,
    required String endedByName,
    required int participantsCount,
    required int lastPage,
  }) async {
    await Supabase.instance.client.from(_logsTable).insert({
      'room_id': roomId,
      'ended_by_user_id': endedByUserId,
      'ended_by_name': endedByName,
      'participants_count': participantsCount,
      'last_page': lastPage,
    });
    await deleteRoom(roomId);
  }
}
