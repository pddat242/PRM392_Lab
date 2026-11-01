
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  // Lưu phiên đăng nhập
  Future<void> saveSession(
    String token,
    String username,
  ) async {
    await _prefs.setString('token', token);
    await _prefs.setString('username', username);
  }

  // Lấy token đã lưu
  Future<String?> getToken() async {
    return await _prefs.getString('token');
  }

  // Lấy username
  Future<String?> getUsername() async {
    return await _prefs.getString('username');
  }

  // Xóa phiên khi đăng xuất
  Future<void> logout() async {
    await _prefs.remove('token');
    await _prefs.remove('username');
  }
}
