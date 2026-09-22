import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Phase 11B — Notifications & Alerts Module Tests', () {
    setUp(() {
      clearMockSecureStorage();
    });

    Future<void> login(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ProviderScope(child: ICoreEssApp()));
      await tester.pumpAndBootstrap();
      await tester.pumpAndSettle(); // Ensure any transitions are done
      await tester.enterText(find.byKey(const Key('field_Employee ID')), '20140');
      await tester.enterText(find.byKey(const Key('field_Password')), 'Employee@123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
    }

    testWidgets('Dashboard displays unread notification badge', (WidgetTester tester) async {
      await login(tester);
      
      // Total unread: 6
      expect(find.text('6'), findsOneWidget); // The badge label
    });

    testWidgets('Notifications screen loads and displays items with categories', (WidgetTester tester) async {
      await login(tester);
      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Notifications'), findsWidgets);
      expect(find.text('Leave Approved'), findsOneWidget);
      expect(find.textContaining('Leave'), findsWidgets); 
      expect(find.text('Attendance Reminder'), findsOneWidget);
      expect(find.textContaining('Attendance'), findsWidgets);
    });

    testWidgets('Filtering by Unread works', (WidgetTester tester) async {
      await login(tester);
      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();
      
      // Initially "All" is selected
      expect(find.text('Leave Approved'), findsOneWidget); // Unread
      expect(find.text('Holiday Reminder'), findsOneWidget); // Read

      // Tap "Unread" filter
      await tester.tap(find.textContaining('Unread'));
      await tester.pumpAndSettle();
      
      expect(find.text('Leave Approved'), findsOneWidget);
      expect(find.text('Holiday Reminder'), findsNothing);
    });

    testWidgets('Mark as Read updates UI and Dashboard count immediately', (WidgetTester tester) async {
      await login(tester);
      
      // 1. Initial count is 6
      expect(find.text('6'), findsOneWidget);

      // 2. Open notifications
      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();
      
      // 3. Tap on "Leave Approved" (marks as read and navigates)
      await tester.tap(find.text('Leave Approved'));
      await tester.pumpAndSettle();
      
      // 4. Verify deep link navigation to Leave Request screen
      expect(find.text('Leave Request'), findsWidgets); 
      
      // 5. Go back to Notifications
      await tester.pageBack();
      await tester.pumpAndSettle();

      // 6. Go back to Dashboard
      await tester.pageBack();
      await tester.pumpAndSettle();

      // 7. Verify count decreased to 5
      expect(find.text('5'), findsOneWidget);
      expect(find.text('6'), findsNothing);
    });

    testWidgets('Mark all as read works', (WidgetTester tester) async {
      await login(tester);
      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byIcon(Icons.done_all));
      await tester.pumpAndSettle();
      
      // All should be read now. Filter by "Unread" should show empty state
      await tester.tap(find.textContaining('Unread'));
      await tester.pumpAndSettle();
      
      expect(find.text('No Notifications'), findsOneWidget);
      
      // Go back to Dashboard
      await tester.pageBack();
      await tester.pumpAndSettle();
      
      // Badge should be gone
      expect(find.text('0'), findsNothing);
    });

    testWidgets('Pull to refresh works on Notifications screen', (WidgetTester tester) async {
      await login(tester);
      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();
      
      await tester.drag(find.byType(ListView), const Offset(0, 500));
      await tester.pump();
      expect(find.byType(RefreshIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    });
   group('Small screen UI check', () {
    testWidgets('Notifications list does not overflow on small screens', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 480); // Very small screen
      tester.view.devicePixelRatio = 1.0;
      
      await login(tester);
      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();
      
      expect(tester.takeException(), isNull);
    });
  });
  });
}
