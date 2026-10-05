import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/core/constants/app_constants.dart';
import 'package:icore_ess/core/providers/injection_providers.dart';
import 'package:icore_ess/core/utils/session_manager.dart';
import 'package:icore_ess/models/auth_result.dart';
import 'package:icore_ess/repositories/auth_repository.dart';
import 'package:icore_ess/services/auth_service.dart';
import 'test_utils.dart';

class FailingAuthRepository implements AuthRepository {
  @override
  Future<AuthResult> login(String employeeId, String password) async {
    return AuthResult.failure(AuthStatus.serverError, 'Mock server error');
  }

  @override
  Future<void> logout() async {
    throw Exception('Remote server connection error during logout');
  }

  @override
  Future<bool> forgotPassword(String employeeIdOrEmail) async => false;

  @override
  Future<bool> changePassword(String employeeId, String currentPassword, String newPassword) async => false;
}

class SuccessfulAuthRepository implements AuthRepository {
  @override
  Future<AuthResult> login(String employeeId, String password) async {
    return AuthResult.success(token: 'mock_token');
  }

  @override
  Future<void> logout() async {
    // Remote logout succeeds
  }

  @override
  Future<bool> forgotPassword(String employeeIdOrEmail) async => true;

  @override
  Future<bool> changePassword(String employeeId, String currentPassword, String newPassword) async => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SESSION-001 & SESSION-002 — Session Validation & Logout Hardening Tests', () {
    late GlobalKey<NavigatorState> navigatorKey;

    setUp(() async {
      setupSecureStorageMock();
      await SessionManager.clearSession();
      navigatorKey = GlobalKey<NavigatorState>();
    });

    tearDown(() async {
      await SessionManager.clearSession();
    });

    test('1. No token + no session ID -> unauthenticated', () async {
      final hasSession = await SessionManager.hasSession();
      expect(hasSession, isFalse);
    });

    test('2. Token only -> rejected safely as incomplete session', () async {
      await SessionManager.saveSession(token: 'stale_token_only');

      final hasSession = await SessionManager.hasSession();

      expect(hasSession, isFalse);
      expect(await SessionManager.getToken(), isNull);
    });

    test('3. Session ID only -> rejected safely as incomplete session', () async {
      await SessionManager.saveSession(sessionId: 'stale_session_id_only');

      final hasSession = await SessionManager.hasSession();

      expect(hasSession, isFalse);
      expect(await SessionManager.getSessionId(), isNull);
    });

    test('4. Incomplete/inconsistent stored session (missing role) -> rejected safely and wiped', () async {
      await SessionManager.saveSession(
        token: 'partial_token',
        employeeId: '20140',
        // role is missing
      );

      final hasSession = await SessionManager.hasSession();

      expect(hasSession, isFalse);
      expect(await SessionManager.getToken(), isNull);
      expect(await SessionManager.getEmployeeId(), isNull);
      expect(await SessionManager.getUserRole(), isNull);
    });

    test('5. Valid complete session (token + employeeId + userRole) -> authenticated', () async {
      await SessionManager.saveSession(
        token: 'valid_token_123',
        employeeId: '20140',
        role: 'employee',
      );

      final hasSession = await SessionManager.hasSession();

      expect(hasSession, isTrue);
      expect(await SessionManager.getToken(), equals('valid_token_123'));
      expect(await SessionManager.getEmployeeId(), equals('20140'));
      expect(await SessionManager.getUserRole(), equals('employee'));
    });

    testWidgets('6. Logout with remote success -> local session cleared', (tester) async {
      await SessionManager.saveSession(
        token: 'valid_token',
        employeeId: '20140',
        role: 'employee',
      );

      final authService = AuthService(SuccessfulAuthRepository());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navigatorKeyProvider.overrideWithValue(navigatorKey),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndSettle();

      final BuildContext context = navigatorKey.currentContext!;
      await authService.logout(context);
      await tester.pumpAndSettle();

      expect(await SessionManager.hasSession(), isFalse);
      expect(await SessionManager.getToken(), isNull);
      expect(await SessionManager.getUserRole(), isNull);
    });

    testWidgets('7. Logout with remote failure -> local session STILL cleared', (tester) async {
      await SessionManager.saveSession(
        token: 'valid_token',
        employeeId: '20140',
        role: 'employee',
      );

      final authService = AuthService(FailingAuthRepository());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navigatorKeyProvider.overrideWithValue(navigatorKey),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndSettle();

      final BuildContext context = navigatorKey.currentContext!;
      await authService.logout(context);
      await tester.pumpAndSettle();

      expect(await SessionManager.hasSession(), isFalse);
      expect(await SessionManager.getToken(), isNull);
      expect(await SessionManager.getUserRole(), isNull);
    });

    testWidgets('8. After logout -> HR route cannot be accessed', (tester) async {
      await SessionManager.saveSession(
        token: 'hr_token',
        employeeId: 'HR001',
        role: 'hr',
      );

      final authService = AuthService(SuccessfulAuthRepository());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navigatorKeyProvider.overrideWithValue(navigatorKey),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndSettle();

      final BuildContext context = navigatorKey.currentContext!;
      await authService.logout(context);
      await tester.pumpAndSettle();

      // Attempt to navigate to HR route after logout
      navigatorKey.currentState!.pushNamed(AppConstants.hrDashboardRoute);
      await tester.pumpAndSettle();

      expect(find.text('Admin Portal'), findsNothing);
      expect(find.text('Access Denied: HR authorization required.'), findsOneWidget);
    });

    testWidgets('9. After logout -> authenticated application state is removed', (tester) async {
      await SessionManager.saveSession(
        token: 'emp_token',
        employeeId: '20140',
        role: 'employee',
      );

      final authService = AuthService(SuccessfulAuthRepository());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navigatorKeyProvider.overrideWithValue(navigatorKey),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndSettle();

      final BuildContext context = navigatorKey.currentContext!;
      await authService.logout(context);
      await tester.pumpAndSettle();

      expect(await SessionManager.hasSession(), isFalse);
      expect(await SessionManager.getToken(), isNull);
      expect(await SessionManager.getSessionId(), isNull);
      expect(await SessionManager.getEmployeeId(), isNull);
      expect(await SessionManager.getUserRole(), isNull);
    });
  });
}
