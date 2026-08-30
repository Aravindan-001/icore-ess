import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();

  group('Payroll Modules QA', () {
    testWidgets('Payslip screen verification', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'EMP001');
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), '123456');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('Payslip'));
      await tester.pumpAndSettle();

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
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'EMP001');
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), '123456');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('Pay Summary'));
      await tester.pumpAndSettle();

      expect(find.text('Pay Summary'), findsWidgets);
      expect(find.text('Annual Gross Pay'), findsOneWidget);
    });
  });
}
