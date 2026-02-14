# إعداد الدخول بجوجل (أندرويد) — تفادي ApiException: 10

خطأ **ApiException: 10** (DEVELOPER_ERROR) يعني أن إعدادات التطبيق في Google Cloud لا تطابق التطبيق الفعلي.

## المطلوب في Google Cloud Console

1. **نفس المشروع** الذي فيه Web Client ID المستخدم في التطبيق.

2. **عميل OAuth 2.0 من نوع "Android":**
   - من [Google Cloud Console](https://console.cloud.google.com/) → **APIs & Services** → **Credentials**.
   - **Create Credentials** → **OAuth client ID**.
   - Application type: **Android**.
   - **Package name:** `com.esteana.noor` (مطابق لـ `namespace` في `android/app/build.gradle.kts`).
   - **SHA-1 certificate fingerprint:** أضف البصمة المستخدمة في التوقيع:
     ```
     A6:AE:1D:4F:82:16:3E:85:6F:91:AA:BA:A6:80:D2:57:36:51:99:F4
     ```
   - للبناء بـ **debug** استخدم SHA-1 من مفتاح debug:
     ```bash
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
     ```
   - أضف **كلا** SHA-1 (للـ release وللـ debug) إن كنت تختبر بـ debug وتنشر بـ release.

3. **عميل "Web application" (موجود لديك):**
   - نفسه المستخدم كـ **Web Client ID** في التطبيق و في Supabase (Authentication → Providers → Google).
   - القيمة الحالية في الكود: `467355813891-37e3gm60foov0pq3g2ppl1bipqs740bb.apps.googleusercontent.com`

4. **تفعيل Google Sign-In:**
   - **APIs & Services** → **Library** → ابحث عن **Google Sign-In** أو **Google+ API** (إن وُجد) وتأكد أن الـ API مفعّل للمشروع.

بعد تعديل الـ Android OAuth client (إضافة SHA-1 واسم الحزمة) انتظر دقائق ثم جرّب الدخول مرة أخرى.
