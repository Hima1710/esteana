# إعداد Vercel مع GitHub (إستعانة)

عند ربط المستودع من GitHub، Vercel يبني من **جذر المستودع**. التطبيق موجود في مجلد **`web/`** لذلك يظهر 404 ما لم تُغيَّر الإعدادات.

## الخطوات في Vercel

1. ادخل إلى مشروعك في [vercel.com](https://vercel.com) → **Settings**.
2. من القائمة الجانبية: **General**.
3. في قسم **Root Directory**:
   - فعّل **Override** (أو Edit).
   - اكتب: **`web`**
   - احفظ (Save).
4. من تبويب **Deployments** اختر آخر نشر → **⋯** (ثلاث نقاط) → **Redeploy**.

بعد إعادة النشر، سيبني Vercel من مجلد `web/` ويستخدم `web/vercel.json` و `web/package.json` وستختفي رسالة 404.
