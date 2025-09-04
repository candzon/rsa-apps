import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  static Future<Map<String, dynamic>> getPrediction({
    required String datetime,
    required double suhuC,
    required double curahHujanMm,
    required int kodeCuaca,
    String? backendUrl,
  }) async {
    final url = Uri.parse(AppConfig.getApiUrl(customUrl: backendUrl));

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "datetime": datetime,
              "suhu_c": suhuC,
              "curah_hujan_mm": curahHujanMm,
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
