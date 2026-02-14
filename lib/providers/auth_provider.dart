import 'package:flutter/foundation.dart';

import '../services/supabase_service.dart';

/// حالة المصادقة: ضيف (بدون جلسة)، زائر مجهول (جلسة anonymous)، أو مسجّل (جوجل).
enum AuthMode { guest, anonymous, signedIn }

/// مزوّد حالة الدخول — ضيف / زائر مجهول / مسجّل.
class AuthProvider extends ChangeNotifier {
  AuthMode _mode = AuthMode.guest;

  AuthMode get mode => _mode;
  /// ضيف بدون جلسة Supabase (محلي فقط).
  bool get isGuest => _mode == AuthMode.guest;
  /// زائر بمجلّة مجهولة (يمكن ربطها بجوجل لاحقاً).
  bool get isAnonymous => _mode == AuthMode.anonymous;
  /// مسجّل بهوية (مثلاً جوجل).
  bool get isSignedIn => _mode == AuthMode.signedIn;

  void setGuest() {
    if (_mode == AuthMode.guest) return;
    _mode = AuthMode.guest;
    notifyListeners();
  }

  void setAnonymous() {
    if (_mode == AuthMode.anonymous) return;
    _mode = AuthMode.anonymous;
    notifyListeners();
  }

  void setSignedIn() {
    if (_mode == AuthMode.signedIn) return;
    _mode = AuthMode.signedIn;
    notifyListeners();
  }

  /// تسجيل الدخول بجوجل. النجاح يُحدّث عبر onAuthStateChange.
  /// يُرجع (نجاح، رسالة خطأ إن وُجدت).
  Future<(bool success, String? errorMessage)> signInWithGoogle() async {
    return SupabaseService.instance.signInWithGoogleWithMessage();
  }

  /// الدخول كزائر: إنشاء جلسة مجهولة إن أمكن، وإلا ضيف محلي.
  Future<bool> signInAsGuest() async {
    final ok = await SupabaseService.instance.signInAnonymously();
    if (ok) {
      setAnonymous();
    } else {
      setGuest();
    }
    return ok;
  }

  /// ربط الحساب المجهول الحالي بحساب جوجل. يُرجع (نجاح، رسالة خطأ).
  Future<(bool success, String? errorMessage)> linkWithGoogle() async {
    return SupabaseService.instance.linkWithGoogleWithMessage();
  }

  /// تسجيل الخروج.
  Future<void> signOut() async {
    await SupabaseService.instance.signOut();
    setGuest();
  }
}
