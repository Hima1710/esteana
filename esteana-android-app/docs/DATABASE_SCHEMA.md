# توافق تطبيق إستعانة مع قاعدة البيانات (Supabase)

هذا الملف يوضح الجداول والأعمدة والقيم المستخدمة في الداتابيز حتى يعمل التطبيق والـ API بشكل متوافق.

---

## الجداول في Schema `public`

### 1. جدول `islamic_content`

جدول المحتوى الإسلامي (أذكار، حديث، قرآن، سنن، إلخ).

| العمود | النوع | الافتراضي | الوصف |
|--------|--------|-----------|--------|
| `id` | integer | nextval(...) | المفتاح الأساسي |
| `content_type` | text | - | نوع المحتوى |
| `title` | text | nullable | العنوان |
| `content` | text | - | النص |
| `reference` | text | nullable | المرجع |
| `target_gender` | text | 'both' | الجنس المستهدف |
| `marital_status` | text | 'both' | الحالة الاجتماعية |
| `age_group` | text | 'both' | **الفئة العمرية** |
| `target_occupation` | text | 'any' | **الوظيفة المستهدفة** |
| `target_mood` | text | 'any' | المزاج |
| `target_weather` | text | 'any' | الطقس |
| `tag_time` | text | 'any' | وقت الوسم |
| `created_at` | timestamptz | CURRENT_TIMESTAMP | وقت الإنشاء |
| `trigger_type` | text | 'any' | **نوع المحفز (وقت الإشعار)** |

### 2. جدول `device_tokens`

يخزن FCM tokens وإعدادات الإشعارات لكل جهاز.

| العمود | النوع | الوصف |
|--------|--------|--------|
| `id` | bigint/uuid | مفتاح أساسي |
| `fcm_token` | text | **UNIQUE** — توكن FCM من التطبيق |
| `created_at` | timestamptz | وقت أول إدراج |
| `updated_at` | timestamptz | وقت آخر تحديث |
| `notifications_enabled` | boolean | تفعيل الإشعارات من التطبيق (افتراضي true) |
| `frequency_hours` | int | تردد الإشعارات: 1 أو 3 أو 6 ساعات (افتراضي 3) |
| `last_notification_sent` | timestamptz | آخر وقت أُرسل فيه إشعار لهذا الجهاز |
| `timezone_offset` | int | فرق التوقيت عن UTC (مثلاً 2 لمصر) للوضع الليلي |

**Edge Function `save-fcm-token`:** تقبل POST بـ `fcm_token` وإختيارياً `notifications_enabled`, `frequency_hours`, `timezone_offset` وتنفّذ upsert. التطبيق يرسل هذه القيم عند «حفظ وإرسال الإعدادات للـ API».

---

## القيم المميزة المستخدمة في الداتابيز

يجب أن يرسل التطبيق (أو الـ API) قيماً متوافقة مع هذه القيم عند الاستعلام عن المحتوى أو حفظ التفضيلات.

### `age_group` (الفئة العمرية)

| القيمة | الاستخدام في التطبيق |
|--------|------------------------|
| `child` | عمر 0–12 |
| `adult` | عمر 18+ |
| `both` | عمر 13–17 (أو محتوى لجميع الأعمار) |
| `all` | محتوى يعرض للجميع بغض النظر عن العمر |

**المطابقة من العمر (Int):**  
- `age <= 12` → `age_group = 'child'`  
- `age >= 13 && age <= 17` → `age_group = 'both'`  
- `age >= 18` → `age_group = 'adult'`  
- أو استخدام `'all'` لعدم التصفية حسب العمر.

### `target_occupation` (الوظيفة)

| القيمة في DB | الخيار في التطبيق |
|--------------|-------------------|
| `any` | طالب، رب منزل، معلم، آخر |
| `worker` | موظف |
| `programmer` | مبرمج |
| `designer` | مصمم |

### `trigger_type` (نوع المحفز / وقت الإشعار)

| القيمة | الوصف |
|--------|--------|
| `any` | أي وقت |
| `wakeup` | استيقاظ (مناسب للوضع الليلي 5–11) |
| `sleep` | نوم (أذكار النوم) |
| `near_prayer` | قرب الصلاة |
| `rain` | عند المطر |

**وضع الصامت الليلي (11 مساءً–5 صباحاً):**  
يفضل إرسال إشعارات فقط للمحفزات `wakeup` و `sleep` في هذه الفترة، والباقي خارجها (الـ API يتعامل مع هذا الجزء).

---

## دوال في Schema `public`

- لا توجد حالياً دوال مخصصة (custom functions) في schema `public`.  
- الدوال الموجودة في schema `extensions` تابعة لإضافات Postgres (مثل uuid، pgcrypto) وليست خاصة بتطبيق إستعانة.

---

## ما يرسله التطبيق للـ API (Edge Function get-noor-data)

الطلب المرسل من التطبيق (POST إلى `get-noor-data`) يحتوي على:

| المعامل | النوع | الوصف |
|---------|--------|--------|
| `lat` | Double | خط العرض (أو افتراضي القاهرة 30.04) |
| `lon` | Double | خط الطول (أو افتراضي 31.23) |
| `age` | Int | العمر محسوباً من تاريخ الميلاد |
| `age_group` | String | `child`, `adult`, `both`, `all` (مطابق لـ islamic_content.age_group) |
| `job` | String | القيمة المختارة (للعرض) |
| `target_occupation` | String | `any`, `worker`, `programmer`, `designer` (مطابق لـ islamic_content.target_occupation) |
| `gender` | String | `male`, `female`, `both` (مطابق لـ islamic_content.target_gender) |
| `time` | String | ساعة الجهاز (ISO time) لوضع الصامت الليلي |

**ربط الـ API وحفظ FCM token في الداتابيز:**  
ضع في ملف `local.properties` (بجانب `sdk.dir`) القيم التالية ثم أعد بناء التطبيق:

```properties
# رابط Edge Functions لمشروعك من Supabase Dashboard → Project Settings → API
SUPABASE_FUNCTIONS_URL=https://<project-ref>.supabase.co/functions/v1/
# المفتاح العام (anon key) من نفس الصفحة
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

بدون هاتين القيمتين لن يُرسل التطبيق الإعدادات للـ API ولن يُحفظ FCM token في جدول `device_tokens`. في Logcat ستظهر رسالة تحذيرية عند جلب الـ token إذا لم تُضبط القيم.

**قاعدة الأربعين (في Edge Function):** من تجاوز 40 يُفضّل محتوى الحكمة والاستغفار (advice, dhikr)، ودون ذلك السنن والبناء (sunnah, hadith).

**الرد:** يتضمن `content` (المحتوى الإيماني والمرجع)، و`timings` (توقيتات الصلاة)، و`hijri_date`.

---

## Edge Function: send-notification (إرسال الإشعارات)

الدالة `send-notification` تقوم بـ:

1. جلب **آخر fcm_token** من جدول `device_tokens` (حسب `updated_at`).
2. جلب **محتوى عشوائي** من جدول `islamic_content` (عنوان + نص).
3. استخدام **Firebase Admin (مفتاح Service Account)** للحصول على OAuth2 access token ثم إرسال إشعار FCM HTTP v1 إلى الجهاز (العنوان + المحتوى).

**تفعيل المفتاح (مهم):**

1. افتح Supabase Dashboard → مشروعك → **Edge Functions** → **Secrets**.
2. أضف سيكرت باسم: `FIREBASE_SERVICE_ACCOUNT_JSON`.
3. القيمة: **محتوى ملف الـ JSON بالكامل** (مثل `esteana-project-firebase-adminsdk-fbsvc-df95dc16ec.json`) — انسخ كل المحتوى من الملف والصقه كقيمة للسيكرت.

**استدعاء الدالة:**  
`POST https://<project-ref>.supabase.co/functions/v1/send-notification`  
(بدون body مطلوب — الدالة تجلب التوكن والمحتوى من الداتابيز بنفسها.)

**جدولة الإشعارات (Cron):**  
تم ضبط مهمة `pg_cron` باسم `esteana-send-notification` لاستدعاء الدالة **كل ساعة** (على رأس الساعة). الدالة نفسها تحترم تردد كل جهاز (1 أو 3 أو 6 ساعات) عبر عمود `last_notification_sent` و`frequency_hours` في `device_tokens`.

**ربط الإشعارات بإعدادات التطبيق:**  
- عمود `notifications_enabled`: إن كان `false` لا يُرسل إشعار للجهاز.  
- عمود `frequency_hours`: لا يُرسل إشعاراً إلا إذا مرّت هذه الساعات منذ `last_notification_sent`.  
- عمود `timezone_offset`: فرق التوقيت عن UTC (مثلاً 2 لمصر) لتحديد الوضع الليلي.  
- **الوضع الليلي (11م–5ص بتوقيت الجهاز):** في هذه الفترة يُختار محتوى من `trigger_type` = `sleep` أو `wakeup` فقط؛ وإلا يُختار أي محتوى.

**الأندرويد:** الإشعار يظهر في شريط الإشعارات (Notification Bar) حتى لو التطبيق في الخلفية؛ الدالة ترسل `notification` + `android.notification.channel_id: esteana_notifications` لاستخدام قناة إستعانة.
