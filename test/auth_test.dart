import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/core/providers/injection_providers.dart';
import 'package:icore_ess/repositories/mock_ess_repository.dart';
import 'package:icore_ess/services/location_service.dart';
import 'test_utils.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
    setupSecureStorageMock();
  });

  late MockEssRepository mockRepository;

  setUp(() {
    clearMockSecureStorage();
    mockRepository = MockEssRepository();
    mockRepository.reset();
  });

  group('Login Flow Debugging Tests', () {
    testWidgets('TEST 1: Valid 20140 / Employee@123 login succeeds', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            essRepositoryProvider.overrideWithValue(mockRepository),
            locationServiceProvider.overrideWithValue(MockLocationService()),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndBootstrap();
      
      final idField = find.byKey(const Key('field_Employee ID'));
      final passField = find.byKey(const Key('field_Password'));
      
      await tester.enterText(idField, '20140');
      await tester.enterText(passField, 'Employee@123');
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      
      expect(find.textContaining('ANITHA K'), findsOneWidget);
    });

    testWidgets('TEST 8: Change Password and verify authentication', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            essRepositoryProvider.overrideWithValue(mockRepository),
            locationServiceProvider.overrideWithValue(MockLocationService()),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndBootstrap();
      
      // Login
      await tester.enterText(find.byKey(const Key('field_Employee ID')), '20140');
      await tester.enterText(find.byKey(const Key('field_Password')), 'Employee@123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Navigate to Profile
      await tester.tap(find.byIcon(Icons.person_outline).last);
      await tester.pumpAndSettle();
      
      // Settings
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Change Password'));
      await tester.pumpAndSettle();

      // Change
      await tester.enterText(find.byKey(const Key('field_Current Password')), 'Employee@123');
      await tester.enterText(find.byKey(const Key('field_New Password')), 'newpass123');
      await tester.enterText(find.byKey(const Key('field_Confirm New Password')), 'newpass123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Change Password'));
      await tester.pumpAndSettle();
      expect(find.text('Password changed successfully'), findsOneWidget);
      
      // Logout
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Logout Account'));
      await tester.pumpAndSettle();
      
      expect(find.text('Login to Your Account'), findsOneWidget);

      // Relogin with new
      await tester.enterText(find.byKey(const Key('field_Employee ID')), '20140');
      await tester.enterText(find.byKey(const Key('field_Password')), 'newpass123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      expect(find.textContaining('ANITHA K'), findsOneWidget);
    });

    testWidgets('HR001 / HR@12345 login navigates to HR Dashboard', (WidgetTester tester) async {
       await tester.pumpWidget(
        ProviderScope(
          overrides: [
            essRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndBootstrap();
      
      await tester.enterText(find.byKey(const Key('field_Employee ID')), 'HR001');
      await tester.enterText(find.byKey(const Key('field_Password')), 'HR@12345');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
      
      expect(find.text('Admin Portal'), findsOneWidget);
    });
  });
}
