# مرحلة أولى: أساس البيانات (Data Layer) — خطوة بخطوة

هدف "The Muslim Journey": تحويل القراءة إلى أفعال. هذا المستند يلخص ما تم تنفيذه في كل خطوة.

---

## الخطوة 1: قراءة ملفات JSON في assets وفهم هيكل البيانات

### ما في مجلد assets
- **quran.json** — مصفوفة من آيات القرآن (كل عنصر: `id`, `sura`, `aya`, `text`).
- **المهام اليومية** — لا يوجد حالياً ملف JSON للمهام؛ الموديل جاهز لاستقبال بيانات لاحقاً (من ملف أو من الواجهة).
- باقي الملفات: بيانات الحزمة والمفاتيح (مثل esteana_key.jks، pakage-name.txt، إلخ).

### هيكل quran.json
كل عنصر في المصفوفة:
```json
{
  "id": "1-1",
  "sura": 1,
  "aya": 1,
  "text": "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
}
```
- `id`: مفتاح مركّب (سورة-آية).
- `sura`: رقم السورة (1–114).
- `aya`: رقم الآية داخل السورة.
- `text`: نص الآية بالعربية.

---

## الخطوة 2: إنشاء Models احترافية

### موديل القرآن (للمحراب)
- **الملف:** `lib/models/quran_aya.dart`
- **الحقول:** `id` (Isar), `ayaKey`, `sura`, `aya`, `text`
- **من/إلى JSON:** `fromJson` و `toJson` مطابقان لـ `assets/quran.json`

### موديل المهام اليومية (أثري - يومي)
- **الملف:** `lib/models/daily_task.dart`
- **الحقول:** `id`, `title`, `description`, `completed`, `sortOrder`, `createdAt`, `updatedAt`, `externalId`
- **من/إلى JSON:** `fromJson` و `toJson` جاهزان لملف مثل `daily_tasks.json` أو للإدخال من الواجهة

### تصدير مركزي
- **الملف:** `lib/models/models.dart` — يعيد تصدير الموديلات.

---

## الخطوة 3: إعداد Isar

### Schemas (جداول التخزين)
- الموديلات مُعلّمة بـ `@collection`؛ الـ Schema تُولَّد تلقائياً في الملفات `*.g.dart` عبر:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- الملفات المُولَّدة: `lib/models/quran_aya.g.dart`, `lib/models/daily_task.g.dart`.

### Service لتهيئة Isar (مع flutter_hooks)
- **الملف:** `lib/services/isar_service.dart`
  - يفتح Isar مرة واحدة عند التشغيل.
  - يُستدعى من `main()` قبل `runApp()`.
- **الوصول من الواجهة:** استخدام **flutter_hooks** عبر:
  - **الملف:** `lib/hooks/use_isar.dart` — الدالة `useIsar()` تُستخدم داخل `HookWidget` للحصول على نسخة Isar.
  - توفير Isar في الشجرة عبر **Provider** في `main.dart`.

### تحميل القرآن من الـ assets
- **الملف:** `lib/services/quran_loader.dart` — الدالة `loadQuranFromAssets()` تحمّل `assets/quran.json` إلى Isar (مرة واحدة).

---

## الخطوة 4: تحديث pubspec.yaml

### المكتبات المضافة
- `flutter_hooks`
- `isar`
- `isar_flutter_libs` (من فورك لصلاح مشكلة namespace على Android)
- `path_provider`
- `supabase_flutter`
- `provider` (لتوفير Isar في الشجرة مع الـ hook)

### dev_dependencies
- `build_runner`, `isar_generator` (لتوليد ملفات Isar)

### تسجيل الـ assets
- تم تسجيل مجلد `assets/` في القسم `flutter: assets:`.

---

## ملخص الملفات

| الغرض              | الملف |
|--------------------|--------|
| موديل آية قرآنية   | `lib/models/quran_aya.dart` |
| موديل مهمة يومية  | `lib/models/daily_task.dart` |
| تصدير الموديلات    | `lib/models/models.dart` |
| تهيئة Isar         | `lib/services/isar_service.dart` |
| تحميل القرآن       | `lib/services/quran_loader.dart` |
| Hook لـ Isar       | `lib/hooks/use_isar.dart` |
| نقطة الدخول       | `lib/main.dart` (تهيئة + Provider) |

---

## بعد تعديل الموديلات

شغّل مولّد الكود مرة أخرى:
```bash
./scripts/generate_isar.sh
# أو
dart run build_runner build --delete-conflicting-outputs
```

لا تُبنى الواجهات (UI) في هذه المرحلة؛ الأساس البرمجي للبيانات جاهز للعمل.

---

## آخر التعديلات (شاشة قائمة القرآن + Isar 3.1)

### المشكلة
في Isar 3.1 لا تتوفر دوال التنفيذ (`findAll`, `watch`) على الأنواع الناتجة عن الاستعلامات مثل:
- `QueryBuilder<..., QWhere>`
- `QueryBuilder<..., QAfterWhere>`
- `QueryBuilder<..., QAfterFilterCondition>`
- `QueryBuilder<..., QAfterSortBy>`

لذلك استدعاءات مثل `isar.quranAyas.where().findAll()` أو `.filter()...findAll()` أو `.where().anyId().findAll()` كانت تسبب أخطاء compile.

### الحل المُطبَّق
1. **في `lib/services/quran_loader.dart`**
   - إضافة دالة **`loadQuranListFromAssets()`** التي تقرأ `assets/quran.json` وتُرجع `List<QuranAya>` دون استخدام Isar.
   - تحديث **`loadQuranFromAssets()`** لاستخدام هذه الدالة عند ملء Isar (التهيئة في `main` تبقى كما هي).

2. **في `lib/screens/quran_list_screen.dart`**
   - إزالة الاعتماد على استعلام Isar بالكامل.
   - استخدام **`loadQuranListFromAssets()`** داخل **`useMemoized`** ثم ترتيب القائمة حسب `(sura, aya)` وعرضها.
   - الشاشة لم تعد تحتاج **`useIsar()`**؛ البيانات تُحمّل من الـ assets مباشرة لضمان التوافق مع Isar 3.1.

### النتيجة
- شاشة المصحف (التي تفتح من أيقونة «المصحف» في المحراب) تعمل وتُظهر كل الآيات مرتبة حسب السورة والآية.
- تهيئة Isar عند أول تشغيل (ملء الجدول من الـ assets) ما زالت تعمل عبر **`loadQuranFromAssets()`** في **`main.dart`**.
