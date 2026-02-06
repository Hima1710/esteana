# نسخة الويب المضمّنة (أوفلاين)

هذا المجلد يضم نسخة مبنيّة من تطبيق الويب (من `web/dist/`). الـ WebView يحمّلها أولاً حتى يعمل التطبيق **بدون إنترنت**.

لتحديث النسخة بعد تعديل الويب، من جذر المستودع:

```bash
./scripts/copy-web-to-android.sh
```

أو يدوياً:

```bash
cd web && npm run build
cp -r web/dist/* esteana-android-app/app/src/main/assets/web/
```
