import 'package:flutter/material.dart';
import '../models/auth_result.dart';
import '../repositories/auth_repository.dart';
import '../core/utils/session_manager.dart';
import '../core/constants/app_constants.dart';

class AuthService {
  final AuthRepository _authRepo;

  AuthService(this._authRepo);

  Future<AuthResult> login(String employeeId, String password, {bool rememberMe = false}) async {
    final result = await _authRepo.login(employeeId, password);
    
    if (result.isSuccess) {
      // Save session
      await SessionManager.saveSession(
        token: result.token,
        employeeId: employeeId,
        role: result.employee?.role.toString().split('.').last,
      );

      if (rememberMe) {
        await SessionManager.setRememberMe(true);
        await SessionManager.saveRememberedId(employeeId);
      } else {
        await SessionManager.setRememberMe(false);
        await SessionManager.clearRememberedId();
      }
    }

    return result;
  }

  Future<void> logout(BuildContext context) async {
    await _authRepo.logout();
    await SessionManager.clearSession();
    
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppConstants.loginRoute, 
        (route) => false,
      );
    }
  }

  Future<bool> restoreSession() async {
    return await SessionManager.hasSession();
  }

  Future<bool> changePassword(String employeeId, String oldPassword, String newPassword) async {
    return await _authRepo.changePassword(employeeId, oldPassword, newPassword);
  }

  Future<bool> forgotPassword(String employeeId) async {
    return await _authRepo.forgotPassword(employeeId);
  }
}
