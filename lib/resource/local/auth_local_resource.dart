import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalResource {
  static const String _tokenKey = 'token';

  static String? _sanitizeToken(String? rawToken) {
    if (rawToken == null) return null;
    var cleaned = rawToken.trim();
    if (cleaned.toLowerCase().startsWith('bearer ')) {
      cleaned = cleaned.substring(7).trim();
    }
    if (cleaned.length >= 2 &&
        cleaned.startsWith('"') &&
        cleaned.endsWith('"')) {
      cleaned = cleaned.substring(1, cleaned.length - 1).trim();
    }
    if (cleaned.isEmpty ||
        cleaned.toLowerCase() == 'null' ||
        cleaned.toLowerCase() == 'undefined') {
      return null;
    }
    return cleaned;
  }

  /// Simpan token ke storage
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final cleaned = _sanitizeToken(token);
    if (cleaned == null) {
      await prefs.remove(_tokenKey);
      return;
    }
    await prefs.setString(_tokenKey, cleaned);
  }

  /// Ambil token dari storage
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = _sanitizeToken(prefs.getString(_tokenKey));
    return token;
  }

  /// Cek apakah token tersedia
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Hapus token dari storage
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}