$Host.UI.RawUI.WindowTitle = "Praktikum 3 - Setup & Run To-Do List"
$env:Path += ";$env:LOCALAPPDATA\Pub\Cache\bin"
Set-Location "c:\Kuliah\Semester 7\Pemrogaman mobile\P3\P3_2300016104_AndangPurwanto\todo_app"

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "      PRAKTIKUM 3 - TO-DO LIST CLOUD FIRESTORE          " -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/3] Login Firebase..." -ForegroundColor Green
Write-Host "Browser akan terbuka, silakan izinkan login ke akun Google Anda." -ForegroundColor Gray
firebase login

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "[2/3] Konfigurasi Firebase (flutterfire configure)..." -ForegroundColor Green
Write-Host "- Gunakan panah atas/bawah & Enter untuk memilih project Firebase" -ForegroundColor Gray
Write-Host "- Gunakan spasi untuk memilih platform (Android), lalu Enter" -ForegroundColor Gray
Write-Host "========================================================" -ForegroundColor Cyan
flutterfire configure

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "[3/3] Menjalankan Aplikasi Flutter (flutter run)..." -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Cyan
flutter run
