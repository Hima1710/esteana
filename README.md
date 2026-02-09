# استعانة (Istiana)

تطبيق المسلم اليومي: المحراب، الأذكار، المصحف، أثري، المجلس، زاد.

---

## سياسة الخصوصية / Privacy Policy

**لجوجل بلاي (رابط ثابت):**  
https://github.com/Hima1710/esteana/blob/main/PRIVACY_POLICY.md

---

## Data Layer
- **Models:** `lib/models/` — QuranAya (القرآن)، DailyTask (المهام اليومية).
- **Isar:** `IsarService` يهيّئ القاعدة عند التشغيل؛ `loadQuranFromAssets()` لتحميل القرآن من assets.
- **Hook:** `useIsar()` داخل HookWidget للحصول على Isar.
- بعد تغيير الموديلات: `./scripts/generate_isar.sh` أو `dart run build_runner build --delete-conflicting-outputs`.

---

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
