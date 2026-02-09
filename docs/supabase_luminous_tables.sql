-- جداول نظام القطع النورانية — نفّذ في Supabase SQL Editor.

-- فئات الأذكار (الاسم، أيقونة اللوجو، اللون)
CREATE TABLE IF NOT EXISTS dhikr_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name_ar TEXT NOT NULL,
  name_en TEXT NOT NULL,
  icon_name TEXT,
  color_hex TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- تحديات يومية (نص التحدي، القيمة النورانية)
CREATE TABLE IF NOT EXISTS daily_challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  challenge_text_ar TEXT NOT NULL,
  challenge_text_en TEXT NOT NULL,
  luminous_value INT NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- تفعيل RLS (اختياري)
ALTER TABLE dhikr_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_challenges ENABLE ROW LEVEL SECURITY;

-- سياسة للقراءة العامة (anon)
CREATE POLICY "Allow read dhikr_categories" ON dhikr_categories FOR SELECT USING (true);
CREATE POLICY "Allow read daily_challenges" ON daily_challenges FOR SELECT USING (true);

-- بيانات تجريبية لتحديات اليوم
INSERT INTO daily_challenges (challenge_text_ar, challenge_text_en, luminous_value) VALUES
  ('ساعد والديك اليوم', 'Help your parents today', 5),
  ('اقرأ صفحة من المصحف', 'Read a page from the Quran', 10),
  ('ابتسم لعشرة أشخاص', 'Smile at ten people', 3),
  ('تصدّق ولو بقليل', 'Give charity, even a little', 7),
  ('اتصل بأحد أقاربك', 'Call a relative', 4),
  ('احمد الله على نعمة واحدة', 'Thank Allah for one blessing', 2)
ON CONFLICT DO NOTHING;
