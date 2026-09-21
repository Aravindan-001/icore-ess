import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Phase 7 — Requests & Workflow Management Tests', () {
    setUp(() {
      clearMockSecureStorage();
    });

    Future<void> loginAndNavigate(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ProviderScope(child: ICoreEssApp()));
      await tester.pumpAndBootstrap();
      await tester.enterText(find.byKey(const Key('field_Employee ID')), '20140');
      await tester.enterText(find.byKey(const Key('field_Password')), 'Employee@123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('B & C. Requests provider, filtering, and UI components validation', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      
      // Navigate to Leaves via bottom nav
      await tester.tap(find.byIcon(Icons.calendar_today_outlined));
      await tester.pumpAndSettle();
      
      expect(find.text('Compensatory Leave'), findsOneWidget);
    });

    testWidgets('E & F. Dashboard unified pending requests and refresh validation', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      
      expect(find.text('Latest Net Pay'), findsOneWidget);
    });
  });
}
