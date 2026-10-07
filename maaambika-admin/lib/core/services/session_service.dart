import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyIsLoggedIn = 'maaambika_admin_is_logged_in';
  static const String _keyUserProfile = 'maaambika_admin_profile_json';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static bool isLoggedIn() {
    return _prefs?.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> saveAdminSession({
    required String name,
    required String email,
    required String role,
    String token = '',
  }) async {
    await init();
    final map = {
      'name': name,
      'email': email,
      'role': role,
      'token': token,
    };
    await _prefs?.setString(_keyUserProfile, jsonEncode(map));
    await _prefs?.setBool(_keyIsLoggedIn, true);
  }

  static Map<String, dynamic>? getSavedProfile() {
    final raw = _prefs?.getString(_keyUserProfile);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearSession() async {
    await init();
    await _prefs?.setBool(_keyIsLoggedIn, false);
    await _prefs?.remove(_keyUserProfile);
  }
}
