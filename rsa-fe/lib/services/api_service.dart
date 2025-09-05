import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  Future<Map<String, dynamic>> getPrediction(
    DateTime datetime,
    double suhuC,
    double curahHujanMm,
    double tekananUdaraHpa,
    double kecepatanAnginKmh,
    int kodeCuaca,
  ) async {
    // Mendapatkan URL dari AppConfig yang sudah terintegrasi dengan SettingsService
    final apiUrl = await AppConfig.getApiUrl();
    final url = Uri.parse(apiUrl);

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "datetime": datetime.toIso8601String(),
              "suhu_c": suhuC,
              "curah_hujan_mm": curahHujanMm,
              "tekanan_udara_hpa": tekananUdaraHpa,
              "kecepatan_angin_kmh": kecepatanAnginKmh,
              "kode_cuaca": kodeCuaca,
            }),
          )
          .timeout(Duration(seconds: AppConfig.apiTimeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'y_pred': data['y_pred']?.toDouble() ?? 0.0,
          'unit': data['unit'] ?? 'permintaan/jam',
        };
      } else {
        throw Exception(
          "Gagal prediksi: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Error koneksi: $e");
    }
  }
}
