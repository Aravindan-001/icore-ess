import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  Future<void> login(WidgetTester tester) async {
    await tester.pumpWidget(const ICoreEssApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'EMP001');
    await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), '123456');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  group('Claims and Reimbursement Functional Tests', () {
    testWidgets('Submit Medical Claim and verify it appears in list', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await login(tester);

      // Navigate to Claims
      await tester.tap(find.byIcon(Icons.grid_view_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Claims'));
      await tester.pumpAndSettle();

      // Initial count
      final initialItems = find.byType(Card).evaluate().length;

      // Submit new claim
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Medical');
      await tester.enterText(find.byType(TextFormField).at(1), 'New Medical Test');
      await tester.enterText(find.byType(TextFormField).at(2), '1000');
      await tester.tap(find.text('Submit Claim'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Medical claim submitted successfully'), findsOneWidget);
      expect(find.text('New Medical Test'), findsOneWidget);
      expect(find.text('Medical • ${DateFormat('dd MMM yyyy').format(DateTime.now())}'), findsOneWidget);
      expect(find.text('₹1000'), findsOneWidget);
      
      final finalItems = find.byType(Card).evaluate().length;
      expect(finalItems, initialItems + 1);
    });

    testWidgets('Submit Reimbursement and verify it appears in list', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await login(tester);

      // Navigate to Reimbursement
      await tester.tap(find.byIcon(Icons.grid_view_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reimburse'));
      await tester.pumpAndSettle();

      // Initial count
      final initialItems = find.byType(Card).evaluate().length;

      // Submit new reimbursement
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Travel');
      await tester.enterText(find.byType(TextFormField).at(1), 'New Travel Expense');
      await tester.enterText(find.byType(TextFormField).at(2), '500');
      await tester.tap(find.text('Submit Request'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Reimbursement request submitted'), findsOneWidget);
      expect(find.text('New Travel Expense'), findsOneWidget);
      expect(find.text('Travel • ${DateFormat('dd MMM yyyy').format(DateTime.now())}'), findsOneWidget);
      expect(find.text('₹500'), findsOneWidget);
      
      final finalItems = find.byType(Card).evaluate().length;
      expect(finalItems, initialItems + 1);
    });
  });
}
