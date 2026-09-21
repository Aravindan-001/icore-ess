import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Complete Application Regression QA Pass', () {
    setUp(() {
      clearMockSecureStorage();
    });

    testWidgets('6. Settings and Logout Regression', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: ICoreEssApp(),
        ),
      );
      await tester.pumpAndBootstrap();
      
      await tester.enterText(find.byKey(const Key('field_Employee ID')), '20140');
      await tester.enterText(find.byKey(const Key('field_Password')), 'Employee@123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Go to Profile
      await tester.tap(find.byIcon(Icons.person_outline).last);
      await tester.pumpAndSettle();
      
      // Tap Logout
      await tester.tap(find.text('Logout Account'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('field_Employee ID')), findsOneWidget);
    });
  });
}
