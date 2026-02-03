-- إعدادات الإشعارات لكل جهاز (مرتبطة بـ FCM token)
alter table public.device_tokens
  add column if not exists notifications_enabled boolean not null default true,
  add column if not exists frequency_hours int not null default 3,
  add column if not exists last_notification_sent timestamptz,
  add column if not exists timezone_offset int not null default 2;

comment on column public.device_tokens.notifications_enabled is 'تفعيل الإشعارات من التطبيق';
comment on column public.device_tokens.frequency_hours is 'تردد الإشعارات: 1 أو 3 أو 6 ساعات';
comment on column public.device_tokens.last_notification_sent is 'آخر وقت تم فيه إرسال إشعار لهذا الجهاز';
comment on column public.device_tokens.timezone_offset is 'فرق التوقيت عن UTC (مثلاً 2 لمصر)';
