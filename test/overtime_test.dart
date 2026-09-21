import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Overtime Module Tests', () {
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
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      final overtimeFinder = find.widgetWithText(InkWell, 'Overtime');
      await tester.ensureVisible(overtimeFinder);
      await tester.tap(overtimeFinder);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('Navigate to Overtime and view list', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      expect(find.text('Overtime'), findsOneWidget);
      expect(find.textContaining('Weekend support for server migration'), findsOneWidget);
    });

    testWidgets('View Overtime Detail', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      await tester.tap(find.textContaining('Weekend support for server migration'));
      await tester.pumpAndSettle();
      expect(find.text('Overtime Request'), findsOneWidget);
      expect(find.text('4.0 hours'), findsOneWidget);
    });

    testWidgets('Pull to refresh Overtime list', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await tester.pumpAndSettle();
      expect(find.text('Overtime'), findsOneWidget);
    });
  });
}
