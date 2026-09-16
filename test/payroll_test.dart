import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/core/utils/dependency_injection.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Payroll Modules QA', () {
    setUp(() {
      DependencyInjection.reset();
      clearMockSecureStorage();
    });

    testWidgets('Payslip screen verification', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
    await tester.pumpAndBootstrap();
    await tester.enterText(find.byKey(const Key('field_Employee ID')), 'EMP001');
    await tester.enterText(find.byKey(const Key('field_Password')), '123456');
    await tester.tap(find.text('Login'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

      await tester.tap(find.text('Payslip'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      expect(find.text('Payslips'), findsOneWidget);
      expect(find.text('January 2024'), findsOneWidget);

      await tester.tap(find.text('January 2024'));
      await tester.pumpAndSettle();

      expect(find.text('Basic Salary'), findsOneWidget);
      expect(find.text('Download PDF'), findsOneWidget);
    });

    testWidgets('Pay Summary screen verification', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
    await tester.pumpAndBootstrap();
    await tester.enterText(find.byKey(const Key('field_Employee ID')), 'EMP001');
    await tester.enterText(find.byKey(const Key('field_Password')), '123456');
    await tester.tap(find.text('Login'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

      await tester.tap(find.text('Pay Summary'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      expect(find.text('Pay Summary'), findsWidgets);
      expect(find.text('Annual Gross Pay'), findsOneWidget);
    });
  });
}
