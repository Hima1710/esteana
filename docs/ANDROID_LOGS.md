# توضيح سجلات Android (Logcat)

## كيف تتتبع اللوج من التيرمنال

### 1. أثناء تشغيل التطبيق بـ Flutter
عند تشغيل التطبيق من التيرمنال تظهر سجلات Flutter تلقائياً في نفس النافذة:
```bash
cd /home/zero/new_esteana_noor
flutter run
```
كل ما يظهر من `print()` أو `debugPrint()` في كود Dart يظهر هنا، مع رسائل Flutter والإضافات.

### 2. لوج الجهاز فقط (التطبيق يعمل مسبقاً)
إذا كان التطبيق يعمل وتريد متابعة السجل دون إعادة التشغيل:
```bash
# كل سجل التطبيق (حزمة noor)
adb logcat --pid=$(adb shell pidof com.esteana.noor)

# أو تصفية حسب الوسم (tag)
adb logcat -s flutter
adb logcat -s PrayerWidget
```

### 3. أوامر مفيدة لـ logcat
```bash
# مسح السجل ثم متابعة سجل التطبيق فقط
adb logcat -c && adb logcat | grep -E "flutter|com.esteana.noor|4229"

# فقط رسائل Flutter (مستوى Info فأعلى)
adb logcat flutter:I *:S

# سجل ويدجت العد التنازلي فقط
adb logcat -s PrayerWidget

# حفظ السجل في ملف
adb logcat > log.txt
```
**ملاحظة:** استبدل `4229` بـ PID التطبيق الحالي (يظهر في أول سطر من `adb logcat` بصيغة `------ beginning of main` ثم رقم العملية).

### 4. من Android Studio
**View → Tool Windows → Logcat** ثم اختر الجهاز والتطبيق `com.esteana.noor`. يمكن التصفية حسب نص أو Tag (مثل `flutter` أو `PrayerWidget`).

---

## تتبع الـ Overflow (انفساخ التخطيط)

عند حدوث **overflow** (نص أو ويدجت يخرج عن الحدود)، Flutter في وضع **Debug** يفعّل تلقائياً:
1. **على الشاشة:** شريط أصفر وأسود على مكان الـ overflow مع رسالة مثل `overflow by 42 pixels`.
2. **في التيرمنال:** سطر في اللوج يذكر الـ overflow والويدجت المسؤول.

### من التيرمنال
```bash
flutter run
```
عند حدوث overflow ستظهر رسالة شبيهة بـ:
```text
flutter: The following assertion was thrown during layout:
flutter: A RenderFlex overflowed by 42 pixels on the bottom.
...
```
يمكن تصفية اللوج لرؤية overflow فقط:
```bash
# تشغيل التطبيق ثم في نافذة أخرى:
adb logcat | grep -i overflow
```
أو أثناء `flutter run` كل رسائل الـ overflow تظهر في نفس النافذة مع stack trace.

### جعل الـ overflow أوضح
- التشغيل بـ **Debug** (الافتراضي مع `flutter run`) يكفي لرؤية الشريط الأصفر/الأسود والرسالة في الكونسول.
- إن أردت تفعيل عرض الـ overflow حتى في **Profile**: غير معقول عادة؛ الأفضل الإصلاح في Debug ثم الاختبار في Profile/Release.

### إصلاح الـ overflow
الرسالة تخبرك بالويدجت (مثلاً `RenderFlex`, `Row`, `Column`) وعدد البكسل. الحلول الشائعة:
- لف المحتوى في `SingleChildScrollView` أو `ListView` إذا كان النص أو القائمة طويلة.
- استخدام `Expanded` / `Flexible` داخل `Row` أو `Column`.
- تقليل حجم الخط أو المسافات، أو `FittedBox` للنص الطويل.

---

## لوج ويدجت العد التنازلي (العداد المستقل)

للتأكد من أن العداد المستقل للويدجت يعمل:
```bash
adb logcat -s PrayerWidget
```

ما يظهر:
- **onUpdate** — كلما تُحدَّث الويدجت (من التطبيق أو من التنبيه بعد دقيقة): عدد الويدجتات، وقت الصلاة القادمة، العد المحسوب (HH:mm)، والوقت الحالي.
- **scheduleNextUpdate** — تأكيد جدولة التحديث التالي بعد 60 ثانية.
- **onDisabled** / **cancelScheduledUpdate** — عند إزالة الويدجت من الشاشة الرئيسية.

إذا رأيت `onUpdate` ثم بعد نحو دقيقة `onUpdate` مرة أخرى (بدون فتح التطبيق)، فالعداد المستقل يعمل.

---

## الخلاصة
**لا تحتاج أي من هذه السجلات إلى تعديل في كود التطبيق.** مصدرها إمّا النظام (system_server)، أو مشغّل الرسوميات (Mali/HWUI)، أو مكتبات Flutter/الموقع. يمكن تجاهلها ما لم يظهر سلوك خاطئ فعلي في التطبيق (تعطيل، شاشة بيضاء، إلخ).

---

## سجلات طبيعية أو من النظام

### FlutterGeolocator
- **"Geolocator position updates started"** — يظهر عند فتح شاشة القبلة وبدء استخدام الموقع.
- **"Geolocator position updates stopped"** — يظهر عند الخروج من الشاشة وإيقاف التحديثات (موفر للبطارية).
- **"There is still another flutter engine connected, not stopping location service"** — رسالة من مكتبة الموقع وليست خطأ؛ تعني أن خدمة الموقع ما زالت مطلوبة من جزء آخر.

### NotificationPrefHelper / PackageManager
- **could not restore com.esteana.noor / NameNotFoundException** — من **النظام** (system_server، عملية 1558) وليس من تطبيقك. يحدث عندما يحاول Android استعادة إعدادات الإشعارات للحزمة في لحظة لا يجد فيها الحزمة (مثلاً بعد إعادة التثبيت أو أثناء التحديث). **لا يتطلب أي تعديل في الكود** ولا يؤثر على عمل التطبيق.

### ashmem / HWUI / mali_gralloc / perfctl / legacy_receive_flag
- **Pinning is deprecated since Android Q** — تحذير من النظام.
- **attachRenderThreadToJvm, AM IS NOT NULL!** — من خيوط الرسم (Flutter/Android).
- **mali_gralloc: Format allocation... / Invalid base format** — من مشغّل الرسوميات (Mali) على أجهزة Samsung/ARM. عادة لا يسبب تعطل التطبيق.
- **[perfctl] / legacy_receive_flag: 0** — رسائل من نظام الجهاز أو محرك Flutter، يمكن تجاهلها.

### PowerHalMgrImpl / perfmgr_sbe / userfaultfd
- **PowerHalMgrImpl: hdl:… pid:…** — من إدارة الطاقة/الأداء في الجهاز (vendor). معلوماتية فقط، لا تحتاج إجراءً.
- **/proc/perfmgr_sbe/sbe_ioctl not exists** — الجهاز يبحث عن واجهة أداء غير موجودة على هذا النموذج. من النظام وليس من التطبيق.
- **userfaultfd: MOVE ioctl seems unsupported: Connection timed out** — متعلق بالذاكرة/النواة أو محرك Flutter على بعض الأجهزة. عادة لا يوقف التطبيق.

### Choreographer: Skipped N frames
- **Skipped 39 frames! The application may be doing too much work on its main thread.** — تحذير أداء: الـ UI تأخر عن الرسم (حوالي 0.6 ثانية). إن لاحظت تقطيعاً عند التمرير أو فتح شاشة معينة، جرّب تخفيف العمل على الـ main thread (نقل عمليات ثقيلة لـ isolate أو تأخيرها، أو تحسين بناء الويدجتات).
- **ScrollIdentify: on fling** — تسجيل حدث تمرير سريع. عادي.
- **WindowOnBackDispatcher: sendCancelIfRunning** — تعامل عادي مع زر الرجوع أو الإيماءة. ليس خطأ.

---

## سجل قد يؤثر على الواجهة

### Invalid resource ID 0x00000000
- يظهر أحياناً مع مكوّنات Material (مثل SearchBar أو Chip) على بعض إصدارات Android/الأجهزة.
- غالباً **لا يوقف التطبيق** وإنما يحاول النظام استخدام مورد غير موجود فيرجع 0.
- إذا رافق مشكلة في الواجهة (مثل شاشة فارغة)، جرّب على جهاز أو محاكي آخر، أو تحديث Flutter وتبعيات المشروع.

---

## ماذا تفعل؟
- **شاشة القبلة:** رسائل Geolocator طبيعية.
- **شاشة المصحف أو أي واجهة:** إذا كانت الشاشة فارغة، المشكلة عادة من التخطيط أو تحميل البيانات (راجع التعديلات على `QuranListScreen` من قبل).
- **بقية السجلات:** لا تحتاج إجراءً في العادة.
