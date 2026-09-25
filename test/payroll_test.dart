import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/core/providers/injection_providers.dart';
import 'package:icore_ess/core/utils/pdf_generator.dart';
import 'package:icore_ess/features/pay_summary/pay_summary_screen.dart';
import 'package:icore_ess/features/payslip/payslip_detail_screen.dart';
import 'package:icore_ess/features/payslip/payslip_screen.dart';
import 'package:icore_ess/models/employee.dart';
import 'package:icore_ess/models/pay_summary.dart';
import 'package:icore_ess/models/payslip.dart';
import 'package:icore_ess/repositories/payroll_repository.dart';
import 'test_utils.dart';

class MockErrorPayrollRepository implements PayrollRepository {
  @override
  Future<List<Payslip>> getPayslips() async {
    throw Exception('Network error loading payslips');
  }

  @override
  Future<PaySummary> getPaySummary() async {
    throw Exception('Network error loading pay summary');
  }

  @override
  Future<PayslipDetail> getPayslipDetail(String year, String month) async {
    throw Exception('Network error loading payslip detail');
  }
}

class MockEmptyPayrollRepository implements PayrollRepository {
  @override
  Future<List<Payslip>> getPayslips() async {
    return [];
  }

  @override
  Future<PaySummary> getPaySummary() async {
    return PaySummary(
      annualGrossPay: 0,
      totalDeductionsYtd: 0,
      netPayYtd: 0,
      monthlyBreakdown: [],
    );
  }

  @override
  Future<PayslipDetail> getPayslipDetail(String year, String month) async {
    throw Exception('No detail available');
  }
}

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Phase 11D — Payroll, Payslip & Document Experience Tests', () {
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

    testWidgets('1. Payslip list loads and renders multiple periods', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      await tester.tap(find.text('My Payslips'));
      await tester.pumpAndSettle();

      expect(find.text('Payslips'), findsWidgets);
      expect(find.text('JAN-2025'), findsOneWidget);
      expect(find.text('DEC-2024'), findsOneWidget);
      expect(find.text('NOV-2024'), findsOneWidget);
    });

    testWidgets('2. Payslip detail opens, employee info & totals render consistently', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      await tester.tap(find.text('My Payslips'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('View').first);
      await tester.pumpAndSettle();

      expect(find.text('Payslip Details'), findsOneWidget);
      expect(find.textContaining('ANITHA K'), findsWidgets);
      expect(find.textContaining('20140'), findsWidgets);
      expect(find.text('Basic Salary'), findsOneWidget);
      expect(find.text('Housing Allowance'), findsOneWidget);
      expect(find.text('Transportation Allowance'), findsOneWidget);
      expect(find.text('Other Allowance'), findsOneWidget);
      expect(find.text('AED 1500.00'), findsWidgets);
    });

    testWidgets('3. Previous payslip with LOP deduction renders arithmetic consistency', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      await tester.tap(find.text('My Payslips'));
      await tester.pumpAndSettle();

      // Tap on NOV-2024 View button
      final viewButtons = find.text('View');
      await tester.tap(viewButtons.at(2)); // Nov 2024 is 3rd item
      await tester.pumpAndSettle();

      expect(find.text('NOV-2024'), findsWidgets);
      expect(find.text('Unpaid Leave / LOP'), findsOneWidget);
      expect(find.text('-AED 50.00'), findsWidgets);
      expect(find.text('AED 1450.00'), findsWidgets);
    });

    testWidgets('4. Pay Summary month selector updates displayed data dynamically', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      await tester.tap(find.widgetWithText(InkWell, 'Pay Summary'));
      await tester.pumpAndSettle();

      expect(find.text('Pay Summary'), findsWidgets);
      expect(find.text('January 2025'), findsWidgets);
      expect(find.text('Basic Salary'), findsOneWidget);

      // Drag horizontal month selector to reveal November
      final monthList = find.byType(ListView).at(0);
      await tester.drag(monthList, const Offset(-600, 0));
      await tester.pumpAndSettle();

      await tester.tap(find.text('November'));
      await tester.pumpAndSettle();

      expect(find.text('No Data for November 2025'), findsOneWidget);

      // Change year to 2024
      await tester.tap(find.text('2025'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2024').last);
      await tester.pumpAndSettle();

      expect(find.text('November 2024'), findsOneWidget);
      expect(find.text('Unpaid Leave / LOP'), findsOneWidget);
    });

    testWidgets('5. Payslip empty state works properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            payrollRepositoryProvider.overrideWithValue(MockEmptyPayrollRepository()),
          ],
          child: const MaterialApp(
            home: PayslipScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No Payslips'), findsOneWidget);
    });

    testWidgets('6. Payslip error state works properly with retry', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            payrollRepositoryProvider.overrideWithValue(MockErrorPayrollRepository()),
          ],
          child: const MaterialApp(
            home: PayslipScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Error loading payslips'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('7. Pay summary error state works properly with retry', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            payrollRepositoryProvider.overrideWithValue(MockErrorPayrollRepository()),
          ],
          child: const MaterialApp(
            home: PaySummaryScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unable to load Pay Summary.'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    test('8. Payslip PDF generation creates valid structured PDF document', () async {
      final detail = PayslipDetail(
        employeeId: '20140',
        employeeName: 'ANITHA K',
        department: 'RETAIL',
        designation: 'EXECUTIVE-SALES-ELIFE',
        location: 'DUBAI',
        currency: 'AED',
        payPeriod: 'JAN-2025',
        payMode: 'Cash',
        dateOfJoining: '01-Mar-2024',
        workDays: 31,
        paidLeave: 0,
        otHours: 0,
        lop: 0,
        earnings: [
          SalaryComponent(name: 'Basic Salary', amount: 975.00),
          SalaryComponent(name: 'Housing Allowance', amount: 300.00),
          SalaryComponent(name: 'Transportation Allowance', amount: 150.00),
          SalaryComponent(name: 'Other Allowance', amount: 75.00),
        ],
        deductions: [],
        totalEarnings: 1500.00,
        totalDeductions: 0.00,
        netPay: 1500.00,
      );

      final file = await PdfGenerator.generatePayslipPdf(detail);
      expect(file.existsSync(), isTrue);
      expect(file.lengthSync(), greaterThan(0));
    });

    testWidgets('9. Small-screen QA check: Payslip detail has no overflow on narrow screens', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PayslipDetailScreen(year: '2025', month: 'January'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Payslip Details'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    group('10. HR Payslip Management & Role Isolation', () {
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
