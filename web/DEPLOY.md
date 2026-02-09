# استضافة تطبيق الويب (إستعانة)

## سبب خطأ 404 NOT_FOUND

التطبيق موجود داخل مجلد **`web/`** وليس في جذر المستودع. إذا ربطت المستودع كاملاً دون تحديد المجلد الصحيح، لن تجد المنصة ملف `index.html` فتعيد **404**.

## الحل: تعيين مجلد الجذر (Root Directory)

عند ربط المستودع على المنصة، **يجب تعيين مجلد الجذر إلى `web`** وليس جذر المستودع.

### Vercel
1. Project Settings → General → **Root Directory** → اختر `web` أو اكتب `web`.
2. احفظ ثم أعد النشر (Redeploy).

### Netlify
1. Site settings → Build & deploy → Build settings.
2. **Base directory**: اكتب `web`.
3. **Build command**: `npm run build`.
4. **Publish directory**: `dist` (نسبةً لمجلد القاعدة `web`).

### Cloudflare Pages
1. عند إنشاء المشروع من Git اختر **Root directory** = `web`.
2. **Build command**: `npm run build`.
3. **Build output directory**: `dist`.

---

بعد تعيين المجلد وإعادة النشر، يجب أن يعمل الموقع بدون 404.
