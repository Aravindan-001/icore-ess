import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/core/utils/dependency_injection.dart';
import 'package:icore_ess/repositories/mock_ess_repository.dart';
import 'test_utils.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
    setupSecureStorageMock();
  });

  setUp(() {
    (DependencyInjection.repository as MockEssRepository).reset();
  });

  group('Login Flow Debugging Tests', () {
    testWidgets('TEST 1: Valid EMP001 / 123456 login succeeds', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      await tester.pumpAndSettle();
      
      await tester.enterText(find.byKey(const Key('field_Employee ID')), 'EMP001');
      await tester.enterText(find.byKey(const Key('field_Password')), '123456');
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Aravind Kumar'), findsOneWidget);
    });

    testWidgets('TEST 8: Change Password and verify authentication', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      await tester.pumpAndSettle();
      
      // Login
      await tester.enterText(find.byKey(const Key('field_Employee ID')), 'EMP001');
      await tester.enterText(find.byKey(const Key('field_Password')), '123456');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Change Password'));
      await tester.pumpAndSettle();

      // Change
      await tester.enterText(find.byKey(const Key('field_Current Password')), '123456');
      await tester.enterText(find.byKey(const Key('field_New Password')), 'newpass123');
      await tester.enterText(find.byKey(const Key('field_Confirm New Password')), 'newpass123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Change Password'));
      await tester.pumpAndSettle();
      expect(find.text('Password changed successfully'), findsOneWidget);
      
      // Logout
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      expect(find.byKey(const Key('field_Employee ID')), findsOneWidget);

      // Relogin with new
      await tester.enterText(find.byKey(const Key('field_Employee ID')), 'EMP001');
      await tester.enterText(find.byKey(const Key('field_Password')), 'newpass123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Aravind Kumar'), findsOneWidget);
    });
  });
}
