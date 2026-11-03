import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _keyUsername = 'username';
  static const String _keyPassword = 'password';

  // Menyimpan username dan password
  static Future<void> saveUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyPassword, password);
  }

  // Mengambil username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // Mengambil password
  static Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPassword);
  }

  // Menghapus data pengguna
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyPassword);
  }
}
