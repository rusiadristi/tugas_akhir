# Waroeng Ngemil POS - Sistem Kasir & Manajemen Penjualan Berbasis Flutter

Aplikasi Point of Sale (POS) dan Sistem Kasir Modern untuk toko kuliner dan minuman "Waroeng Ngemil" berbasis Flutter dan Dart dengan dukungan penyimpanan data lokal (SQLite & SharedPreferences), antarmuka responsif estetik (Google Fonts Poppins), kalkulasi pembayaran otomatis, serta fitur cetak struk transaksi belanja.

## Requirement

Pastikan sudah terinstall:

* Git
* Flutter SDK (v3.24.x atau yang kompatibel)
* Dart SDK (v3.5.x atau terbaru)
* Web Browser modern (Google Chrome, Microsoft Edge) atau Perangkat Android / Emulator
* Code Editor (VS Code atau Android Studio) yang telah terpasang ekstensi Flutter & Dart

Cek Git:

```bash
git --version
```

Cek Flutter & Dart:

```bash
flutter --version
```

## Instalasi & Menjalankan Aplikasi

Clone repository:

```bash
git clone https://github.com/rusiadristi/tugas_akhir.git
cd tugas_akhir
```

Unduh seluruh dependensi paket:

```bash
flutter pub get
```

Jalankan aplikasi melalui Web Browser (Google Chrome):

```bash
flutter run -d chrome
```

Atau jalankan langsung pada perangkat HP Android / Emulator:

```bash
flutter run
```

## Akun Akses Kasir (Default)

Tersedia akun bawaan (*default*) untuk keperluan pengujian langsung ke dalam sistem kasir tanpa perlu mendaftar:

* **Username**: `admin`
* **Password**: `admin`

> Pengguna juga dapat mendaftarkan akun kasir baru secara mandiri melalui menu **Daftar Baru** pada halaman login.

## Struktur & Fitur Utama Sistem

* **Splash Screen Interaktif:** Layar pembuka beranimasi halus (*Fade & Scale Transition*) dengan durasi responsif (2.5 detik) serta transisi mulus ke halaman beranda.
* **Landing / Welcome Screen Hero:** Menampilkan identitas toko *Waroeng Ngemil*, badge *Point of Sale*, chip fitur keunggulan, serta tombol akses kasir anti-overflow.
* **Autentikasi & Registrasi Pengguna:** Formulir login bertema modern (*Elevated Card*), dilengkapi fitur sembunyikan/tampilkan password, validasi input, serta penyimpanan kredensial lokal via `SharedPreferences`.
* **Dashboard Kasir Terpadu:** Pusat kendali operasional kasir dengan banner status aktif toko, profil kasir, kartu transaksi utama, dan akses langsung ke seluruh modul laporan.
* **Katalog Menu & Pencarian Real-Time:** Penelusuran produk makanan dan minuman secara instan, filter kategori (*Semua, Minuman, Makanan*), stepper kuantitas interaktif (+/-), dan indikator badge keranjang belanja dinamis.
* **Keranjang Belanja (Cart Management):** Rekapitulasi pesanan otomatis dengan kalkulasi subtotal per item, rincian biaya, serta validasi keranjang kosong.
* **Kalkulator Pembayaran & Deteksi Kembalian:** Fleksibilitas metode pembayaran (*Tunai* dan *Kartu / Non-Tunai*), tombol pintas nominal uang (*Uang Pas, Rp 20.000, Rp 50.000, Rp 100.000*), serta indikator visual otomatis untuk status uang cukup/kurang.
* **Pembuatan & Cetak Struk Transaksi:** Format struk belanja standar printer kasir thermal yang memuat ID transaksi unik, rincian belanja, waktu transaksi lokal (WIB), dan ucapan terima kasih.
* **Laporan Penjualan (Harian, Bulanan, Produk):** Ringkasan omset dan total porsi terjual, fitur penambahan data manual, pengeditan dan penghapusan data penjualan, serta analisis produk terlaris (*Best Seller*).
* **Desain UI/UX Modern & Responsif:** Menggunakan Google Fonts Poppins dengan tema warna Deep Slate Blue (`#195C85`), tata letak terlindung `SafeArea`, dan nyaman digunakan di berbagai ukuran layar smartphone maupun browser desktop.

## Tech Stack & Dependensi

* **Framework:** [Flutter](https://flutter.dev/) (Cross-Platform Mobile & Web)
* **Programming Language:** [Dart](https://dart.dev/)
* **Penyimpanan Lokal:** `sqflite`, `shared_preferences`, `path_provider`
* **Pencetakan Struk:** `esc_pos_printer`, `esc_pos_utils`
* **Tipografi & Desain:** `google_fonts` (Poppins), `cupertino_icons`
* **Format Waktu & Mata Uang:** `intl` (Rupiah `id_ID` & Tanggal Indonesia)
