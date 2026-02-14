import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

/// أحداث البث لمزامنة المقرأة الجماعية.
abstract class MajlisBroadcastEvent {
  static const String pageChange = 'page_change';
  static const String verseHighlight = 'verse_highlight';
  static const String controlTransfer = 'control_transfer';
  static const String participantJoined = 'participant_joined';
  static const String participantLeft = 'participant_left';
}

/// بيانات حدث تغيير الصفحة.
class PageChangePayload {
  PageChangePayload({required this.page, required this.fromUserId});
  factory PageChangePayload.fromJson(Map<String, dynamic> json) =>
      PageChangePayload(
        page: (json['page'] as num?)?.toInt() ?? 1,
        fromUserId: json['from_user_id'] as String? ?? '',
      );
  final int page;
  final String fromUserId;
  Map<String, dynamic> toJson() => {'page': page, 'from_user_id': fromUserId};
}

/// بيانات حدث تظليل الآية. current = الحالية (أخضر)، past = الماضية (أحمر).
class VerseHighlightPayload {
  VerseHighlightPayload({
    required this.page,
    required this.verseKey,
    required this.status,
    required this.fromUserId,
  });
  factory VerseHighlightPayload.fromJson(Map<String, dynamic> json) =>
      VerseHighlightPayload(
        page: (json['page'] as num?)?.toInt() ?? 1,
        verseKey: json['verse_key'] as String? ?? '',
        status: json['status'] as String? ?? 'current',
        fromUserId: json['from_user_id'] as String? ?? '',
      );
  final int page;
  final String verseKey;
  final String status; // 'current' | 'past'
  final String fromUserId;
  Map<String, dynamic> toJson() =>
      {'page': page, 'verse_key': verseKey, 'status': status, 'from_user_id': fromUserId};
}

/// بيانات نقل التحكم.
class ControlTransferPayload {
  ControlTransferPayload({
    required this.controllerUserId,
    required this.controllerName,
  });
  factory ControlTransferPayload.fromJson(Map<String, dynamic> json) =>
      ControlTransferPayload(
        controllerUserId: json['controller_user_id'] as String? ?? '',
        controllerName: json['controller_name'] as String? ?? '',
      );
  final String controllerUserId;
  final String controllerName;
  Map<String, dynamic> toJson() =>
      {'controller_user_id': controllerUserId, 'controller_name': controllerName};
}

/// بيانات مشارك.
class ParticipantPayload {
  ParticipantPayload({
    required this.userId,
    required this.displayName,
    required this.isTeacher,
  });
  factory ParticipantPayload.fromJson(Map<String, dynamic> json) =>
      ParticipantPayload(
        userId: json['user_id'] as String? ?? '',
        displayName: json['display_name'] as String? ?? '',
        isTeacher: json['is_teacher'] as bool? ?? false,
      );
  final String userId;
  final String displayName;
  final bool isTeacher;
  Map<String, dynamic> toJson() =>
      {'user_id': userId, 'display_name': displayName, 'is_teacher': isTeacher};
}

/// خدمة مزامنة المقرأة الجماعية عبر Supabase Realtime Broadcast + Presence.
/// ملاحظة: عند إرسال التطبيق للخلفية يغلق النظام اتصالات الشبكة (WebSocket) لتوفير البطارية،
/// لذلك نوفّر [reconnect] لاستعادة الاشتراك عند العودة.
class MajlisRealtimeService {
  MajlisRealtimeService({required this.roomId});

  final String roomId;
  RealtimeChannel? _channel;
  String? _userId;
  String? _displayName;
  bool _isTeacher = false;
  final _pageController = StreamController<int>.broadcast();
  final _verseHighlightController =
      StreamController<VerseHighlightPayload>.broadcast();
  final _controlTransferController =
      StreamController<ControlTransferPayload>.broadcast();
  final _participantsController =
      StreamController<List<ParticipantPayload>>.broadcast();

  Stream<int> get pageStream => _pageController.stream;
  Stream<VerseHighlightPayload> get verseHighlightStream =>
      _verseHighlightController.stream;
  Stream<ControlTransferPayload> get controlTransferStream =>
      _controlTransferController.stream;
  Stream<List<ParticipantPayload>> get participantsStream =>
      _participantsController.stream;

  String get _channelName => 'majlis:$roomId';

  List<ParticipantPayload> _presenceStateToParticipants() {
    if (_channel == null) return [];
    final state = _channel!.presenceState();
    return state.map((s) {
      final presence = s.presences.isNotEmpty ? s.presences.first : null;
      if (presence == null) return null;
      final p = presence.payload;
      return ParticipantPayload(
        userId: (p['user_id'] as String?) ?? s.key,
        displayName: (p['display_name'] as String?) ?? '',
        isTeacher: (p['is_teacher'] as bool?) ?? false,
      );
    }).whereType<ParticipantPayload>().toList();
  }

  void _onBroadcast(String event, Map<String, dynamic> data) {
    final payload = data['payload'] is Map
        ? Map<String, dynamic>.from(data['payload'] as Map)
        : data;
    switch (event) {
      case MajlisBroadcastEvent.pageChange:
        _pageController.add(PageChangePayload.fromJson(payload).page);
        break;
      case MajlisBroadcastEvent.verseHighlight:
        _verseHighlightController.add(VerseHighlightPayload.fromJson(payload));
        break;
      case MajlisBroadcastEvent.controlTransfer:
        _controlTransferController.add(ControlTransferPayload.fromJson(payload));
        break;
    }
  }

  Future<void> join({
    required String userId,
    required String displayName,
    required bool isTeacher,
    void Function()? onSubscribed,
  }) async {
    _userId = userId;
    _displayName = displayName;
    _isTeacher = isTeacher;
    if (_channel != null) return;
    _channel = Supabase.instance.client.channel(
      _channelName,
      opts: const RealtimeChannelConfig(key: 'user_id', enabled: true),
    );
    _channel!
        .onPresenceSync((_) {
          _participantsController.add(_presenceStateToParticipants());
        })
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'majlis_rooms',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'room_id',
            value: roomId,
          ),
          callback: (payload) {
            final newRecord = payload.newRecord;
            if (newRecord['current_page'] != null) {
              final page = newRecord['current_page'];
              final p = page is int ? page : (page is num ? page.toInt() : 1);
              if (p >= 1) _pageController.add(p);
            }
          },
        )
        .onBroadcast(
          event: MajlisBroadcastEvent.pageChange,
          callback: (p) => _onBroadcast(MajlisBroadcastEvent.pageChange, p),
        )
        .onBroadcast(
          event: MajlisBroadcastEvent.verseHighlight,
          callback: (p) => _onBroadcast(MajlisBroadcastEvent.verseHighlight, p),
        )
        .onBroadcast(
          event: MajlisBroadcastEvent.controlTransfer,
          callback: (p) =>
              _onBroadcast(MajlisBroadcastEvent.controlTransfer, p),
        );
    _channel!.subscribe((status, [err]) async {
      if (status == RealtimeSubscribeStatus.subscribed) {
        await _channel?.track({
          'user_id': userId,
          'display_name': displayName,
          'is_teacher': isTeacher,
        });
        onSubscribed?.call();
      }
    });
  }

  /// إلغاء الاشتراك مع إبقاء الـ streams مفتوحة (لإعادة الاتصال لاحقاً).
  Future<void> _unsubscribe() async {
    await _channel?.untrack();
    await _channel?.unsubscribe();
    _channel = null;
  }

  /// إعادة الاتصال بقناة Realtime بعد العودة من الخلفية (النظام يقطع WebSocket عند إرسال التطبيق للخلفية).
  Future<void> reconnect({void Function()? onSubscribed}) async {
    if (_userId == null || _displayName == null) return;
    await _unsubscribe();
    await join(
      userId: _userId!,
      displayName: _displayName!,
      isTeacher: _isTeacher,
      onSubscribed: onSubscribed,
    );
  }

  Future<void> leave() async {
    await _unsubscribe();
    _userId = null;
    _displayName = null;
    await _pageController.close();
    await _verseHighlightController.close();
    await _controlTransferController.close();
    await _participantsController.close();
  }

  void broadcastPageChange(int page, String fromUserId) {
    _channel?.sendBroadcastMessage(
      event: MajlisBroadcastEvent.pageChange,
      payload: PageChangePayload(page: page, fromUserId: fromUserId).toJson(),
    );
  }

  void broadcastVerseHighlight(VerseHighlightPayload payload) {
    _channel?.sendBroadcastMessage(
      event: MajlisBroadcastEvent.verseHighlight,
      payload: payload.toJson(),
    );
  }

  void broadcastControlTransfer(ControlTransferPayload payload) {
    _channel?.sendBroadcastMessage(
      event: MajlisBroadcastEvent.controlTransfer,
      payload: payload.toJson(),
    );
  }
}
