#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

step() { echo "==> $1"; shift; "$@"; echo "    OK"; }
export PUB_HOSTED_URL="${PUB_HOSTED_URL:-https://pub.flutter-io.cn}"
export FLUTTER_STORAGE_BASE_URL="${FLUTTER_STORAGE_BASE_URL:-https://storage.flutter-io.cn}"
step flutter pub get flutter pub get
step flutter analyze flutter analyze
step flutter test flutter test
step flutter build web flutter build web
echo 'verify: ALL PASSED'
