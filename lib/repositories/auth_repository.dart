import '../models/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> login(String employeeId, String password);
  Future<bool> forgotPassword(String employeeIdOrEmail);
  Future<bool> changePassword(String employeeId, String currentPassword, String newPassword);
  Future<void> logout();
}
