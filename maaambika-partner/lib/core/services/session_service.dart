import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyIsLoggedIn = 'maaambika_partner_is_logged_in';
  static const String _keyStoreProfile = 'maaambika_partner_store_json';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static bool isLoggedIn() {
    return _prefs?.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> savePartnerSession({
    required String storeName,
    required String gstin,
    required String address,
    String token = '',
  }) async {
    await init();
    final map = {
      'storeName': storeName,
      'gstin': gstin,
      'address': address,
      'token': token,
    };
    await _prefs?.setString(_keyStoreProfile, jsonEncode(map));
    await _prefs?.setBool(_keyIsLoggedIn, true);
  }

  static Map<String, dynamic>? getSavedProfile() {
    final raw = _prefs?.getString(_keyStoreProfile);
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
    await _prefs?.remove(_keyStoreProfile);
  }
}
