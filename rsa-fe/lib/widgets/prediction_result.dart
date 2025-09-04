import 'package:flutter/material.dart';
import '../models/prediction.dart';
import '../config/app_config.dart';

class PredictionResult extends StatelessWidget {
  final Prediction prediction;
  final VoidCallback? onSaveToHistory;
  final VoidCallback? onBackToForm;

  const PredictionResult({
    super.key,
    required this.prediction,
    this.onSaveToHistory,
    this.onBackToForm,
  });

  Color _getPredictionColor(double yPred) {
    if (yPred <= 5) {
      return Colors.green;
    } else if (yPred <= 10) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getPredictionLevel(double yPred) {
    if (yPred <= 5) {
      return 'RENDAH';
    } else if (yPred <= 10) {
      return 'SEDANG';
    } else {
      return 'TINGGI';
    }
  }

  IconData _getPredictionIcon(double yPred) {
    if (yPred <= 5) {
      return Icons.trending_down;
    } else if (yPred <= 10) {
      return Icons.trending_flat;
    } else {
      return Icons.trending_up;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getPredictionColor(prediction.yPred);
    final level = _getPredictionLevel(prediction.yPred);
    final icon = _getPredictionIcon(prediction.yPred);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Prediksi'),
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Main Result Card
            Card(
              elevation: 8,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(icon, size: 60, color: color),
                    const SizedBox(height: 16),
                    Text(
                      '${prediction.yPred.round()}',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      prediction.unit,
                      style: TextStyle(
                        fontSize: 18,
                        color: color.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        level,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Input Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Input',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Tanggal & Waktu',
                      prediction.datetime,
                      Icons.calendar_today,
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Suhu',
                      '${prediction.suhuC}°C',
                      Icons.thermostat,
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Curah Hujan',
                      '${prediction.curahHujanMm} mm',
                      Icons.water_drop,
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Kode Cuaca',
                      _getWeatherLabel(prediction.kodeCuaca),
                      Icons.wb_sunny,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (onSaveToHistory != null)
                  ElevatedButton.icon(
                    onPressed: onSaveToHistory,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan ke Riwayat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: onBackToForm ?? () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali ke Form'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getWeatherLabel(int kode) {
    return AppConfig.getWeatherLabel(kode);
  }
}
