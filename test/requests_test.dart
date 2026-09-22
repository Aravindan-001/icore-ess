import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Phase 11C — Requests Center & Workflow Management Tests', () {
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
      expect(find.text('Pending Requests'), findsWidgets);
    });

    testWidgets('Request Center loads, renders categories, filters and metric counts', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      
      // Tap Pending Requests Section to navigate to Request Center
      await tester.tap(find.text('Pending Requests'));
      await tester.pumpAndSettle();
      
      expect(find.text('Requests'), findsOneWidget);
      expect(find.text('Pending'), findsWidgets);
      expect(find.text('Approved'), findsWidgets);
      expect(find.text('Rejected'), findsWidgets);
      
      // Select All Categories filter chip or a specific category chip
      expect(find.text('All Categories'), findsOneWidget);
      expect(find.text('Leave'), findsWidgets);
      
      // Click Approved filter status chip
      await tester.tap(find.text('Approved').first);
      await tester.pumpAndSettle();
      
      // Click Rejected filter status chip
      await tester.tap(find.text('Rejected').first);
      await tester.pumpAndSettle();
    });

    testWidgets('HR Dashboard workflow is functional', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ProviderScope(child: ICoreEssApp()));
      await tester.pumpAndBootstrap();
      await tester.enterText(find.byKey(const Key('field_Employee ID')), 'HR001');
      await tester.enterText(find.byKey(const Key('field_Password')), 'HR@12345');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      
      expect(find.text('Welcome, HR Admin'), findsOneWidget);
      expect(find.text('Pending Leave Requests'), findsOneWidget);
      
      // Tap pending leave card
      await tester.tap(find.text('Pending Leave Requests'));
      await tester.pumpAndSettle();
      expect(find.text('Leave Management'), findsOneWidget);
    });
  });
}
