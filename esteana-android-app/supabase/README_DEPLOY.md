# نشر جدول device_tokens ودالة save-fcm-token

## 1. ربط المشروع (مرة واحدة)

استبدل `YOUR_PROJECT_REF` بمعرّف مشروعك من لوحة Supabase (من الرابط: `https://supabase.com/dashboard/project/YOUR_PROJECT_REF`).

```bash
cd /home/zero/Desktop/إستعانة/esteana-android-app
supabase link --project-ref YOUR_PROJECT_REF
```

أدخل كلمة مرور قاعدة البيانات عندما يُطلب منك.

## 2. تطبيق الـ migration (إنشاء جدول device_tokens)

```bash
supabase db push
```

أو نفّذ الـ SQL يدوياً من **Supabase Dashboard → SQL Editor**:

```sql
create table if not exists public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  fcm_token text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint device_tokens_fcm_token_key unique (fcm_token)
);
```

## 3. نشر Edge Function save-fcm-token

```bash
supabase functions deploy save-fcm-token
```

## 4. ضبط التطبيق (local.properties)

من **Dashboard → Project Settings → API** انسخ:
- **Project URL** → أضف في النهاية: `/functions/v1/` وضعه في `SUPABASE_FUNCTIONS_URL`
- **anon public** → ضعه في `SUPABASE_ANON_KEY`

في ملف `local.properties`:

```
SUPABASE_FUNCTIONS_URL=https://YOUR_PROJECT_REF.supabase.co/functions/v1/
SUPABASE_ANON_KEY=eyJhbGci...
```

ثم أعد بناء التطبيق وشغّله؛ سيُحفظ FCM token في الداتابيز تلقائياً.
