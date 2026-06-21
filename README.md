# SubsTrack 📱

Aplikasi manajemen langganan digital berbasis Flutter. Lacak semua langganan dalam satu tempat dan pantau total pengeluaran bulanan secara otomatis.

## Download APK

[![Download APK](https://img.shields.io/badge/Download-APK-6C63FF?style=for-the-badge&logo=android)](https://github.com/Dwica2004/subtrack/releases/latest)

## Fitur

- **Tambah, Edit, Hapus** langganan digital
- **Total bulanan otomatis** terupdate setiap ada perubahan data
- **Filter kategori** — Streaming, Musik, Produktivitas, Game, Cloud, dan lainnya
- **Statistik & Pie Chart** distribusi pengeluaran per kategori
- **Detail langganan** dengan estimasi pengeluaran tahunan
- **Validasi form** — nama, harga, dan tanggal wajib diisi dengan benar
- **Snackbar feedback** setelah setiap aksi berhasil
- **Empty state** saat belum ada data
- **Persistensi data** — tersimpan permanen menggunakan SharedPreferences

## Screenshots

| Home | Tambah | Statistik | Detail |
|------|--------|-----------|--------|
| ![Home](docs/screenshots/home.png) | ![Add](docs/screenshots/add.png) | ![Stats](docs/screenshots/stats.png) | ![Detail](docs/screenshots/detail.png) |

## Teknologi

| Komponen | Detail |
|----------|--------|
| Framework | Flutter 3.24.0 (Dart 3.5.0) |
| Platform | Android 5.0+ (API 21+) |
| Persistensi | shared_preferences |
| Chart | fl_chart |
| Format Rupiah | intl |

## Struktur Project

```
lib/
├── main.dart
├── models/
│   └── subscription.dart
├── services/
│   └── storage_service.dart
├── screens/
│   ├── home_screen.dart
│   ├── add_edit_screen.dart
│   ├── detail_screen.dart
│   └── statistics_screen.dart
└── widgets/
    ├── subscription_card.dart
    └── empty_state.dart
```

## Cara Install APK

1. Download `app-release.apk` dari [Releases](https://github.com/Dwica2004/subtrack/releases/latest)
2. Aktifkan **Sumber tidak dikenal** di Pengaturan HP
3. Buka file APK dan install
4. Jalankan **SubsTrack**

## Build dari Source

```bash
git clone https://github.com/Dwica2004/subtrack.git
cd subtrack
flutter pub get
flutter build apk --release
```

---

Tugas Besar WPPL — [Dwica2004](https://github.com/Dwica2004)
