/// إعداد سيرفر Jitsi للمقرأة الجماعية.
/// غيّر [serverUrl] لتجربة خوادم أخرى (مثلاً https://meet.jit.si).
///
/// ملاحظة: إذا كان الصوت/الفيديو يعمل من المتصفح على نفس السيرفر لكن لا يصل من التطبيق،
/// جرّب فتح الغرفة من التطبيق أولاً ثم الانضمام من المتصفح (أو العكس) لمعرفة إن كانت
/// الصلاحيات مرتبطة بأول مشارك (moderator). إن استمرت المشكلة فالإعداد من جانب السيرفر (Jicofo).
class JitsiConfig {
  JitsiConfig._();

  /// سيرفر Jitsi المستخدم للمكالمات.
  /// FSF: خدمة مجانية لأعضاء Free Software Foundation — خصوصية وبرمجيات حرة.
  /// للاختبار مع سيرفر يسمح عادةً بإرسال الصوت/الفيديو: استخدم 'https://meet.jit.si'.
  /// (التطبيق يعطّل الـ lobby تلقائياً عند meet.jit.si لتجنّب شاشة الانتظار.)
  /// @see https://jitsi.member.fsf.org
  /// FF.MUC: سيرفر مجتمعي (Freifunk Munich) — https://meet.ffmuc.net/
  static const String serverUrl = 'https://meet.ffmuc.net';
}
