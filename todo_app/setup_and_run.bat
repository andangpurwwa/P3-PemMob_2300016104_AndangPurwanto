@echo off
title Setup Firebase dan Jalankan To-Do List
color 0A
cd /d "c:\Kuliah\Semester 7\Pemrogaman mobile\P3\P3_2300016104_AndangPurwanto\todo_app"
set PATH=%PATH%;%LOCALAPPDATA%\Pub\Cache\bin

echo ========================================================
echo       PRAKTIKUM 3 - TO-DO LIST CLOUD FIRESTORE
echo ========================================================
echo.
echo [1/3] Memeriksa Login Firebase...
echo Jika browser terbuka, silakan izinkan login akun Google Anda.
echo.
call firebase login

echo.
echo ========================================================
echo [2/3] Menghubungkan Flutter ke Firebase (flutterfire configure)
echo - Pilih project Firebase Anda dengan tombol PANAH dan ENTER
echo - Pilih platform (minimal android) dengan tombol SPASI lalu ENTER
echo ========================================================
echo.
call flutterfire configure

echo.
echo ========================================================
echo [3/3] Menjalankan Aplikasi Flutter (flutter run)...
echo ========================================================
echo.
call flutter run

pause
