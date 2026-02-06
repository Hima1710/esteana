-- جدول سجل الأفعال اليومية (للـ Offline-First والـ Sync مع الويب)
CREATE TABLE IF NOT EXISTS public.daily_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  action_type text NOT NULL,
  payload jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.daily_logs IS 'سجل أفعال المستخدم اليومية - يُملأ عبر Sync من التطبيق (Offline-First)';
