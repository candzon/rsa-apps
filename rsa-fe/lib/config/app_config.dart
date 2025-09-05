class AppConfig {
  // Konfigurasi API - Menggunakan ngrok
  static const String defaultBackendUrl =
      'https://edd9f2c89701.ngrok-free.app'; // Base URL ngrok
  static const String predictEndpoint = '/predict';

  // Konfigurasi Database
  static const String databaseName = 'predictions.db';
  static const int databaseVersion = 1;

  // Konfigurasi UI
  static const String appTitle = 'RSA Prediction App';

  // Thresholds untuk indikator warna
  static const double lowThreshold = 5.0; // 0-5: Hijau (Rendah)
  static const double mediumThreshold = 10.0; // 6-10: Kuning (Sedang)
  // >10: Merah (Tinggi)

  // Timeout untuk API call (dalam detik)
  static const int apiTimeoutSeconds = 30;

  // Format tanggal
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'dd/MM/yyyy HH:mm';

  // Pesan
  static const String loadingMessage = 'Memproses prediksi...';
  static const String saveSuccessMessage =
      'Prediksi berhasil disimpan ke riwayat';
  static const String deleteSuccessMessage = 'Prediksi berhasil dihapus';
  static const String clearAllSuccessMessage = 'Semua riwayat berhasil dihapus';

  // Kode Cuaca Options
  static const List<Map<String, dynamic>> weatherCodes = [
    {'value': 0, 'label': 'Cerah'},
    {'value': 1, 'label': 'Sebagian besar cerah'},
    {'value': 2, 'label': 'Sebagian berawan'},
    {'value': 3, 'label': 'Berawan'},
    {'value': 51, 'label': 'Hujan gerimis ringan'},
    {'value': 53, 'label': 'Hujan gerimis sedang'},
    {'value': 55, 'label': 'Hujan gerimis lebat'},
    {'value': 61, 'label': 'Hujan ringan'},
    {'value': 63, 'label': 'Hujan sedang'},
    {'value': 65, 'label': 'Hujan lebat'},
  ];

  // Helper method untuk mendapatkan label dari kode cuaca
  static String getWeatherLabel(int code) {
    for (var weather in weatherCodes) {
      if (weather['value'] == code) {
        return weather['label'];
      }
    }
    return 'Tidak Diketahui';
  }

  // Helper method untuk mendapatkan full API URL
  static String getApiUrl({String? customUrl}) {
    final baseUrl = customUrl ?? defaultBackendUrl;
    return '$baseUrl$predictEndpoint';
  }
}
