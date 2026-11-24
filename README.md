# To-Do List Firestore (Praktikum 3)

**Nama:** Andang Purwanto  
**NIM:** 2300016104  
**Program Studi:** Sistem Informasi  
**Nama Aplikasi:** `todo_app` (`com.example.todo_app`)  

## Tautan Pengumpulan
- **Kode sumber lengkap tersedia pada repository GitHub:** https://github.com/andangpurwwa/P3-PemMob_2300016104_AndangPurwanto
- **Video demo aplikasi tersedia pada Google Drive:** https://drive.google.com/drive/folders/1L2nGQeCZ6dZWfOMlPcBGVKupgg8r4am9?usp=sharing

Aplikasi Flutter To-Do List dengan Cloud Firestore, login Email/Password,
tugas per pengguna, edit judul, dan tampilan tanggal.

## Fitur
- Daftar akun dan login (Firebase Authentication, Email/Password)
- Tugas tersimpan di `users/{uid}/tasks`, tiap pengguna hanya melihat miliknya
- Tambah, centang, ubah judul, hapus (dengan konfirmasi)
- Daftar real-time dengan `StreamBuilder`
- Tanggal dari `serverTimestamp`, tema Material 3

## Cara menjalankan
1. `flutter pub add firebase_core cloud_firestore firebase_auth intl`
2. Salin folder `lib/` dari repo ini ke proyek Anda.
3. `flutterfire configure` (membuat `lib/firebase_options.dart`).
4. `flutter run`

> `firebase_options.dart` dan `google-services.json` dibuat dengan konfigurasi
> Firebase Anda sendiri. Jangan menaruh kata sandi akun di repository.

## Struktur
```
lib/
|- main.dart
|- firebase_options.dart   (otomatis dari flutterfire)
|- models/task.dart
|- services/auth_service.dart
|- services/firestore_service.dart
|- pages/auth_gate.dart, login_page.dart, register_page.dart,
|        home_page.dart, add_task_page.dart
`- widgets/edit_title_dialog.dart
```

## Langkah manual (wajib dilakukan sendiri)
1. Firebase Console -> Authentication -> Sign-in method -> aktifkan Email/Password.
2. Firestore Database -> tab Rules -> tempel isi `firestore.rules` -> Publish.
3. Jika error minSdk: `android/app/build.gradle.kts` -> `minSdk = 24`.

## Checklist pengujian
- [ ] Daftar akun baru berhasil dan langsung masuk ke daftar tugas
- [ ] Daftar dengan email yang sama -> muncul pesan "Email sudah terdaftar"
- [ ] Login salah password -> pesan error Bahasa Indonesia
- [ ] Tambah, centang (teks tercoret), ubah judul, hapus (ada konfirmasi)
- [ ] Logout lalu login dengan akun ke-2 -> daftar tugas berbeda
- [ ] Firebase Console: data ada di `users/{uid}/tasks`
- [ ] Ubah `isDone` di Console -> aplikasi ikut berubah tanpa refresh
- [ ] Rules Playground: baca `users/UID_LAIN/tasks/x` sebagai UID lain -> ditolak

## Troubleshooting
| Gejala | Penyebab | Solusi |
|---|---|---|
| `flutterfire` tidak dikenali | Pub Cache belum di PATH | Tambahkan `%LOCALAPPDATA%\Pub\Cache\bin` (Windows) atau `$HOME/.pub-cache/bin` |
| Error minSdk saat build | Firebase butuh minSdk 24 | `minSdk = 24` di `android/app/build.gradle.kts` |
| `PERMISSION_DENIED` | Rules belum diganti, belum login, atau path bukan `users/{uid}/...` | Publish rules, pastikan sudah login |
| `operation-not-allowed` | Email/Password belum diaktifkan | Aktifkan di Authentication |
| Loading terus | Database belum dibuat / tidak ada internet | Cek Firestore dan koneksi |
| `LocaleDataException` tanggal | `initializeDateFormatting` belum dipanggil | Pastikan ada di `main()` |
| Tombol Simpan lama saat offline | `add()` menunggu konfirmasi server | Sambungkan internet |
