@echo off
cd /d "%~dp0packages\app"
flutter run -d chrome --web-hostname=localhost --web-port=7357
