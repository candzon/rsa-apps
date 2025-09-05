import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../services/api_service.dart';
import '../config/app_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _urlController = TextEditingController();
  final SettingsService _settingsService = SettingsService();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isTesting = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUrl();
  }

  Future<void> _loadCurrentUrl() async {
    final currentUrl = await _settingsService.getBackendUrl();
    setState(() {
      _urlController.text = currentUrl;
    });
  }

  Future<void> _saveUrl() async {
    final url = _urlController.text.trim();

    if (url.isEmpty) {
      _showSnackBar('URL tidak boleh kosong', Colors.red);
      return;
    }

    if (!_settingsService.isValidUrl(url)) {
      _showSnackBar(
        'Format URL tidak valid. Gunakan http:// atau https://',
        Colors.red,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _settingsService.setBackendUrl(url);
      _showSnackBar('URL backend berhasil disimpan', Colors.green);
    } catch (e) {
      _showSnackBar('Gagal menyimpan URL: $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testConnection() async {
    final url = _urlController.text.trim();

    if (url.isEmpty) {
      _showSnackBar('URL tidak boleh kosong', Colors.red);
      return;
    }

    if (!_settingsService.isValidUrl(url)) {
      _showSnackBar('Format URL tidak valid', Colors.red);
      return;
    }

    setState(() => _isTesting = true);

    // Store original URL for restoration if test fails
    String? originalUrl;

    try {
      originalUrl = await _settingsService.getBackendUrl();

      // Temporary set URL for testing
      await _settingsService.setBackendUrl(url);

      // Test with dummy data
      await _apiService.getPrediction(
        DateTime.now(),
        25.0,
        60.0,
        1013.25,
        10.0,
        1,
      );

      _showSnackBar('Koneksi berhasil! Server dapat diakses', Colors.green);
    } catch (e) {
      _showSnackBar('Koneksi gagal: ${e.toString()}', Colors.red);
      // Restore original URL if test failed and we have it
      if (originalUrl != null) {
        await _settingsService.setBackendUrl(originalUrl);
      }
    } finally {
      setState(() => _isTesting = false);
    }
  }

  Future<void> _resetToDefault() async {
    setState(() {
      _urlController.text = _settingsService.getDefaultUrl();
    });
    await _settingsService.resetBackendUrl();
    _showSnackBar('URL direset ke default', Colors.blue);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Konfigurasi Backend',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'URL Backend Server',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'https://your-backend-url.com',
                  prefixIcon: Icon(Icons.link),
                  helperText:
                      'Masukkan URL lengkap dengan http:// atau https://',
                ),
                keyboardType: TextInputType.url,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading || _isTesting ? null : _saveUrl,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(_isLoading ? 'Menyimpan...' : 'Simpan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading || _isTesting
                          ? null
                          : _testConnection,
                      icon: _isTesting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.wifi_find),
                      label: Text(_isTesting ? 'Testing...' : 'Test Koneksi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isLoading || _isTesting ? null : _resetToDefault,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset ke Default'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Informasi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• URL harus dimulai dengan http:// atau https://\n'
                      '• Gunakan "Test Koneksi" untuk memverifikasi server\n'
                      '• Pengaturan akan tersimpan secara otomatis\n'
                      '• Default: ngrok tunnel URL',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // App info section yang sederhana
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Aplikasi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Aplikasi: ${AppConfig.appTitle}'),
                    Text('Database: ${AppConfig.databaseName}'),
                    Text('Timeout API: ${AppConfig.apiTimeoutSeconds}s'),
                    Text('Endpoint: ${AppConfig.predictEndpoint}'),
                  ],
                ),
              ),

              const SizedBox(height: 20), // Add some bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
