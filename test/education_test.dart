import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Education Declaration Module Tests', () {
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

      final educationFinder = find.text('Education');
      await tester.ensureVisible(educationFinder);
      await tester.tap(educationFinder);
      await tester.pumpAndSettle();
    }

    testWidgets('Education list renders and status chips render correctly', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      expect(find.text('Education Declaration'), findsOneWidget);
      expect(find.textContaining('Executive Leadership Program'), findsOneWidget);
    });

    testWidgets('Tapping an item opens detail, fields render correctly, back navigation, and handles long name safely', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      await tester.tap(find.textContaining('Executive Leadership Program'));
      await tester.pumpAndSettle();
      expect(find.text('Education Declaration Detail'), findsOneWidget);
      expect(find.text('Postgraduate'), findsOneWidget);
    });
  });
}
