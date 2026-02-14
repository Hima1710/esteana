import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

/// خدمة Supabase — تسجيل الدخول (جوجل أصلي / مجهول) وربط الهوية.
class SupabaseService {
  SupabaseService._();

  static final SupabaseService _instance = SupabaseService._();
  static SupabaseService get instance => _instance;

  static GoogleSignIn? _googleSignIn;

  static GoogleSignIn get _googleSignInInstance {
    _googleSignIn ??= GoogleSignIn(
      serverClientId: SupabaseConfig.googleWebClientId,
    );
    return _googleSignIn!;
  }

  /// نتيجة تسجيل الدخول: نجاح أو فشل مع رسالة خطأ اختيارية.
  static (bool success, String? errorMessage) signInResult(bool success, [String? errorMessage]) =>
      (success, errorMessage);

  /// تسجيل الدخول بجوجل عبر النافذة الأصلية (Native). نافذة اختيار الحسابات تظهر فوق التطبيق دون الخروج لمتصفح.
  /// يُمرّر webClientId (serverClientId) ثم يُستخرج idToken و accessToken ويُربط مع Supabase عبر signInWithIdToken.
  Future<(bool success, String? errorMessage)> signInWithGoogleWithMessage() async {
    try {
      if (!SupabaseConfig.googleWebClientId.endsWith('.apps.googleusercontent.com')) {
        const msg = 'لم يُضبط googleWebClientId (Web Client ID) في الإعدادات';
        if (kDebugMode) debugPrint('signInWithGoogle: $msg');
        return signInResult(false, msg);
      }
      final googleSignIn = _googleSignInInstance;
      final account = await googleSignIn.signIn();
      if (account == null) {
        return signInResult(false, 'تم إلغاء اختيار الحساب');
      }
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        const msg = 'جوجل لم يُرجِع idToken. تأكد أن googleWebClientId = Web Client ID من Google Cloud (وليس Android)';
        if (kDebugMode) debugPrint('signInWithGoogle: $msg');
        return signInResult(false, msg);
      }
      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: auth.accessToken,
      );
      return signInResult(true);
    } on AuthException catch (e) {
      final msg = 'Supabase: ${e.message}';
      if (kDebugMode) debugPrint('signInWithGoogle AuthException: $msg');
      return signInResult(false, msg);
    } on Exception catch (e, st) {
      final msg = e.toString();
      if (kDebugMode) debugPrint('signInWithGoogle error: $e\n$st');
      return signInResult(false, msg);
    }
  }

  /// مثل [signInWithGoogleWithMessage] لكن يُرجع bool فقط (للتوافق مع الاستدعاءات الحالية).
  Future<bool> signInWithGoogle() async {
    final (bool success, _) = await signInWithGoogleWithMessage();
    return success;
  }

  /// الدخول كزائر بمجلّة مجهولة. يتطلب تفعيل Anonymous Sign-In في لوحة Supabase.
  /// عند الفشل (مثلاً غير مفعّل) يُرجع false.
  Future<bool> signInAnonymously() async {
    try {
      await Supabase.instance.client.auth.signInAnonymously();
      return true;
    } on Exception catch (e, st) {
      if (kDebugMode) {
        debugPrint('signInAnonymously error: $e\n$st');
      }
      return false;
    }
  }

  /// ربط الهوية الحالية (زائر مجهول) بحساب جوجل. يُرجع (نجاح، رسالة خطأ).
  Future<(bool success, String? errorMessage)> linkWithGoogleWithMessage() async {
    try {
      if (!SupabaseConfig.googleWebClientId.endsWith('.apps.googleusercontent.com')) {
        const msg = 'لم يُضبط googleWebClientId في الإعدادات';
        return signInResult(false, msg);
      }
      final googleSignIn = _googleSignInInstance;
      final account = await googleSignIn.signIn();
      if (account == null) return signInResult(false, 'تم إلغاء اختيار الحساب');
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        return signInResult(false, 'جوجل لم يُرجِع idToken. تأكد من Web Client ID');
      }
      await Supabase.instance.client.auth.linkIdentityWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: auth.accessToken,
      );
      return signInResult(true);
    } on AuthException catch (e) {
      return signInResult(false, 'Supabase: ${e.message}');
    } on Exception catch (e, st) {
      if (kDebugMode) debugPrint('linkWithGoogle error: $e\n$st');
      return signInResult(false, e.toString());
    }
  }

  Future<bool> linkWithGoogle() async {
    final (bool success, _) = await linkWithGoogleWithMessage();
    return success;
  }

  /// تسجيل الخروج من Supabase وجوجل.
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    await _googleSignInInstance.signOut();
  }
}
