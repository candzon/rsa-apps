# RSA Prediction App

Aplikasi Flutter untuk memprediksi permintaan RSA (Road Side Assistance) berdasarkan data cuaca menggunakan API FastAPI.

## Fitur

### 1. Input Form
- **DateTimePicker**: Pilih tanggal dan jam
- **TextField Suhu**: Input suhu dalam Celsius (°C)
- **TextField Curah Hujan**: Input curah hujan dalam mm
- **Dropdown Kode Cuaca**: Pilih kondisi cuaca (1-6)

### 2. API Integration
- **HTTP POST** ke endpoint `/predict`
- **Request Format**:
  ```json
  {
    "datetime": "2024-01-15 14:30:00",
    "suhu_c": 28.5,
    "curah_hujan_mm": 2.1,
    "kode_cuaca": 3
  }
  ```
- **Response Format**:
  ```json
  {
    "y_pred": 7.46,
    "unit": "permintaan/jam"
  }
  ```

### 3. Tampilan Hasil
- **Prediksi dalam angka bulat**: Contoh "7 permintaan/jam"
- **Indikator Visual Warna**:
  - 🟢 **Hijau** → Rendah (0-5 permintaan/jam)
  - 🟡 **Kuning** → Sedang (6-10 permintaan/jam)
  - 🔴 **Merah** → Tinggi (>10 permintaan/jam)

### 4. History/Riwayat
- Simpan riwayat prediksi ke **SQLite Database**
- Tampilkan list prediksi sebelumnya
- Fitur hapus satu atau semua riwayat

### 5. UI/UX
- **Material Design 3**
- **Bottom Navigation Bar**:
  - Home → Form input + tombol prediksi
  - History → Riwayat prediksi
- **Loading indicators**
- **Error handling** dengan Snackbar

## Kode Cuaca

| Kode | Kondisi |
|------|---------|
| 0    | Cerah |
| 1    | Sebagian besar cerah |
| 2    | Sebagian berawan |
| 3    | Berawan |
| 51   | Hujan gerimis ringan |
| 53   | Hujan gerimis sedang |
| 55   | Hujan gerimis lebat |
| 61   | Hujan ringan |
| 63   | Hujan sedang |
| 65   | Hujan lebat |

## Konfigurasi

### Backend API
Edit file `lib/config/app_config.dart`:

```dart
static const String defaultBackendIp = '192.168.1.100'; // Ganti dengan IP backend
static const int backendPort = 8000;
```

### Dependencies
```yaml
dependencies:
  http: ^1.2.0      # HTTP client
  sqflite: ^2.3.0   # SQLite database  
  path_provider: ^2.1.0
  path: ^1.8.3
  intl: ^0.19.0     # Date formatting
```

## Instalasi & Menjalankan

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Konfigurasi IP Backend**:
   - Edit `lib/config/app_config.dart`
   - Ganti `defaultBackendIp` dengan IP server FastAPI

3. **Run Aplikasi**:
   ```bash
   flutter run
   ```

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
