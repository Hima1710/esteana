#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/.."
export ANDROID_HOME=/home/zero/Android/Sdk
export ANDROID_NDK_HOME=/home/zero/Android/Sdk/ndk/28.2.13676358
flutter run "$@"
