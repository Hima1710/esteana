/// خدمة Supabase — تسجيل الدخول (جوجل) وغيرها. Placeholder حتى ربط Supabase Auth.
class SupabaseService {
  SupabaseService._();

  static final SupabaseService _instance = SupabaseService._();
  static SupabaseService get instance => _instance;

  /// تسجيل الدخول بجوجل — placeholder: يُرجع true عند النجاح (محاكاة).
  Future<bool> signInWithGoogle() async {
    // TODO: ربط Supabase Auth مع Google
    await Future.delayed(const Duration(milliseconds: 400));
    return true;
  }
}
