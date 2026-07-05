#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

step() {
  echo "==> $*"
  "$@"
  echo "    OK"
}

if [[ -z "${CI:-}" ]]; then
  export PUB_HOSTED_URL="${PUB_HOSTED_URL:-https://pub.flutter-io.cn}"
  export FLUTTER_STORAGE_BASE_URL="${FLUTTER_STORAGE_BASE_URL:-https://storage.flutter-io.cn}"
fi

step flutter pub get
step flutter analyze
step flutter test

if [[ -z "${CI:-}" ]]; then
  step flutter build web
fi

echo 'verify: ALL PASSED'
