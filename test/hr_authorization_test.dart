import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/core/constants/app_constants.dart';
import 'package:icore_ess/core/providers/injection_providers.dart';
import 'package:icore_ess/core/utils/session_manager.dart';
import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AUTHZ-001 — HR Role Authorization & Route Guard Tests', () {
    late GlobalKey<NavigatorState> navigatorKey;

    setUp(() async {
      setupSecureStorageMock();
      await SessionManager.clearSession();
      navigatorKey = GlobalKey<NavigatorState>();
    });

    tearDown(() async {
      await SessionManager.clearSession();
    });

    testWidgets('1. HR user can access HR Dashboard', (tester) async {
      await SessionManager.saveSession(
        token: 'valid_hr_token',
        employeeId: 'HR001',
        role: 'hr',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navigatorKeyProvider.overrideWithValue(navigatorKey),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate directly to HR Dashboard via navigatorKey
      navigatorKey.currentState!.pushNamed(AppConstants.hrDashboardRoute);
      await tester.pumpAndSettle();

      expect(find.text('Admin Portal'), findsOneWidget);
    });

    testWidgets('2. HR user can access HR Employees', (tester) async {
      await SessionManager.saveSession(
        token: 'valid_hr_token',
        employeeId: 'HR001',
        role: 'hr',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navigatorKeyProvider.overrideWithValue(navigatorKey),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndSettle();

      navigatorKey.currentState!.pushNamed(AppConstants.hrEmployeesRoute);
      await tester.pumpAndSettle();

      expect(find.text('Employee Management'), findsOneWidget);
    });

    testWidgets('3. HR user can access HR Leaves', (tester) async {
      await SessionManager.saveSession(
        token: 'valid_hr_token',
        employeeId: 'HR001',
        role: 'hr',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navigatorKeyProvider.overrideWithValue(navigatorKey),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndSettle();

      navigatorKey.currentState!.pushNamed(AppConstants.hrLeavesRoute);
      await tester.pumpAndSettle();

      expect(find.text('Leave Management'), findsOneWidget);
    });

    testWidgets('4. HR user can access HR Payslips', (tester) async {
      await SessionManager.saveSession(
        token: 'valid_hr_token',
        employeeId: 'HR001',
        role: 'hr',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navigatorKeyProvider.overrideWithValue(navigatorKey),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndSettle();

      navigatorKey.currentState!.pushNamed(AppConstants.hrPayslipsRoute);
      await tester.pumpAndSettle();

      expect(find.text('Payslip Management'), findsOneWidget);
    });

    testWidgets('5. Employee cannot access HR Dashboard', (tester) async {
      await SessionManager.saveSession(
        token: 'valid_emp_token',
        employeeId: '20140',
        role: 'employee',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navigatorKeyProvider.overrideWithValue(navigatorKey),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndSettle();

      navigatorKey.currentState!.pushNamed(AppConstants.hrDashboardRoute);
      await tester.pumpAndSettle();

      expect(find.text('Admin Portal'), findsNothing);
      expect(find.text('Access Denied: HR authorization required.'), findsOneWidget);
    });

    testWidgets('6. Employee cannot access HR Employees', (tester) async {
      await SessionManager.saveSession(
        token: 'valid_emp_token',
        employeeId: '20140',
        role: 'employee',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navigatorKeyProvider.overrideWithValue(navigatorKey),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndSettle();

      navigatorKey.currentState!.pushNamed(AppConstants.hrEmployeesRoute);
      await tester.pumpAndSettle();

      expect(find.text('Employee Management'), findsNothing);
      expect(find.text('Access Denied: HR authorization required.'), findsOneWidget);
    });

    testWidgets('7. Employee cannot access HR Leaves', (tester) async {
      await SessionManager.saveSession(
        token: 'valid_emp_token',
        employeeId: '20140',
        role: 'employee',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navigatorKeyProvider.overrideWithValue(navigatorKey),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndSettle();

      navigatorKey.currentState!.pushNamed(AppConstants.hrLeavesRoute);
      await tester.pumpAndSettle();

      expect(find.text('Leave Management'), findsNothing);
      expect(find.text('Access Denied: HR authorization required.'), findsOneWidget);
    });

    testWidgets('8. Employee cannot access HR Payslips', (tester) async {
      await SessionManager.saveSession(
        token: 'valid_emp_token',
        employeeId: '20140',
        role: 'employee',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navigatorKeyProvider.overrideWithValue(navigatorKey),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndSettle();

      navigatorKey.currentState!.pushNamed(AppConstants.hrPayslipsRoute);
      await tester.pumpAndSettle();

      expect(find.text('Payslip Management'), findsNothing);
      expect(find.text('Access Denied: HR authorization required.'), findsOneWidget);
    });

    testWidgets('9. Direct navigation to HR route is denied for Employee and safely pops/redirects', (tester) async {
      await SessionManager.saveSession(
        token: 'valid_emp_token',
        employeeId: '20140',
        role: 'employee',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navigatorKeyProvider.overrideWithValue(navigatorKey),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndSettle();

      navigatorKey.currentState!.pushNamed(AppConstants.hrDashboardRoute);
      await tester.pumpAndSettle();

      // HR screen title should NOT be present
      expect(find.text('Admin Portal'), findsNothing);
      // Access Denied message should be displayed
      expect(find.text('Access Denied: HR authorization required.'), findsOneWidget);
    });

    testWidgets('10. Authorization remains enforced after logout/session state changes', (tester) async {
      // Step 1: Login as HR
      await SessionManager.saveSession(
        token: 'valid_hr_token',
        employeeId: 'HR001',
        role: 'hr',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            navigatorKeyProvider.overrideWithValue(navigatorKey),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Step 2: Logout / Clear session
      await SessionManager.clearSession();

      // Step 3: Attempt direct navigation to HR route after session cleared
      navigatorKey.currentState!.pushNamed(AppConstants.hrDashboardRoute);
      await tester.pumpAndSettle();

      // HR screen title should NOT be rendered
      expect(find.text('Admin Portal'), findsNothing);
      expect(find.text('Access Denied: HR authorization required.'), findsOneWidget);
    });
  });
}
