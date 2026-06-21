# LAPORAN TUGAS BESAR
# WORKSHOP PEMROGRAMAN PERANGKAT LUNAK (WPPL)

---

## COVER

**Nama Proyek:** SubsTrack – Aplikasi Manajemen Langganan Digital  
**Mata Kuliah:** Workshop Pemrograman Perangkat Lunak  
**Nama:** [NAMA ANDA]  
**NIM:** [NIM ANDA]  
**Kelas:** [KELAS ANDA]  
**Dosen:** [NAMA DOSEN]  
**Semester/Tahun:** Genap / 2025-2026  

---

## 1. DESKRIPSI PROTOTYPE

### 1.1 Latar Belakang
Di era digital, semakin banyak orang berlangganan layanan digital seperti streaming video, musik, produktivitas, dan cloud storage. Namun, banyak pengguna kesulitan melacak total pengeluaran bulanan dari berbagai langganan yang dimiliki. Hal ini sering menyebabkan pengeluaran yang tidak terkontrol.

### 1.2 Tujuan Aplikasi
SubsTrack adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengguna:
- Mencatat dan mengelola semua langganan digital dalam satu tempat
- Memantau total pengeluaran bulanan secara real-time
- Menganalisis distribusi pengeluaran per kategori layanan
- Mendapatkan estimasi pengeluaran tahunan

### 1.3 Fitur Utama
| No | Fitur | Deskripsi |
|----|-------|-----------|
| 1 | Tambah Langganan | Input nama, harga, kategori, tanggal bayar, catatan |
| 2 | Edit Langganan | Ubah data langganan yang sudah ada |
| 3 | Hapus Langganan | Hapus dengan konfirmasi dialog |
| 4 | Lihat Detail | Informasi lengkap + estimasi tahunan |
| 5 | Total Bulanan | Kalkulasi otomatis, update real-time |
| 6 | Filter Kategori | Filter list per kategori layanan |
| 7 | Statistik & Chart | Pie chart distribusi + ranking termahal |
| 8 | Validasi Form | Validasi semua input sebelum disimpan |
| 9 | Persistensi Data | Data tersimpan permanen via SharedPreferences |
| 10 | Snackbar Feedback | Notifikasi setelah setiap aksi berhasil |

### 1.4 Teknologi yang Digunakan
- **Framework:** Flutter 3.24.0 (Dart 3.5.0)
- **Platform:** Android
- **Packages:** shared_preferences, intl, uuid, fl_chart
- **IDE:** VS Code + Flutter Extension
- **Version Control:** Git + GitHub

---

## 2. PENJELASAN PROSES PPL BERBASIS AGILE

### 2.1 Metodologi
Proyek ini menggunakan metodologi **Agile Scrum** dengan 3 sprint, masing-masing berfokus pada increment yang dapat dideliverkan.

### 2.2 Product Backlog

| ID | User Story | Priority | Sprint |
|----|-----------|----------|--------|
| US-01 | Sebagai user, saya ingin mencatat langganan baru agar dapat terlacak | High | 1 |
| US-02 | Sebagai user, saya ingin melihat total pengeluaran bulanan | High | 1 |
| US-03 | Sebagai user, saya ingin data tersimpan setelah app ditutup | High | 1 |
| US-04 | Sebagai user, saya ingin mengedit data langganan yang salah | Medium | 2 |
| US-05 | Sebagai user, saya ingin menghapus langganan yang tidak aktif | Medium | 2 |
| US-06 | Sebagai user, saya ingin melihat detail lengkap setiap langganan | Medium | 2 |
| US-07 | Sebagai user, saya ingin form divalidasi agar tidak ada data kosong | Medium | 2 |
| US-08 | Sebagai user, saya ingin memfilter langganan per kategori | Low | 3 |
| US-09 | Sebagai user, saya ingin melihat grafik distribusi pengeluaran | Low | 3 |

### 2.3 Sprint 1 — Fondasi & Core Data (Minggu 1)
**Sprint Goal:** Aplikasi bisa menyimpan dan menampilkan data langganan

**Tasks:**
- [x] Inisialisasi project Flutter, konfigurasi pubspec.yaml
- [x] Implementasi model `Subscription` dengan JSON serialization
- [x] Implementasi `StorageService` menggunakan SharedPreferences
- [x] Implementasi `HomeScreen` dengan summary card total bulanan
- [x] Implementasi `EmptyState` widget

**Review:** User dapat melihat halaman utama, data tersimpan permanen. ✅

---

### 2.4 Sprint 2 — CRUD Lengkap & Validasi (Minggu 2)
**Sprint Goal:** User dapat tambah, edit, hapus, dan lihat detail langganan

**Tasks:**
- [x] Implementasi `AddEditScreen` dengan 8 kategori dan date picker
- [x] Validasi form: nama wajib, harga wajib & harus angka, tanggal wajib
- [x] Implementasi `DetailScreen` dengan estimasi tahunan
- [x] Implementasi `SubscriptionCard` dengan tombol edit/hapus
- [x] Dialog konfirmasi sebelum hapus
- [x] Snackbar feedback setelah setiap aksi

**Review:** Seluruh fitur CRUD berjalan, validasi mencegah data invalid. ✅

---

### 2.5 Sprint 3 — Statistik & Finalisasi (Minggu 3)
**Sprint Goal:** Tambah fitur analitik dan siapkan untuk distribusi

**Tasks:**
- [x] Implementasi `StatisticsScreen` dengan pie chart (fl_chart)
- [x] Filter kategori horizontal scroll di HomeScreen
- [x] Buat use case diagram
- [x] Flutter analyze — 0 issues
- [x] Build APK release
- [x] Dokumentasi dan laporan

**Review:** Aplikasi siap distribusi dengan fitur lengkap dan zero error. ✅

---

### 2.6 Retrospective
**What went well:**
- Arsitektur terpisah (model/service/screen/widget) memudahkan pengembangan
- SharedPreferences mudah diintegrasikan untuk persistensi
- fl_chart menyederhanakan implementasi grafik

**What to improve:**
- Notifikasi pengingat pembayaran bisa ditambahkan di iterasi berikutnya
- Multi-currency support untuk pengguna internasional

---

## 3. USE CASE DIAGRAM

*[Sisipkan file docs/usecase_diagram.svg di sini]*

### 3.1 Deskripsi Use Case

| Use Case | Aktor | Deskripsi |
|----------|-------|-----------|
| Melihat Daftar Langganan | User | Melihat semua langganan + total bulanan di halaman utama |
| Menambah Langganan | User | Mengisi form dan menyimpan langganan baru |
| Mengedit Langganan | User | Mengubah data langganan yang sudah ada |
| Menghapus Langganan | User | Menghapus langganan setelah konfirmasi |
| Melihat Detail Langganan | User | Melihat info lengkap + estimasi tahunan |
| Validasi Form Input | System | Memastikan semua input valid sebelum disimpan |
| Menyimpan Data Permanen | System | Menyimpan data ke SharedPreferences |
| Konfirmasi Penghapusan | System | Dialog konfirmasi sebelum data dihapus |

---

## 4. SCREENSHOT ANTARMUKA & SOURCE CODE

### 4.1 Screenshot Antarmuka

**Halaman 1: Empty State**
*[Screenshot halaman utama saat belum ada data]*

**Halaman 2: Form Tambah Langganan**
*[Screenshot form input dengan semua field]*

**Halaman 3: Validasi Form**
*[Screenshot pesan error validasi]*

**Halaman 4: Home — Daftar Langganan**
*[Screenshot home dengan beberapa langganan dan total]*

**Halaman 5: Filter Kategori**
*[Screenshot filter aktif, misalnya "Streaming"]*

**Halaman 6: Detail Langganan**
*[Screenshot detail dengan estimasi tahunan]*

**Halaman 7: Form Edit**
*[Screenshot form edit dengan data lama terisi]*

**Halaman 8: Dialog Hapus**
*[Screenshot dialog konfirmasi hapus]*

**Halaman 9: Snackbar Notifikasi**
*[Screenshot snackbar hijau setelah simpan]*

**Halaman 10: Statistik & Pie Chart**
*[Screenshot StatisticsScreen dengan chart dan ranking]*

### 4.2 Source Code Utama

*[Sisipkan screenshot atau listing code dari:]*
- `lib/models/subscription.dart`
- `lib/services/storage_service.dart`
- `lib/screens/home_screen.dart` (bagian utama)
- `lib/screens/add_edit_screen.dart` (bagian validasi)
- `lib/screens/statistics_screen.dart` (bagian chart)

---

## 5. LINK VIDEO DEMO

**Link YouTube / Google Drive:** [ISI LINK VIDEO DEMO DI SINI]

*Durasi: ±2 menit*
*Konten: Demo seluruh fitur aplikasi SubsTrack*

---

## 6. LINK APK

**Link APK (Google Drive / GitHub Releases):** [ISI LINK APK DI SINI]

**Informasi APK:**
- Versi: 1.0.0
- Target SDK: Android 5.0+ (API 21+)
- Ukuran: ±20-25 MB
- File: `app-release.apk`

**Cara Install:**
1. Download file APK dari link di atas
2. Aktifkan "Install dari sumber tidak dikenal" di pengaturan HP
3. Buka file APK dan install
4. Jalankan aplikasi SubsTrack

---

## 7. LAIN-LAIN

### 7.1 Struktur Project
```
subtrack/
├── lib/
│   ├── main.dart
│   ├── models/subscription.dart
│   ├── services/storage_service.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── add_edit_screen.dart
│   │   ├── detail_screen.dart
│   │   └── statistics_screen.dart
│   └── widgets/
│       ├── subscription_card.dart
│       └── empty_state.dart
└── docs/
    ├── usecase_diagram.svg
    └── video_demo_script.md
```

### 7.2 Perintah Build APK Release
```bash
cd e:\subtrack
flutter pub get
flutter build apk --release
# Output: build\app\outputs\flutter-apk\app-release.apk
```

### 7.3 Repository GitHub
**Link GitHub:** [ISI LINK GITHUB REPO DI SINI]
