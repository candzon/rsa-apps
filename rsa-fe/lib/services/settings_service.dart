import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _backendUrlKey = 'backend_url';
  static const String _defaultUrl = 'https://edd9f2c89701.ngrok-free.app';

  // Singleton pattern
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  SharedPreferences? _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Get backend URL
  Future<String> getBackendUrl() async {
    await init();
    return _prefs?.getString(_backendUrlKey) ?? _defaultUrl;
  }

  // Set backend URL
  Future<bool> setBackendUrl(String url) async {
    await init();
    return _prefs?.setString(_backendUrlKey, url) ?? false;
  }

  // Reset to default URL
  Future<bool> resetBackendUrl() async {
    await init();
    return _prefs?.remove(_backendUrlKey) ?? false;
  }

  // Get default URL
  String getDefaultUrl() {
    return _defaultUrl;
  }

  // Validate URL format
  bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}
