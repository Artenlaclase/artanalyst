# Script auxiliar para ejecutar ArtAnalyst Flutter Web desde la raíz del monorepo
Set-Location -Path "$PSScriptRoot/packages/app"
flutter run -d chrome --web-hostname=localhost --web-port=7357
