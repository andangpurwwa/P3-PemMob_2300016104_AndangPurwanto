# Laporan Praktikum 3
## Pemrograman Mobile: Basis Data Cloud dengan Firestore (Aplikasi To-Do List)

**Nama:** Andang Purwanto  
**NIM:** 2300016104  
**Program Studi:** Sistem Informasi  
**Project Firebase ID:** `todo-p3-andang-16104`  
**Kode Sumber (GitHub):** [https://github.com/andangpurwwa/P3-PemMob_2300016104_AndangPurwanto](https://github.com/andangpurwwa/P3-PemMob_2300016104_AndangPurwanto)  
**Video Demo (Google Drive):** [https://drive.google.com/drive/folders/1L2nGQeCZ6dZWfOMlPcBGVKupgg8r4am9?usp=sharing](https://drive.google.com/drive/folders/1L2nGQeCZ6dZWfOMlPcBGVKupgg8r4am9?usp=sharing)

---

### 1. Judul dan Tujuan
- **Judul:** Basis Data Cloud dengan Firestore (Aplikasi To-Do List)
- **Tujuan Pembelajaran:**
  1. Memahami konsep penyimpanan data berbasis cloud dengan Cloud Firestore.
  2. Menghubungkan proyek Flutter dengan Firebase menggunakan FlutterFire CLI.
  3. Mengimplementasikan operasi CRUD (Create, Read, Update, Delete) secara real-time pada Firestore.
  4. Menampilkan data yang selalu sinkron dan terupdate menggunakan `StreamBuilder`.
  5. Mengamankan data antar-pengguna menggunakan Firebase Authentication dan Firestore Security Rules.

---

### 2. Deskripsi Aplikasi
Aplikasi yang dibangun adalah aplikasi pencatat tugas (**To-Do List**) berbasis mobile yang menyimpan seluruh datanya secara cloud di Google Cloud Firestore. Aplikasi ini dilengkapi dengan fitur-fitur berikut:
- **Autentikasi Pengguna (Firebase Auth):** Fitur Pendaftaran akun baru dan Login berbasis Email & Password dengan penanganan error validasi dalam Bahasa Indonesia.
- **Pemisahan Data Pengguna (Multi-User Isolation):** Tugas disimpan pada jalur `users/{uid}/tasks`, sehingga setiap pengguna hanya dapat melihat dan mengelola tugas miliknya sendiri.
- **Manajemen Tugas Real-Time:** Menambah tugas baru, menandai status selesai (checkbox dengan coretan teks), mengubah judul tugas (edit dialog), dan menghapus tugas dengan dialog konfirmasi.
- **Waktu Server (`serverTimestamp`):** Pencatatan waktu pembuatan tugas yang presisi dan diformat ke dalam Bahasa Indonesia (`id_ID`) menggunakan pustaka `intl`.

---

### 3. Penjelasan Kode Utama

#### a. `FirestoreService` (`lib/services/firestore_service.dart`)
Kelas ini mengisolasi seluruh query dan interaksi basis data Firestore:
- `_tasksRef`: Getter dinamis yang mengambil referensi koleksi tugas berdasarkan UID pengguna yang sedang login (`users/{uid}/tasks`).
- `addTask(String title)`: Menambahkan dokumen tugas baru dengan nilai awal `isDone: false` dan waktu server `FieldValue.serverTimestamp()`.
- `getTasks()`: Mengembalikan `Stream<List<Task>>` dengan urutan waktu menurun (`orderBy('timestamp', descending: true)`).
- `toggleDone(String id, bool value)`: Memperbarui status selesai tugas.
- `updateTitle(String id, String title)`: Memperbarui judul tugas yang sudah ada (Nilai Tambahan).
- `deleteTask(String id)`: Menghapus dokumen tugas berdasarkan ID dokumennya.

#### b. `StreamBuilder` (`lib/pages/home_page.dart`)
Widget ini mendengarkan aliran data (`stream`) dari `FirestoreService.getTasks()`. Setiap kali ada perubahan data pada server Firestore (baik dari aplikasi lokal maupun langsung dari Firebase Console), `StreamBuilder` secara otomatis me-rebuild UI secara real-time tanpa memerlukan reload halaman manual.

#### c. Alur Login & Autentikasi (`lib/pages/auth_gate.dart` & `lib/services/auth_service.dart`)
- `AuthGate` bertindak sebagai gerbang navigasi utama dengan mendengarkan `FirebaseAuth.instance.authStateChanges()`.
- Jika stream bernilai `null` (belum login), pengguna langsung diarahkan ke `LoginPage`.
- Jika stream berisi objek `User` (berhasil login), pengguna otomatis dialihkan ke `HomePage`.
- Saat tombol keluar di-klik, `FirebaseAuth.instance.signOut()` dipanggil, dan `AuthGate` secara reaktif memindahkan tampilan kembali ke `LoginPage`.

#### d. Aturan Keamanan (`firestore.rules`)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```
Aturan ini menjamin bahwa operasi baca dan tulis hanya diizinkan apabila pemohon telah terautentikasi (`request.auth != null`) dan UID akun pemohon sama persis dengan parameter `userId` pada jalur dokumen (`request.auth.uid == userId`). Pengguna lain tidak memiliki akses ke data tersebut.

---

### 4. Hasil Pengujian & Screenshot
*(Lampirkan tangkapan layar pengujian pada bagian ini)*:
1. **Screenshot Halaman Login & Registrasi Akun:**
   - Tampilan Form Login dan Pendaftaran akun baru.
2. **Screenshot Halaman Utama Tugas (HomePage):**
   - Tampilan daftar tugas, centang teks tercoret, dan format tanggal Bahasa Indonesia.
3. **Screenshot Edit Tugas & Hapus Tugas:**
   - Dialog ubah nama tugas dan konfirmasi penghapusan tugas.
4. **Screenshot Firebase Console:**
   - **Authentication:** Daftar user yang telah berhasil mendaftar.
   - **Firestore Database:** Struktur data `users/{userId}/tasks/{taskId}` beserta fields `title`, `isDone`, dan `timestamp`.

---

### 5. Link Repository GitHub & Video Demo
- **Kode sumber lengkap tersedia pada repository GitHub:**  
  [https://github.com/andangpurwwa/P3-PemMob_2300016104_AndangPurwanto](https://github.com/andangpurwwa/P3-PemMob_2300016104_AndangPurwanto)
- **Video demo aplikasi tersedia pada Google Drive:**  
  [https://drive.google.com/drive/folders/1L2nGQeCZ6dZWfOMlPcBGVKupgg8r4am9?usp=sharing](https://drive.google.com/drive/folders/1L2nGQeCZ6dZWfOMlPcBGVKupgg8r4am9?usp=sharing)

---

### 6. Kesimpulan
1. Cloud Firestore memberikan kemudahan sinkronisasi data real-time antarmuka pengguna Flutter berkat integrasi reactive stream (`StreamBuilder`).
2. Struktur penyimpanan hierarkis sub-koleksi (`users/{uid}/tasks`) yang dipadukan dengan Firebase Security Rules terbukti efektif dalam memisahkan dan mengamankan privasi data antar-pengguna.
3. FlutterFire CLI mempermudah integrasi lintas platform dengan menghasilkan konfigurasi `firebase_options.dart` secara otomatis dan aman.
