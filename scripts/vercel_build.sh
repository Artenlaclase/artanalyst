#!/bin/bash
set -e

echo "=== Descargando e instalando Flutter SDK en Vercel ==="
if [ ! -d "_flutter" ]; then
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git _flutter
fi

export PATH="$PATH:$(pwd)/_flutter/bin"

flutter --version

echo "=== Compilando ArtAnalyst para Web (Release) ==="
flutter pub get
flutter build web --release

echo "=== Compilación completada en build/web ==="
