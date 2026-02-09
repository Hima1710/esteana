-- جدول device_tokens لحفظ FCM tokens للأجهزة (لإرسال الإشعارات عبر send-notification)
create table if not exists public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  fcm_token text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint device_tokens_fcm_token_key unique (fcm_token)
);

comment on table public.device_tokens is 'FCM tokens للأجهزة؛ تُستدعى من Edge Function save-fcm-token وتُقرأ من send-notification';
