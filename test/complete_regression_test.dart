import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/core/utils/dependency_injection.dart';
import 'package:icore_ess/services/location_service.dart';
import 'package:icore_ess/core/widgets/service_card.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();

  group('Complete Application Regression QA Pass', () {
    setUp(() {
      DependencyInjection.setDependencies(locationService: MockLocationService());
    });

    testWidgets('1. Authentication Flow Regression', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      
      // Verify Login screen renders
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Enter your employee ID'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Enter your password'), findsOneWidget);
      
      // Password visibility toggle
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Validation tests
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      await tester.tap(loginButton);
      await tester.pump();
      expect(find.text('Please enter employee ID'), findsOneWidget);
      expect(find.text('Please enter password'), findsOneWidget);

      // Correct credentials
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'EMP001');
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), '123456');
      await tester.tap(loginButton);
      
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Aravind Kumar'), findsOneWidget); // On Dashboard
    });

    testWidgets('2. Navigation and Dashboard Regression', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'EMP001');
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), '123456');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify Dashboard content
      expect(find.text('iCore ESS'), findsWidgets);
      expect(find.text('Aravind Kumar'), findsOneWidget);
      expect(find.text('Leave Summary'), findsOneWidget);
      expect(find.text('Services'), findsWidgets);
      
      // Test tab switching
      await tester.tap(find.byIcon(Icons.grid_view_outlined));
      await tester.pumpAndSettle();
      expect(find.text('All Services'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();
      expect(find.descendant(of: find.byType(AppBar), matching: find.text('Notifications')), findsOneWidget);

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      expect(find.descendant(of: find.byType(AppBar), matching: find.text('My Profile')), findsOneWidget);
      
      // Return to Dashboard
      await tester.tap(find.byIcon(Icons.dashboard_outlined));
      await tester.pumpAndSettle();
    });

    testWidgets('3. All Services Navigation Regression', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'EMP001');
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), '123456');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byIcon(Icons.grid_view_outlined));
      await tester.pumpAndSettle();

      final services = [
        'Leave', 'Payslip', 'Pay Summary', 'Claims', 'Reimburse', 'Attendance', 'Pre Order', 'Sales Order', 'Notifications', 'Settings'
      ];

      for (final service in services) {
        final card = find.widgetWithText(ServiceCard, service);
        await tester.ensureVisible(card);
        await tester.tap(card);
        await tester.pumpAndSettle();
        
        // Verify we navigated away from All Services
        expect(find.text('All Services'), findsNothing);
        
        // Go back
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.text('All Services'), findsOneWidget);
      }
    });

    testWidgets('4. Leave Module Regression', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'EMP001');
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), '123456');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('Leave').last);
      await tester.pumpAndSettle();
      
      expect(find.text('Leave Management'), findsOneWidget);
      expect(find.text('Leave Balance'), findsOneWidget);
      expect(find.text('Recent Requests'), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.text('Apply Leave'), findsWidgets);

      // Form validation
      await tester.tap(find.text('Submit Application'));
      await tester.pump();
      expect(find.text('Please enter a reason'), findsOneWidget);

      // Successful submission
      await tester.enterText(find.widgetWithText(TextFormField, 'Reason for leave'), 'Family vacation');
      await tester.tap(find.text('Submit Application'));
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Leave application submitted successfully'), findsOneWidget);
    });

    testWidgets('5. Payslip and Pay Summary Regression', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'EMP001');
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), '123456');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Payslip
      await tester.tap(find.text('Payslip'));
      await tester.pumpAndSettle();
      expect(find.text('Payslips'), findsOneWidget);
      expect(find.text('January 2024'), findsOneWidget);
      
      await tester.tap(find.text('January 2024'));
      await tester.pumpAndSettle();
      expect(find.text('Basic Salary'), findsOneWidget);
      expect(find.text('Download PDF'), findsOneWidget);
      
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Pay Summary
      await tester.tap(find.text('Pay Summary'));
      await tester.pumpAndSettle();
      expect(find.text('Pay Summary'), findsWidgets);
      expect(find.text('Annual Gross Pay'), findsOneWidget);
      expect(find.text('Monthly Breakdown'), findsOneWidget);
    });

    testWidgets('6. Settings and Logout Regression', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'EMP001');
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), '123456');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);

      // Toggles
      await tester.tap(find.byType(SwitchListTile).first);
      await tester.pump();
      
      // Logout
      final logoutButton = find.text('Logout');
      await tester.ensureVisible(logoutButton);
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();
      
      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('7. Other Modules Regression (Reimbursement, Claims, Orders)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'EMP001');
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), '123456');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byIcon(Icons.grid_view_outlined));
      await tester.pumpAndSettle();

      // Reimbursement
      await tester.tap(find.text('Reimburse'));
      await tester.pumpAndSettle();
      expect(find.text('Reimbursements'), findsOneWidget);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.text('New Reimbursement'), findsOneWidget);
      await tester.tap(find.text('Submit Request'));
      await tester.pumpAndSettle();
      expect(find.text('Reimbursement request submitted'), findsWidgets);
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Claims
      await tester.tap(find.text('Claims'));
      await tester.pumpAndSettle();
      expect(find.text('Medical Claims'), findsOneWidget);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.text('Create Medical Claim'), findsOneWidget);
      await tester.tap(find.text('Submit Claim'));
      await tester.pumpAndSettle();
      expect(find.text('Medical claim submitted successfully'), findsWidgets);
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Pre Order
      await tester.tap(find.text('Pre Order'));
      await tester.pumpAndSettle();
      expect(find.text('Company Store'), findsOneWidget);
      
      // Test quantity interaction
      await tester.tap(find.text('Add').first);
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
      expect(find.text('Place Order'), findsOneWidget);
      
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
      
      final placeOrderButton = find.widgetWithText(ElevatedButton, 'Place Order');
      await tester.ensureVisible(placeOrderButton);
      await tester.tap(placeOrderButton);
      await tester.pumpAndSettle();
      expect(find.text('Order placed successfully'), findsWidgets);

      await tester.pageBack();
      await tester.pumpAndSettle();

      // Sales Order
      await tester.tap(find.text('Sales Order'));
      await tester.pumpAndSettle();
      expect(find.text('Sales Orders'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Attendance
      await tester.tap(find.text('Attendance'));
      await tester.pumpAndSettle();
      expect(find.text('Attendance'), findsWidgets);
      
      // Initial state
      expect(find.text('Not Checked In'), findsOneWidget);
      expect(find.text('Office Location Verified'), findsOneWidget);
      
      // Check In
      await tester.tap(find.text('CHECK IN'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Currently Checked In'), findsOneWidget);
      
      // Check Out
      await tester.tap(find.text('CHECK OUT'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Attendance Completed'), findsOneWidget);
      expect(find.text("Today's attendance has been completed."), findsOneWidget);
    });
  });
}
