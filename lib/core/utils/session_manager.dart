import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages secure storage of session tokens and credentials.
/// Used for production authentication handling.
class SessionManager {
  static const _storage = FlutterSecureStorage();
  
  static const String _keyToken = 'auth_token';
  static const String _keySessionId = 'session_id';
  static const String _keyEmployeeId = 'employee_id';

  /// Saves the session data after successful authentication.
  static Future<void> saveSession({
    String? token,
    String? sessionId,
    String? employeeId,
  }) async {
    if (token != null) await _storage.write(key: _keyToken, value: token);
    if (sessionId != null) await _storage.write(key: _keySessionId, value: sessionId);
    if (employeeId != null) await _storage.write(key: _keyEmployeeId, value: employeeId);
  }

  /// Retrieves the stored authentication token.
  static Future<String?> getToken() async => await _storage.read(key: _keyToken);

  /// Retrieves the stored session ID.
  static Future<String?> getSessionId() async => await _storage.read(key: _keySessionId);

  /// Retrieves the stored employee ID.
  static Future<String?> getEmployeeId() async => await _storage.read(key: _keyEmployeeId);

  /// Clears all session data on logout.
  static Future<void> clearSession() async {
    await _storage.deleteAll();
  }

  /// Checks if a valid session exists.
  static Future<bool> hasSession() async {
    final token = await getToken();
    final sessionId = await getSessionId();
    return token != null || sessionId != null;
  }
}
