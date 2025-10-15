#!/bin/bash
set -e

cd /app

flutter pub get
flutter build apk --release

echo "✅ APK gerado em: build/app/outputs/flutter-apk/app-release.apk"
