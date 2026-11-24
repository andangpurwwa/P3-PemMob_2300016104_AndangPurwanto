@echo off
title Menjalankan To-Do List Flutter
color 0B
cd /d "%~dp0todo_app"
echo ========================================================
echo        MENJALANKAN APLIKASI TO-DO LIST (CHROME)
echo ========================================================
echo.
flutter run -d chrome
pause
