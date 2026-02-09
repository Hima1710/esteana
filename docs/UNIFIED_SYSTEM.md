# النظام الموحد للمشروع

مراجعة شاملة تمت لفرض النظام الموحد تقنياً وبصرياً ووظيفياً.

---

## 1. HookWidget وإدارة الحالة

- **الشاشات:** تم تحويل `SplashLandingScreen` و `AuthChoiceScreen` إلى `HookWidget` مع استخدام `useL10n()`.
- **التابات:** جميع التابات (المحراب، أثري، المجلس، زاد) مبنية أصلاً كـ `HookWidget` مع استخدام الـ Hooks المناسب (مثل `useStream`، `useState`، `useEffect`، `useMemoized`).
- **شاشات المصحف والقبلة والأذكار:** تعتمد على `HookWidget` وربط التحميل والتدفقات بالـ Hooks.

---

## 2. سلاسة القوائم (Builders)

- **فهرس المصحف (QuranListScreen):** استخدام `ListView.builder` في تاب السور، و`GridView.builder` في تاب الأجزاء، و`ListView.builder` في نتائج البحث وفي تاب العلامات.
- **المجلس (MajlisTab):** قائمة طلبات الدعاء مع `ListView.builder` بدل `Column` + `map` لتحسين الأداء مع عدد كبير من الطلبات.
- **أثري (AthariTab):** قائمة المهام اليومية مع `ListView.separated` وربط مباشر بـ Isar عبر `watch`.
- **زاد (ZadTab):** واجهة المقاطع القصيرة مع `PageView.builder` (Reels-style).

---

## 3. الهوية البصرية (Material 3 & Teal)

- **الخلفية:** استخدام `AppGradients.gradientFor(Theme.of(context).brightness)` في كل الشاشات والتابات (تدرج أخضر غامق Teal للوضع النهاري والليلي).
- **البطاقات:** تطبيق `shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius))` حيث `kShapeRadius = 24` على:
  - المحراب: `_PrayerTimesCard`, `_NextPrayerHeader` (كونتينر بتدرج), الـ Chips.
  - أثري: `_GuestSyncBanner`, `_AthariHeader`, `_TodayChallengeCard`, `_DailyTasksList`, `_ProgressBar`.
  - المجلس: `_PrayForMeIntro`, `_PrayerRequestCard`, قائمة الطلبات الفارغة, `_GroupChallengesSection`.
  - زاد: `_DailyQuoteCard`, والمقاطع.
  - المصحف: البطاقات في الفهرس والبحث والقراءة.
- **الألوان:** الاعتماد على `Theme.of(context).colorScheme` في كل الواجهات (primary، onSurface، surfaceContainerLow، إلخ).

---

## 4. التفاعل الفوري والربط بقواعد البيانات

- **أثري:**
  - المهام اليومية: `useStream(isar.dailyTasks.where().watch(fireImmediately: true))` — تحديث فوري من Isar عند تغيير "تم".
  - تحدي اليوم: `useStream` على `actionOfTheDayEntrys` مع `watch` — تحديث فوري عند الضغط على "تم".
- **المجلس:**
  - قائمة طلبات الدعاء: `useStream(PrayerRequestsService.watchRequests())` مع Supabase.
  - زر "دعوت لك": تحديث **تفاؤلي (optimistic)** عبر `useState<Set<String>>(localPrayedIds)` بحيث يتغير العرض فوراً ثم مزامنة Supabase في الخلفية.

---

## 5. اللغة والترجمة

- الشاشات والتابات التي تعرض نصوصاً للمستخدم تستخدم `useL10n()` أو `AppLocalizations.of(context)` وتستمد النصوص من ملفات `.arb` (عربي/إنجليزي).
- مفاتيح الترجمة تغطي العناوين، التابات، الرسائل، الأزرار، ورسائل الخطأ المعروضة للمستخدم.

---

## ملخص الملفات المعدّلة في هذه المراجعة

| الملف | التعديل |
|--------|---------|
| `splash_landing_screen.dart` | تحويل إلى HookWidget + useL10n |
| `auth_choice_screen.dart` | تحويل إلى HookWidget + useL10n |
| `majlis_tab.dart` | ListView.builder للطلبات، تحديث تفاؤلي لـ "دعوت لك"، شكل البطاقات 24dp |
| `athari_tab.dart` | إضافة shape 24dp لجميع البطاقات |
| `mihrab_tab.dart` | إضافة shape 24dp لـ Card الصلوات |
| `zad_tab.dart` | إضافة shape 24dp لـ Card مقولة اليوم |
| `quran_list_screen.dart` | نتائج البحث عبر ListView.builder بدل List |
