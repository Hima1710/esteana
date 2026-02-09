#!/usr/bin/env bash
# يبني تطبيق الويب وينسخه إلى أصول الأندرويد ليعمل التطبيق أوفلاين بالكامل.
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
WEB="$ROOT/web"
ASSETS="$ROOT/esteana-android-app/app/src/main/assets/web"

echo "بناء تطبيق الويب..."
(cd "$WEB" && npm install && npm run build)

echo "نسخ المخرجات إلى assets الأندرويد..."
mkdir -p "$ASSETS"
rm -rf "${ASSETS:?}"/*
cp -r "$WEB/dist"/* "$ASSETS/"

# إزالة crossorigin من سكربت التطبيق حتى يعمل التحميل من file:// في WebView
if [ -f "$ASSETS/index.html" ]; then
  sed -i 's/ crossorigin//g' "$ASSETS/index.html"
fi

echo "تم. مجلد assets/web جاهز للتطبيق الأوفلاين."
