# تشخيص بث الصوت/الفيديو في Jitsi على Android (Release / Android 16)

---

## حالة: الصوت والصورة يظهران عندي لكن لا يصلان للطرف الآخر — والمتصفحان يعملان معاً

إذا كان الوضع كالتالي:
- **من التطبيق:** أنت ترى وتسمع نفسك (محلياً) لكن الطرف الآخر لا يسمعك ولا يراك.
- **من المتصفح (نفس السيرفر):** عندما يفتح الطرفان من المتصفحات يتم الإرسال والاستقبال بنجاح.

فالسبب: **السيرفر (Jicofo) يمنح صلاحية إرسال الصوت/الفيديو للمتصفح ولا يمنحها لتطبيق الموبايل** (أو يمنحها لأول مشارك فقط إذا كان متصفحاً). التطبيق يطلب فتح المايك والكاميرا لكن السيرفر يرفض، لذلك البث لا يُنشر للآخرين. هذا **ليس خطأ في التطبيق** — اللوج يظهر: `Audio unmute permissions set by Jicofo to false`.

**ما الذي يمكنك فعله:**
1. **استخدام meet.jit.si للتشغيل الفعلي:** في `lib/config/jitsi_config.dart` ضبط `serverUrl = 'https://meet.jit.si'`. سيرفر meet.jit.si يسمح عادةً للمشاركين (بما فيهم التطبيق) بإرسال الصوت/الفيديو. (قد تظهر شاشة lobby؛ التطبيق يحاول تعطيلها من جهة العميل.)
2. **إن أردت البقاء على jitsi.member.fsf.org:** التواصل مع إدارة السيرفر لتمكين صلاحية إرسال الصوت/الفيديو لمشاركي التطبيق (إعدادات Jicofo)، أو منح دور moderator لأول مشارك حتى يوافق على فتح المايك للآخرين.

---

## لماذا الشات ورفع اليد يصلان لكن الصوت والصورة لا يصلان؟

### الفرق بين ما يعمل وما لا يعمل

| النوع | الآلية | النتيجة عندك |
|--------|--------|---------------|
| **الشات، رفع اليد، الإيماءات** | إشارات (signaling) عبر **XMPP/Data Channel** — نصوص وأحداث فقط، لا ميديا | ✓ تصل |
| **الصوت والفيديو** | **ميديا (RTP)** — تحتاج صلاحية من السيرفر (Jicofo) ثم إرسال فعلي للبث | ✗ لا تصل |

يعني: الاتصال بالسيرفر والانضمام للغرفة يعملان، لكن **السيرفر لا يمنح المشارك صلاحية إرسال الصوت/الفيديو** (أو يمنعها لاحقاً)، فالبث لا يُنقل للطرف الآخر.

### ما الذي يظهر في اللوج (السبب الأرجح)

ابحث في اللوج عن:

```
Audio unmute permissions set by Jicofo to false
Video unmute permissions set by Jicofo to false
```

إذا وُجدت هذه الأسطر فالمعنى:

- **Jicofo** (مكوّن السيرفر المسؤول عن الصلاحيات) يضبط صلاحية فتح المايك/الكاميرا إلى **false** لهذا المشارك.
- التطبيق يطلب فتح المايك والكاميرا (`setAudioMuted(false)` / `setVideoMuted(false)`) لكن السيرفر **يرفض**، فالبث لا يُنشر للآخرين.
- الشات ورفع اليد لا يعتمدان على هذه الصلاحية، لذلك يعملان.

### ماذا تفعل من جهة التطبيق

1. **التحقق من اللوج (ضروري)**  
   شغّل:
   ```bash
   adb logcat -s JitsiMeetSDK:V flutter:V | grep -E "unmute permissions|Jicofo|audioMutedChanged"
   ```
   - إن ظهرت `set by Jicofo to false` → المشكلة من **سياسة السيرفر** (انظر القسم التالي).
   - تتبّع أيضاً `audioMutedChanged`: إذا بقي `muted=true` بعد طلب الفتح → السيرفر لم يسمح.

2. **التأكد أن التطبيق يطلب الفتح ويُعيد المحاولة**  
   - الكود الحالي يفتح المايك/الكاميرا عند الدخول ويُعيد المحاولة كل 5 ثوانٍ لمدة دقيقتين (وحدة `JitsiAutoMediaListener`).
   - عند انضمام مشارك (مثلاً الـ Moderator) يُعاد طلب الفتح بعد 500 ms.
   - إذا وافق الـ Moderator من واجهة Jitsi، المحاولة التالية من التطبيق ستنجح والمكالمة ستستمر طبيعيًا.

3. **تجربة سيرفر آخر (للتشخيص)**  
   في `lib/config/jitsi_config.dart` غيّر مؤقتاً إلى:
   ```dart
   static const String serverUrl = 'https://meet.jit.si';
   ```
   ثم اختبر. إن الصوت/الفيديو يعملان على meet.jit.si ولا يعملان على jitsi.member.fsf.org فالمشكلة من **إعدادات سيرفر FSF** وليس من التطبيق.

### ماذا تفعل من جهة السيرفر (jitsi.member.fsf.org)

- المشكلة ليست من كود التطبيق بل من **سياسة السيرفر** (Jicofo / إعدادات الغرفة).
- يجب على مدير السيرفر (أو من يدير jitsi.member.fsf.org):
  - تمكين صلاحية إرسال الصوت/الفيديو للمشاركين (أو للضيوف حسب السياسة المطلوبة).
  - أو منح دور **moderator** لأول مشارك/للمعلم حتى يتمكن من الموافقة على فتح المايك للآخرين من واجهة Jitsi.

### خلاصة سريعة

- **الشات ورفع اليد يعملان** لأنها إشارات فقط (XMPP/Data Channel).
- **الصوت والصورة لا يصلان** لأن Jicofo يضبط "unmute permissions" إلى false، فيرفض طلب التطبيق بفتح المايك/الكاميرا.
- **الحل من التطبيق**: التأكد من طلب الفتح وإعادة المحاولة (موجود في `JitsiAutoMediaListener`) وانتظار موافقة الـ Moderator إن وُجد.
- **الحل الجذري**: تغيير إعدادات السيرفر (Jicofo) أو استخدام سيرفر يسمح بإرسال الصوت/الفيديو (مثل meet.jit.si للتجربة).

---

## 1. فحص AndroidManifest.xml

- **application:** `android:hardwareAccelerated="true"` ✓ (مطلوب لـ WebRTC/EGL).
- **activity (MainActivity):** `android:hardwareAccelerated="true"` ✓.
- **الصلاحيات المطلوبة:**
  - `RECORD_AUDIO`
  - `CAMERA`
  - `MODIFY_AUDIO_SETTINGS`
  - `FOREGROUND_SERVICE`
  - `FOREGROUND_SERVICE_MICROPHONE`
  - `FOREGROUND_SERVICE_CAMERA`

جميعها مُعلنة في المشروع.

---

## 2. ProGuard (Release)

يجب عدم حذف أو تشويش كلاسات WebRTC و Jitsi. الملف `android/app/proguard-rules.pro` يتضمن:

- `-keep class org.webrtc.** { *; }`
- `-keep class org.jitsi.meet.** { *; }`
- `-keep class com.facebook.react.**` (جسر React المستخدم من Jitsi)
- قواعد إضافية لـ EglBase، EglRenderer، SurfaceViewRenderer، VideoTrack، AudioTrack، و `com.oney.WebRTCModule` (react-native-webrtc).

---

## 3. SurfaceViewRenderer / EGL على Android 16

- مشكلة معروفة: إنشاء عدد كبير من سياقات EGL أو عدم استدعاء `release()` على الـ renderers يسبب أخطاء مثل `Failed to create EGL context: 0x3003`.
- الحل من جانب التطبيق: التأكد من أن قواعد ProGuard تحافظ على `org.webrtc.EglBase*`, `EglRenderer`, `SurfaceViewRenderer` (مضاف في المشروع).
- إن استمر crash صامت: تسجيل اللوجات (انظر أدناه) والبحث عن `EglBase`, `EglRenderer`, `SurfaceViewRenderer`, `call to OpenGL ES API with no current context`.

---

## 4. التحقق من تهيئة EGL في اللوجات

تشغيل التطبيق ثم:

```bash
adb logcat -s org.webrtc.Logging:V | grep -E "Egl|EGL|context|Surface"
```

ابحث عن:
- `EglBase14Impl: Using OpenGL ES version`
- `EglRenderer: Initializing EglRenderer`
- `SurfaceEglRenderer: surfaceChanged`
- أي رسالة خطأ تحتوي على `EGL` أو `context`.

---

## 5. التأكد من استخدام VP8 وليس H264

في الكود (Flutter) تم ضبط:

- `configOverrides['videoCodec'] = 'VP8'`
- `configOverrides['disableH264'] = true`

للتحقق من اللوجات (encoder فعلي):

```bash
adb logcat -s org.webrtc.Logging:V JitsiMeetSDK:V | grep -iE "codec|VP8|H264|encoder"
```

ابحث عن سطور مثل `codec=VP8` أو `Encode stats ... codec=VP8`.

---

## 6. Audio focus و AudioTrack

```bash
adb logcat | grep -iE "AudioTrack|AudioRecord|audio focus|MODIFY_AUDIO"
```

---

## 7. لوجات WebRTC و VideoTrack publish (مجمّعة)

لتسجيل كل ما يهم بث الصوت/الفيديو و Jitsi في وقت واحد:

```bash
adb logcat -s org.webrtc.Logging:V JitsiMeetSDK:V com.oney.WebRTCModule.VideoTrackAdapter:V com.oney.WebRTCModule.WebRTCModule:V flutter:V
```

أو حفظ اللوج في ملف:

```bash
adb logcat -s org.webrtc.Logging:V JitsiMeetSDK:V com.oney.WebRTCModule:V flutter:V > jitsi_webrtc_log.txt
```

ثم ابحث في الملف عن:
- `VideoTrackAdapter` / `First frame rendered`
- `JitsiMeetSDK` / `setReceiverVideoConstraint` / `TrackStreamingStatus`
- `org.webrtc.Logging` / `EglRenderer` / `CameraStatistics`

---

## ملخص أوامر سريعة

| الهدف              | الأمر |
|--------------------|--------|
| لوج WebRTC + Jitsi | `adb logcat -s org.webrtc.Logging:V JitsiMeetSDK:V com.oney.WebRTCModule:V` |
| **صلاحيات Jicofo (سبب عدم وصول الصوت/الفيديو)** | `adb logcat -s JitsiMeetSDK:V flutter:V \| grep -E "unmute permissions\|Jicofo\|audioMutedChanged"` |
| EGL / Surface      | `adb logcat -s org.webrtc.Logging:V \| grep -E "Egl\|EGL\|Surface"` |
| كودك/VP8           | `adb logcat -s org.webrtc.Logging:V JitsiMeetSDK:V \| grep -iE "codec\|VP8\|H264"` |
| Flutter (أحداث Jitsi) | `adb logcat -s flutter:V \| grep Jitsi` |

---

## فحص سريع: لماذا الأطراف لا تسمع ولا ترى بعضها؟

1. شغّل المكالمة ثم في الطرفية:  
   `adb logcat -s JitsiMeetSDK:V flutter:V | grep -E "unmute permissions|Jicofo"`  
   إن ظهر **"Audio unmute permissions set by Jicofo to false"** (وربما نفس الشيء للفيديو) → السبب من السيرفر وليس من التطبيق.
2. تأكد أن التطبيق يطلب فتح المايك/الكاميرا: ابحث في اللوج عن `[JitsiAutoMedia] unmute requested` و `[Jitsi] audioMutedChanged`.
3. جرّب نفس الغرفة من **المتصفح** (نفس السيرفر). إن الصوت/الفيديو يعملان من المتصفح فقط → السيرفر يعامل تطبيق الموبايل بشكل مختلف (صلاحيات أو دور).
4. للتجربة السريعة غيّر السيرفر إلى `https://meet.jit.si` في `jitsi_config.dart`. إن الصوت/الفيديو يعملان هناك → المشكلة من إعدادات jitsi.member.fsf.org.
