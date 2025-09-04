import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _ipController = TextEditingController();
  bool _isTestingConnection = false;
  String? _connectionStatus;

  @override
  void initState() {
    super.initState();
    _ipController.text = AppConfig.defaultBackendUrl;
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTestingConnection = true;
      _connectionStatus = null;
    });

    try {
      // Test dengan data dummy
      await ApiService.getPrediction(
        datetime: '2024-01-15 14:30:00',
        suhuC: 25.0,
        curahHujanMm: 0.0,
        kodeCuaca: 0, // Cerah
        backendUrl: _ipController.text.isEmpty ? null : _ipController.text,
      );

      setState(() {
        _connectionStatus = 'Koneksi berhasil! ✅';
      });
    } catch (e) {
      setState(() {
        _connectionStatus = 'Koneksi gagal: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isTestingConnection = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // API Configuration Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Konfigurasi API Backend',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ipController,
                      decoration: const InputDecoration(
                        labelText: 'Backend URL',
                        hintText: 'https://3ec5f59f3fbf.ngrok-free.app',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Endpoint: ${AppConfig.predictEndpoint}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Endpoint: ${AppConfig.predictEndpoint}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isTestingConnection
                            ? null
                            : _testConnection,
                        icon: _isTestingConnection
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.wifi_find),
                        label: Text(
                          _isTestingConnection ? 'Testing...' : 'Test Koneksi',
                        ),
                      ),
                    ),
                    if (_connectionStatus != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _connectionStatus!.contains('berhasil')
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _connectionStatus!.contains('berhasil')
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        child: Text(
                          _connectionStatus!,
                          style: TextStyle(
                            color: _connectionStatus!.contains('berhasil')
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // App Info Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Aplikasi',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Nama Aplikasi', AppConfig.appTitle),
                    _buildInfoRow(
                      'Timeout API',
                      '${AppConfig.apiTimeoutSeconds} detik',
                    ),
                    _buildInfoRow('Database', AppConfig.databaseName),
                    const SizedBox(height: 16),
                    Text(
                      'Indikator Prediksi',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildIndicatorRow(
                      'Rendah',
                      '0-${AppConfig.lowThreshold.round()}',
                      Colors.green,
                    ),
                    _buildIndicatorRow(
                      'Sedang',
                      '${(AppConfig.lowThreshold + 1).round()}-${AppConfig.mediumThreshold.round()}',
                      Colors.orange,
                    ),
                    _buildIndicatorRow(
                      'Tinggi',
                      '>${AppConfig.mediumThreshold.round()}',
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Instructions Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Petunjuk Penggunaan',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '1. Pastikan server FastAPI backend berjalan\n'
                      '2. Atur Backend URL (ngrok atau IP:port) di atas\n'
                      '3. Klik "Test Koneksi" untuk memastikan koneksi berhasil\n'
                      '4. Gunakan halaman Home untuk melakukan prediksi\n'
                      '5. Lihat riwayat prediksi di halaman History',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildIndicatorRow(String level, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text('$level: $range permintaan/jam'),
        ],
      ),
    );
  }
}
