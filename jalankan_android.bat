@echo off
title Menjalankan To-Do List di Android Emulator
color 0E
cd /d "%~dp0todo_app"
echo ========================================================
echo     MENJALANKAN APLIKASI DI ANDROID EMULATOR
echo ========================================================
echo.
flutter run -d Medium_Phone_API_37.0
pause
