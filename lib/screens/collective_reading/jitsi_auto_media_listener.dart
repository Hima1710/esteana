import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

/// وحدة منفصلة: فتح المايك والكاميرا أوتوماتيكياً عند دخول المكالمة، مع إعادة المحاولة
/// حتى لو السيرفر (Jicofo) منع البداية. عند موافقة الـ Moderator تصبح المكالمة طبيعية.
///
/// الاستخدام: لفّ الـ listener الحالي ثم استخدم الناتج في join:
/// ```dart
/// final listener = JitsiAutoMediaListener.wrapWithAutoMedia(
///   JitsiMeetEventListener(
///     conferenceJoined: (url) async { ... },
///     ...
///   ),
/// );
/// JitsiMeet().join(options, listener);
/// ```
class JitsiAutoMediaListener {
  JitsiAutoMediaListener._();

  static Timer? _retryTimer;
  static const Duration _defaultRetryInterval = Duration(seconds: 5);
  static const Duration _defaultRetryWindow = Duration(minutes: 2);
  static DateTime? _joinedAt;
  static Duration _retryWindow = _defaultRetryWindow;

  static void _cancelRetry() {
    _retryTimer?.cancel();
    _retryTimer = null;
    _joinedAt = null;
  }

  static Future<void> _unmuteNow() async {
    try {
      final jitsi = JitsiMeet();
      await jitsi.setAudioMuted(false);
      await jitsi.setVideoMuted(false);
      debugPrint('[JitsiAutoMedia] unmute requested (إذا السيرفر سمح ستستلم audioMutedChanged: false)');
    } catch (_) {}
  }

  static void _scheduleRetries({Duration retryInterval = _defaultRetryInterval, Duration retryWindow = _defaultRetryWindow}) {
    _cancelRetry();
    _joinedAt = DateTime.now();
    _retryWindow = retryWindow;
    _unmuteNow();

    _retryTimer = Timer.periodic(retryInterval, (_) {
      if (_joinedAt == null) return;
      if (DateTime.now().difference(_joinedAt!) > _retryWindow) {
        _cancelRetry();
        return;
      }
      _unmuteNow();
    });
  }

  /// يلفّ [base] listener ويضيف سلوك فتح المايك/الكاميرا تلقائياً مع إعادة المحاولة حتى موافقة الـ Moderator.
  static JitsiMeetEventListener wrapWithAutoMedia(
    JitsiMeetEventListener base, {
    /// فترة بين كل محاولة فتح مايك/كاميرا (افتراضي 5 ثوان).
    Duration retryInterval = _defaultRetryInterval,
    /// مدة إعادة المحاولة بعد الدخول (افتراضي دقيقتان).
    Duration retryWindow = _defaultRetryWindow,
    /// تأخير قبل فتح المايك/الكاميرا عند انضمام مشارك (مثلاً Moderator).
    Duration onParticipantJoinedDelay = const Duration(milliseconds: 500),
  }) {
    return JitsiMeetEventListener(
      conferenceWillJoin: base.conferenceWillJoin,
      conferenceJoined: (url) async {
        if (base.conferenceJoined != null) {
          final r = base.conferenceJoined!(url);
          if (r is Future) await r;
        }
        _scheduleRetries(retryInterval: retryInterval, retryWindow: retryWindow);
      },
      conferenceTerminated: (url, error) async {
        _cancelRetry();
        if (base.conferenceTerminated != null) {
          final r = base.conferenceTerminated!(url, error);
          if (r is Future) await r;
        }
      },
      readyToClose: () async {
        _cancelRetry();
        if (base.readyToClose != null) {
          final r = base.readyToClose!();
          if (r is Future) await r;
        }
      },
      participantJoined: (email, name, role, participantId) async {
        if (base.participantJoined != null) {
          final r = base.participantJoined!(email, name, role, participantId);
          if (r is Future) await r;
        }
        await Future.delayed(onParticipantJoinedDelay);
        await _unmuteNow();
      },
      participantLeft: base.participantLeft,
      audioMutedChanged: base.audioMutedChanged,
      videoMutedChanged: base.videoMutedChanged,
      endpointTextMessageReceived: base.endpointTextMessageReceived,
      screenShareToggled: base.screenShareToggled,
      chatMessageReceived: base.chatMessageReceived,
      chatToggled: base.chatToggled,
      participantsInfoRetrieved: base.participantsInfoRetrieved,
      customButtonPressed: base.customButtonPressed,
    );
  }
}
