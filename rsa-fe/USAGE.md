# Cara Menjalankan Aplikasi RSA Prediction

## Persiapan Backend FastAPI

Sebelum menjalankan aplikasi Flutter, pastikan backend FastAPI sudah berjalan:

1. **Jalankan server FastAPI** di port 8000
2. **Catat IP address** komputer yang menjalankan FastAPI
3. **Pastikan endpoint `/predict`** tersedia dan menerima JSON:
   ```json
   {
     "datetime": "2024-01-15 14:30:00",
     "suhu_c": 28.5,
     "curah_hujan_mm": 2.1,
     "kode_cuaca": 3
   }
   ```

## Menjalankan Aplikasi Flutter

### 1. Install Dependencies
```bash
cd rsa-fe
flutter pub get
```

### 2. Konfigurasi IP Backend
Edit file `lib/config/app_config.dart`:
```dart
static const String defaultBackendIp = '192.168.1.100'; // Ganti dengan IP Anda
```

### 3. Run Aplikasi

#### Untuk Android/iOS (dengan emulator/device):
```bash
flutter run
```

#### Untuk Web Browser:
```bash
flutter run -d chrome
```

#### Untuk Windows Desktop:
```bash
flutter run -d windows
```

### 4. Build untuk Production

#### Web:
```bash
flutter build web
```

#### Android APK:
```bash
flutter build apk
```

#### Windows EXE:
```bash
flutter build windows
```

## Penggunaan Aplikasi

### Tab Prediksi (Home)
1. **Pilih tanggal & waktu** dengan DateTimePicker
2. **Input suhu** dalam Celsius (contoh: 28.5)
3. **Input curah hujan** dalam mm (contoh: 2.1)
4. **Pilih kode cuaca** dari dropdown (0, 1, 2, 3, 51, 53, 55, 61, 63, 65)
5. **Klik tombol "Prediksi"**
6. **Lihat hasil** dengan indikator warna:
   - 🟢 Hijau = Rendah (0-5)
   - 🟡 Kuning = Sedang (6-10)  
   - 🔴 Merah = Tinggi (>10)
7. **Simpan ke riwayat** jika diperlukan

### Tab Riwayat (History)
1. **Lihat semua prediksi** yang pernah dibuat
2. **Klik item** untuk melihat detail
3. **Menu titik tiga** untuk hapus individual
4. **Tombol delete** di AppBar untuk hapus semua

### Tab Pengaturan (Settings)
1. **Ubah IP Backend** sesuai kebutuhan
2. **Test koneksi** untuk memastikan backend accessible
3. **Lihat informasi aplikasi** dan threshold indikator

## Troubleshooting

### Error "Koneksi Gagal"
- Pastikan backend FastAPI berjalan
- Cek IP address di pengaturan
- Pastikan firewall tidak memblokir akses
- Pastikan device dalam network yang sama

### Error Build
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Database Error
- Database SQLite akan dibuat otomatis
- Jika ada masalah, uninstall dan install ulang aplikasi

## Format Data yang Diperlukan

### Request ke API:
```json
{
  "datetime": "YYYY-MM-DD HH:MM:SS",
  "suhu_c": float (suhu dalam Celsius),
  "curah_hujan_mm": float (curah hujan dalam mm),
  "kode_cuaca": int (0, 1, 2, 3, 51, 53, 55, 61, 63, 65 sesuai tabel kode cuaca)
}
```

### Response dari API:
```json
{
  "y_pred": float (hasil prediksi),
  "unit": string (satuan, biasanya "permintaan/jam")
}
```

## Tips Penggunaan

1. **Gunakan IP yang benar** - pastikan IP backend accessible dari device
2. **Test koneksi dulu** - gunakan fitur test di tab Settings
3. **Cek format data** - pastikan input sesuai format yang diharapkan
4. **Simpan prediksi penting** - gunakan fitur history untuk tracking
5. **Update regular** - selalu gunakan data cuaca terbaru untuk akurasi

## Support

Jika mengalami masalah:
1. Cek log Flutter dengan `flutter run --verbose`
2. Pastikan backend FastAPI tidak error
3. Cek network connectivity
4. Restart aplikasi jika diperlukan
