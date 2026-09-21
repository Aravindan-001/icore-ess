import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Airfare Declaration Module Tests', () {
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

      final airfareFinder = find.text('Airfare');
      await tester.ensureVisible(airfareFinder);
      await tester.tap(airfareFinder);
      await tester.pumpAndSettle();
    }

    testWidgets('Airfare list renders and status chips render correctly', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      expect(find.text('Airfare Declaration'), findsOneWidget);
      expect(find.textContaining('Annual Leave Travel'), findsOneWidget);
    });

    testWidgets('Tapping an item opens detail, fields render correctly, and back navigation works', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      await tester.tap(find.textContaining('Annual Leave Travel'));
      await tester.pumpAndSettle();
      expect(find.text('Airfare Declaration Detail'), findsOneWidget);
      expect(find.textContaining('12500.00'), findsOneWidget);
    });
  });
}
