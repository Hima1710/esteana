/// إعدادات Supabase — غيّرها حسب مشروعك أو انقلها إلى متغيرات بيئة.
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = 'https://bvzavvrancoxkwhwpalo.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ2emF2dnJhbmNveGt3aHdwYWxvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk1MjczMDgsImV4cCI6MjA4NTEwMzMwOH0.ogcR3bKco1sVq3X1FfbPi8aVqX8XBFXBAXwSILP6mZU';

  /// رابط إعادة التوجيه بعد OAuth (يجب أن يطابق ما في Supabase و Google Cloud).
  static const String redirectUrl = 'com.esteana.noor://login-callback/';

  /// Web Client ID من Google Cloud (نوع "Web application"). يُستخدم للحصول على idToken.
  /// لتفادي ApiException: 10 أضف في نفس المشروع عميل "Android" وضَع فيه اسم الحزمة + بصمة SHA-1.
  static const String googleWebClientId =
      '467355813891-37e3gm60foov0pq3g2ppl1bipqs740bb.apps.googleusercontent.com';
}
