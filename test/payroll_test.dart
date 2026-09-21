import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/models/employee.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Payroll Modules QA', () {
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

    testWidgets('Payslip screen verification and detail navigation', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      await tester.tap(find.text('My Payslips'));
      await tester.pumpAndSettle();
      expect(find.text('Payslips'), findsWidgets);
      expect(find.text('JAN-2025'), findsOneWidget);

      await tester.tap(find.text('View').first);
      await tester.pumpAndSettle();
      expect(find.text('Payslip Details'), findsOneWidget);
      expect(find.textContaining('ANITHA K'), findsOneWidget);
    });

    testWidgets('Pay Summary screen verification', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      await tester.tap(find.widgetWithText(InkWell, 'Pay Summary'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Pay Summary'), findsWidgets);
      expect(find.text('Basic Salary'), findsOneWidget);
    });
   group('HR Payslip Management', () {
    testWidgets('HR can view employee payslips', (WidgetTester tester) async {
       await tester.pumpWidget(const ProviderScope(child: ICoreEssApp()));
      await tester.pumpAndBootstrap();
      await tester.enterText(find.byKey(const Key('field_Employee ID')), 'HR001');
      await tester.enterText(find.byKey(const Key('field_Password')), 'HR@12345');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      
      await tester.tap(find.text('Payroll'));
      await tester.pumpAndSettle();
      
      expect(find.text('Payslip Management'), findsOneWidget);
      // Select employee
      await tester.tap(find.byType(DropdownButton<Employee>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ANITHA K (20140)').last);
      await tester.pumpAndSettle();
      
      expect(find.text('JAN-2025'), findsOneWidget);
    });
  });
  });
}
