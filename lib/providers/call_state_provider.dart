import 'package:flutter/foundation.dart';

/// حالة المكالمة (Jitsi) للمقرأة الجماعية: تُحدَّث من أحداث الانضمام/الخروج والفيديو.
/// تُستخدم لتغيير أيقونة الـ AppBar وإظهار المؤشر النابض خارج صفحة المقرأة.
class CallState extends ChangeNotifier {
  bool _isInCall = false;
  bool _isVideoMuted = false;
  bool _isOnMajlisPage = false;

  bool get isInCall => _isInCall;
  bool get isVideoMuted => _isVideoMuted;
  bool get isOnMajlisPage => _isOnMajlisPage;

  void setInCall(bool value) {
    if (_isInCall == value) return;
    _isInCall = value;
    notifyListeners();
  }

  void setVideoMuted(bool value) {
    if (_isVideoMuted == value) return;
    _isVideoMuted = value;
    notifyListeners();
  }

  void setOnMajlisPage(bool value) {
    if (_isOnMajlisPage == value) return;
    _isOnMajlisPage = value;
    notifyListeners();
  }
}
