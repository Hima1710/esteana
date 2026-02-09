# تقرير التدقيق الفني والتصميمي — The Muslim Journey
## Project Audit Report (Unified UI/UX & Codebase)

---

## 1. النظام الموحد (Unified UI/UX System)

### 1.1 الألوان المستخدمة

| المصدر | الاستخدام | القيم / الملاحظات |
|--------|-----------|---------------------|
| **التدرج الأخضر Teal (نهاري)** | خلفيات التابات والشاشات الفرعية | `AppColors.tealDark` (#004D40), `tealMid` (#00695C), `tealLight` (#00897B) — عبر `AppGradients.tealGradient` |
| **التدرج Teal (ليلي)** | نفس الخلفيات في الوضع الداكن | `AppColors.darkBgStart` (#0D1F1C), `darkBgMid` (#132A26), `darkBgEnd` (#1A3630) — عبر `AppGradients.tealGradientDark` |
| **الاختيار التلقائي** | كل الشاشات | `AppGradients.gradientFor(Theme.of(context).brightness)` |
| **القطع النورانية** | الصندوق الطافي، البطاقات، التوهج | `colorScheme.primary` و `colorScheme.primaryContainer` (مشتقة من Teal)؛ توهج: `colorScheme.primary.withValues(alpha: 0.5)` إلى `0.7` |
| **Surface** | البطاقات، الحقول | `colorScheme.surface`, `surfaceContainerLow`, `surfaceContainerHighest`, `primaryContainer.withValues(alpha: 0.5–0.8)` |
| **النص** | العناوين والنصوص | `colorScheme.onSurface`, `onPrimaryContainer` مع `withValues(alpha: 0.8)` للثانوي |

**ملاحظة:** لا تُستخدم ألوان هيكلية خارج `AppColors` و `Theme.of(context).colorScheme` لضمان توحيد الوضع الليلي/النهاري.

---

### 1.2 معايير التصميم

| المعيار | القيمة | مكان الاستخدام |
|---------|--------|------------------|
| **نصف قطر الحواف (الشكل الموحد)** | `kShapeRadius = 24` (24dp) | كل البطاقات (`Card.filled`)، الأزرار، الحقول، الحاويات الدائرية (أيقونات، شرائط التقدم الدائرية) |
| **شكل البطاقة** | `RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius))` | مكرر في: المحراب، أثري، الأذكار، المجلس، زاد، شهر الصلاة، القبلة، المصحف (حسب السياق) |
| **Material 3** | `useMaterial3: true` في `AppTheme` | الثيم العام؛ شاشة المصحف تستخدم `useMaterial3: false` مؤقتاً لتوافق مكتبة المصحف |
| **البطاقات** | `Card.filled` | جميع البطاقات الرئيسية (مواعيد الصلاة، التحدي، المهام، الأذكار، الطلبات، المقولة، الصندوق الجامع، إلخ) |
| **الأيقونات** | نمط Rounded من Material Icons | `Icons.*_rounded` في كل الواجهات (مثل: `mosque_rounded`, `favorite_rounded`, `wb_sunny_rounded`, `lightbulb_rounded`, `savings_rounded`, `history_rounded`, `share_rounded`, `check_circle_rounded`) |

---

### 1.3 الخطوط ونظام الترجمة (Localization)

| العنصر | التفاصيل |
|--------|----------|
| **الخطوط (Google Fonts)** | عربي: **Tajawal** (`GoogleFonts.tajawalTextTheme`) — إنجليزي: **Plus Jakarta Sans** (`GoogleFonts.plusJakartaSansTextTheme`) |
| **مصدر النصوص** | `AppLocalizations.of(context)` أو **`useL10n()`** داخل `HookWidget` لضمان إعادة البناء عند تغيير اللغة |
| **اللغات المدعومة** | `ar`, `en` — `AppLocalizations.supportedLocales` |
| **الملفات** | `lib/l10n/app_ar.arb`, `lib/l10n/app_en.arb` — المخرجات في `lib/generated/l10n/` |
| **الأرقام حسب اللغة** | `LocaleDigits.format()` وامتداد `String.toLocaleDigits(Locale)` — أرقام عربية (٠–٩) عند `locale.languageCode == 'ar'` |
| **تنسيق الوقت** | `TimeFormat.formatTimeOfDay()` مع `MaterialLocalizations` و `alwaysUse24HourFormat` |

---

## 2. هيكلية الواجهات (Screen Breakdown)

### 2.1 الشاشة الرئيسية (MainScreen)

- **النوع:** `HookWidget`
- **المحتوى:** `Scaffold` + `AppBar` (عنوان التاب + زر اللغة) + `Stack`:
  - الطبقة السفلية: `IndexedStack` (أربعة تابات).
  - الطبقة العليا: **`LuminousFloatingBox`** (صندوق القطع النورانية الطافي).
- **التابات الأربعة:** المحراب، أثري، المجلس، زاد (عناوين وأيقونات من l10n).

---

### 2.2 تاب المحراب (MihrabTab)

- **النوع:** `HookWidget`
- **الخلفية:** تدرج Teal (`AppGradients.gradientFor`).
- **المكونات (من الأعلى للأسفل):**
  1. **عد تنازلي للصلاة القادمة** (`_NextPrayerCountdown` — HookWidget): Timer، تسمية الصلاة، وقت الوصول، زر «الشهر بالكامل».
  2. **بطاقة مواعيد الصلاة** (`_PrayerTimesCard`): جدول اليوم، تنسيق 12/24 ساعة، أرقام محلية.
  3. **الصندوق الجامع** (`_MasterTreasuryCard` — HookWidget): أيقونة توفير، عنوان «الصندوق الجامع»، إجمالي القطع النورانية (من `LuminousService.watchTotal()`).
  4. **شريط أذكار اليوم** (`_TodaysDhikrProgressBar` — HookWidget): عنوان «أذكار اليوم»، نسبة مكتمل/5 فئات، `LinearProgressIndicator`.
  5. **صف الوصول السريع** (`_QuickAccessRow`): ثلاث رقائق:
     - مصحف → `MushafLoadingScreen` ثم `MushafScreen`
     - أذكار → `DhikrScreen`
     - قبلة → `QiblaScreen`

---

### 2.3 تاب أثري (AthariTab)

- **النوع:** `HookWidget`
- **الخلفية:** تدرج Teal.
- **المكونات:**
  1. **شعار «أنا مسلم بأفعالي»** (`_AthariHeader`): بطاقة بعنوان كبير.
  2. **تنبيه الضيف** (`_GuestSyncBanner`): يظهر للضيف فقط (حسب `AuthProvider`).
  3. **تحدي اليوم** (`_TodayChallengeCard` — HookWidget): نص التحدي من Isar (أو من Supabase يومياً)، زر «تم».
  4. **شريط التقدم الأسبوعي** (`_ProgressBar`): `LinearProgressIndicator` حسب مهام اليوم المكتملة.
  5. **نص «في أسبوع، قمت بـ X فعل خير»** مع أرقام محلية.
  6. **صف القطع النورانية** (`_LuminousPiecesRow`): أيقونة مصباح + العدد (من `LuminousService.watchTotal()`).
  7. **عنوان «مهامي اليومية»** + قائمة المهام (`_DailyTasksSliver`): `CheckboxListTile` لكل مهمة (من Isar).

---

### 2.4 تاب المجلس (MajlisTab)

- **النوع:** `HookWidget`
- **الخلفية:** تدرج Teal.
- **المكونات:**
  1. عنوان «المجلس».
  2. **بطاقة ادعُ لي** (`_PrayForMeIntro`): نص تعريفي، زر «اطلب الدعاء».
  3. **قائمة طلبات الدعاء** (`_PrayerRequestsSliver` / `_PrayerRequestCard`): من Supabase، زر «دعوت لك».
  4. **قسم التحديات الجماعية** (`_GroupChallengesSection`): بطاقات «قراءة جماعية»، «تحدي الأذكار» (روابط/عناصر واجهة).

---

### 2.5 تاب زاد (ZadTab)

- **النوع:** `HookWidget`
- **الخلفية:** تدرج Teal.
- **المكونات:**
  1. **مقولة اليوم** (`_DailyQuoteCard`): نص المقولة، زر مشاركة (أسلوب Daily Wisdom).
  2. **قائمة المقاطع القصيرة** (`_ShortClipsReels` / `_ClipReelTile`): تمرير رأسي (Reels-style).

---

### 2.6 الشاشات الفرعية

| الشاشة | النوع | المحتوى الرئيسي |
|--------|--------|------------------|
| **DhikrScreen** | HookWidget | قائمة 5 فئات أذكار (Card.filled لكل فئة)، أيقونات مختلفة لكل فئة، انتقال إلى `DhikrCategoryScreen`. |
| **DhikrCategoryScreen** | HookWidget | قائمة أذكار تفاعلية، عداد لكل ذكر، هزّة + كرة نورانية + إضافة قطعة عند الضغط، زر مشاركة، زر **التاريخ** في الـ AppBar، رسالة توبة عند إكمال 100 استغفار. |
| **MushafLoadingScreen** | StatefulWidget | شاشة تحميل خفيفة («جاري تحميل المصحف…») ثم استبدال بـ `MushafScreen`. |
| **MushafScreen** | StatelessWidget | غلاف لـ `QuranLibraryScreen` (مكتبة خارجية) مع AppBar مخصص (رجوع + عنوان «مصحف»). |
| **QiblaScreen** | HookWidget | محتوى بوصلة/اتجاه القبلة، رسائل صلاحيات/أخطاء، وردجت بوصلة. |
| **PrayerMonthScreen** | StatefulWidget | جدول شهر كامل لمواعيد الصلاة، بطاقات أيام. |
| **SplashLandingScreen** | HookWidget | شاشة ترحيب، زر «ابدأ رحلتي». |
| **AuthChoiceScreen** | HookWidget | خيارات تسجيل الدخول (جوجل، متابعة كضيف). |

### 2.7 واجهة التاريخ (History View)

- **الموقع:** تُفتح من **DhikrCategoryScreen** عبر زر «التاريخ» في الـ AppBar.
- **الشكل:** `showModalBottomSheet` مع `FutureBuilder` على `getCategoryHistory(isar, categoryId, days: 14)`.
- **المحتوى:** قائمة بأيام (تاريخ + أيقونة ✓ مكتمل / ○ غير مكتمل) حسب سجل `DhikrDayProgress` لهذه الفئة.

---

## 3. المكونات المشتركة (Reusable Widgets)

| المكون | الملف | إعادة الاستخدام المقترحة |
|--------|--------|---------------------------|
| **LuminousFloatingBox** | `lib/widgets/luminous_floating_box.dart` | مستخدم في `MainScreen` فقط حاليًا — جاهز لإعادة الاستخدام في أي هيكل مشابه. |
| **شريط تقدم خطي** | مكرر: `_ProgressBar` (أثري)، `_TodaysDhikrProgressBar` (محراب) | يمكن استخراج `AppLinearProgressBar(value, label?, showFraction?)` في `lib/widgets/`. |
| **بطاقة بعنوان + أيقونة + قيمة** | أنماط: `_MasterTreasuryCard`, `_LuminousPiecesRow`, رأس أثري | يمكن توحيدها في `AppStatCard(title, value, icon, {subtitle})`. |
| **Card.filled + kShapeRadius** | مكرر في كل التابات | معيار ثابت عبر الثيم؛ لا حاجة لويدجت إضافي إلا للأنماط الخاصة (مثل «بطاقة نورانية» موحدة). |
| **رقاقة وصول سريع** | `_QuickAccessChip` | قابلة للنقل إلى `lib/widgets/quick_access_chip.dart` لاستخدامها في أماكن أخرى. |
| **زر مشاركة (أسلوب Daily Wisdom)** | في زاد وضمن `_DhikrItemCard` | يمكن استخراج `ShareQuoteButton(quote, subject)` في `lib/widgets/`. |

---

## 4. المعمارية البرمجية (Technical Stack)

### 4.1 HookWidget و Builders

- **الشاشات/التابات التي تستخدم HookWidget:**  
  `MainScreen`, `MihrabTab`, `AthariTab`, `MajlisTab`, `ZadTab`, `DhikrScreen`, `DhikrCategoryScreen`, `QiblaScreen`, `SplashLandingScreen`, `AuthChoiceScreen`، وكذلك مكونات داخلية مثل `_NextPrayerCountdown`, `_TodayChallengeCard`, `_MasterTreasuryCard`, `_TodaysDhikrProgressBar`, `LuminousFloatingBox`, `_PrayForMeIntro`, `_ShortClipsReels`, `_GroupChallengesSection`, `_CompassContent`.
- **الاستخدام النموذجي:**
  - `useL10n()` للنصوص المترجمة.
  - `useIsar()` حيث يُوفَّر `Isar` عبر `Provider`.
  - `useState` للحالة المحلية (عدادات، قوائم، أعلام).
  - `useMemoized` + `useFuture` أو `useStream` للبيانات غير التزامنية (مثلاً `LuminousService.watchTotal()`, `getTodayDhikrSummary(isar)`).
  - `useAnimationController` لتأثيرات مثل الكرة النورانية والنبض.
  - `useEffect` للاشتراكات والتنظيف (مثل المستمعين على الـ AnimationController).
- **Builders:** استخدام `FutureBuilder` (مثل المحراب لمواعيد الصلاة، واجهة التاريخ)، و`StreamBuilder` ضمني عبر `useStream` في الهوكات.

### 4.2 نماذج البيانات (Isar)

| النموذج | الغرض |
|---------|--------|
| **DailyTask** | مهام يومية (صلوات، ابتسامة، امتنان، + مهام من الأذكار عند الإكمال). |
| **ActionOfTheDayEntry** | تحدي اليوم (تاريخ، عنوان عربي/إنجليزي، حالة إنجاز، وقت الإنجاز). |
| **PrayerRequest** | طلبات الدعاء (للمجلس — قد يُربط مع Supabase). |
| **LastReadEntry** | آخر قراءة (مصحف). |
| **BookmarkEntry** | إشارات مرجعية (مصحف). |
| **PrayerDayCache** | تخزين مؤقت لمواعيد يوم واحد. |
| **PrayerMonthCache** | تخزين مؤقت لمواعيد الشهر. |
| **LuminousWallet** | إجمالي القطع النورانية (سجل واحد: totalPieces, updatedAt). |
| **DhikrDayProgress** | تقدم الأذكار حسب اليوم (dateKey, categoryId, countsJson, updatedAt). |

### 4.3 جداول Supabase المرتبطة

| الجدول | الغرض |
|--------|--------|
| **daily_challenges** | تحديات يومية (challenge_text_ar/en, luminous_value) — يُختار تحدي واحد حسب تاريخ اليوم ويُخزَّن في Isar كـ ActionOfTheDayEntry. |
| **dhikr_categories** | فئات أذكار (name_ar/en, icon_name, color_hex) — معرّفة في SQL؛ البيانات الفعلية للأذكار حالياً من `assets/data/adhkar.json`. |
| **طلبات الدعاء** | يستخدمها المجلس (عبر `PrayerRequestsService`) — الجدول الفعلي حسب إعداد المشروع. |

---

## 5. نظام التفاعل — القطع النورانية (Interaction System)

1. **المصدر:** في **DhikrCategoryScreen** عند الضغط على عداد ذكر: `LuminousService.addPieces(1)`.
2. **التأثيرات الفورية:** هزّة خفيفة (`HapticFeedback.lightImpact()`)، إطلاق كرة نورانية متحركة للأعلى (AnimationController)، زيادة `LuminousService.pulseTrigger.value++`.
3. **التخزين:** `addPieces` يحدّث (أو ينشئ) سجل **LuminousWallet** في Isar (totalPieces, updatedAt) — يعمل دون اتصال.
4. **الانتشار في الواجهة:**
   - **LuminousFloatingBox** (في MainScreen): يشترك في `LuminousService.watchTotal()` ويعرض الإجمالي؛ عند تغيّر `pulseTrigger` يشغّل تأثير نبض (توهج + scale).
   - **الصندوق الجامع** (في المحراب): يستخدم نفس `watchTotal()` لعرض الإجمالي في بطاقة «الصندوق الجامع».
   - **تاب أثري:** يعرض نفس الإجمالي في صف «القطع النورانية».
5. **ربط بأثري:** عند انتهاء عداد ذكر (وصوله إلى 0) يُضاف «فعل خير» كـ **DailyTask** مكتمل في Isar فيظهر في شريط التقدم الأسبوعي وعداد «X فعل خير».

---

## 6. التوصيات (Redundancy Check)

| الملاحظة | التوصية |
|----------|----------|
| **عرض القطع النورانية في مكانين** (صندوق طافي + صندوق جامع + صف أثري) | مقبول للتنوع السياقي؛ يمكن توحيد **مصدر القيمة** فقط (مثلاً Provider أو خدمة واحدة) — وهو متحقق عبر `LuminousService.watchTotal()`. |
| **نمط Card.filled + kShapeRadius مكرر نصّاً** | الإبقاء على الثيم الموحد؛ اختياري: استخراج ويدجت `AppCard` يغلف `Card.filled` مع `shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kShapeRadius))` لتقليل التكرار. |
| **شريطا تقدم خطيان** (_ProgressBar و _TodaysDhikrProgressBar) | دمج في مكون واحد قابل لإعادة الاستخدام: مثلاً `AppProgressCard(title?, value, total?, showFraction: true/false)` مع `LinearProgressIndicator` واختيار تسمية. |
| **بطاقة «قيمة عددية + أيقونة + عنوان»** (صندوق جامع، صف القطع النورانية، رأس أثري) | دمج في `AppStatCard` أو `AppMetricCard` في `lib/widgets/` مع خصائص (title, value, icon, optional subtitle). |
| **زر المشاركة بنفس الأسلوب** (زاد، عنصر الذكر) | استخراج `ShareQuoteButton(text, subject)` أو استخدام مساعد `ShareService.shareQuote(text, subject)` مع ويدجت زر موحد. |
| **تحدي اليوم** (مصدران: Supabase و seed محلي) | منطق الدمج موجود في `getOrCreateDailyChallengeFromSupabase` و `runAllSeeds` — لا تكرار؛ التأكد فقط من توثيق سيناريو عدم الاتصال. |
| **تنسيق التاريخ في واجهة التاريخ** | استخدام `DateFormat` أو دالة مشتركة `formatDateKey(int dateKey)` في مكان واحد (مثلاً في `dhikr_progress_service` أو util) لضمان اتساق العرض. |
| **MushafScreen و MushafLoadingScreen** | الإبقاء على فصل الشاشة الخفيفة عن شاشة المصحف الثقيلة لتحسين الإحساس بالأداء؛ لا دمج. |

---

## ملخص تنفيذي

- **النظام البصري:** موحّد حول Teal (تدرج نهاري/ليلي)، `kShapeRadius = 24`، Material 3، وأيقونات Rounded.
- **الواجهات:** أربعة تابات رئيسية (المحراب، أثري، المجلس، زاد) مع شاشات فرعية واضحة (أذكار بفئات وتاريخ، مصحف، قبلة، شهر صلاة، ترحيب، دخول).
- **المكونات القابلة لإعادة الاستخدام:** الصندوق الطافي جاهز؛ يمكن استخراج شريط تقدم موحد، بطاقة إحصائية موحدة، وزر مشاركة موحد لتبسيط الصيانة.
- **المعمارية:** هيمنة HookWidget مع useL10n/useIsar و useFuture/useStream؛ تخزين محلي Isar غني؛ ربط محدود بـ Supabase (تحدي اليوم، طلبات الدعاء، وجداول القطع النورانية/الفئات).
- **القطع النورانية:** مسار واضح من الضغط في الأذكار → Isar + Pulse → عرض في الصندوق الطافي والصندوق الجامع وأثري، مع ربط تلقائي بـ «أفعال خير» عند إكمال ذكر.

يمكن استخدام هذا الملف كأساس لخريطة ذهنية للمشروع ولتخطيط مرحلة توحيد المكونات والتقليل من التكرار.
