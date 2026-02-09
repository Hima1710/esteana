import 'package:flutter/foundation.dart';

import '../services/supabase_service.dart';

/// حالة المصادقة: ضيف أو مسجّل (جوجل لاحقاً).
enum AuthMode { guest, signedIn }

/// مزوّد حالة الدخول — ضيف / مسجّل.
class AuthProvider extends ChangeNotifier {
  AuthMode _mode = AuthMode.guest;

  AuthMode get mode => _mode;
  bool get isGuest => _mode == AuthMode.guest;

  void setGuest() {
    if (_mode == AuthMode.guest) return;
    _mode = AuthMode.guest;
    notifyListeners();
  }

  void setSignedIn() {
    if (_mode == AuthMode.signedIn) return;
    _mode = AuthMode.signedIn;
    notifyListeners();
  }

  /// تسجيل الدخول بجوجل ثم تحديث الحالة.
  Future<bool> signInWithGoogle() async {
    final ok = await SupabaseService.instance.signInWithGoogle();
    if (ok) setSignedIn();
    return ok;
  }
}
