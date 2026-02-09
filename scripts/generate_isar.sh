#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/.."
[ -d /snap/flutter/current/bin ] && export PATH="/snap/flutter/current/bin:$PATH"
command -v flutter >/dev/null 2>&1 || { echo "ثبّت Flutter أولاً: sudo snap install flutter --classic"; exit 1; }
flutter pub get
dart run build_runner build --delete-conflicting-outputs
echo ">>> تم توليد ملفات Isar بنجاح."
