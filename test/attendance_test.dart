import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/core/constants/app_constants.dart';
import 'package:icore_ess/core/providers/injection_providers.dart';
import 'package:icore_ess/services/location_service.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Attendance Module Regression Tests', () {
    late MockLocationService locationService;

    setUp(() {
      clearMockSecureStorage();
      locationService = MockLocationService();
    });

    Future<void> loginAndNavigate(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            locationServiceProvider.overrideWithValue(locationService),
          ],
          child: const ICoreEssApp(),
        ),
      );
      await tester.pumpAndBootstrap();
      await tester.enterText(find.byKey(const Key('field_Employee ID')), '20140');
      await tester.enterText(find.byKey(const Key('field_Password')), 'Employee@123');
      await tester.tap(find.text('Login'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      final attendanceFinder = find.text('Attendance');
      await tester.ensureVisible(attendanceFinder);
      await tester.tap(attendanceFinder);
      await tester.pumpAndSettle();
    }

    testWidgets('Initial loading and Not Marked state', (WidgetTester tester) async {
      locationService.setMockLocation(AppConstants.officeLatitude, AppConstants.officeLongitude);
      await loginAndNavigate(tester);

      expect(find.text('Today\'s Attendance'), findsOneWidget);
      expect(find.text('Not Marked'), findsOneWidget);
      expect(find.text('Office Location Verified'), findsOneWidget);
      expect(find.text('CHECK IN'), findsOneWidget);
    });

    testWidgets('Check In blocked when outside 50m', (WidgetTester tester) async {
      locationService.setMockLocation(AppConstants.officeLatitude + 0.01, AppConstants.officeLongitude + 0.01);
      await loginAndNavigate(tester);

      expect(find.text('Outside Office Area'), findsOneWidget);
      
      final checkInButton = find.text('CHECK IN');
      final elevatedButton = find.ancestor(of: checkInButton, matching: find.byType(ElevatedButton));
      expect(tester.widget<ElevatedButton>(elevatedButton).enabled, isFalse);
      
      expect(find.text('Move within 50m of office to mark attendance.'), findsOneWidget);
    });

    testWidgets('Successful Check In and state transition', (WidgetTester tester) async {
      locationService.setMockLocation(AppConstants.officeLatitude, AppConstants.officeLongitude);
      await loginAndNavigate(tester);

      await tester.tap(find.text('CHECK IN'));
      await tester.pump(); 
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.text('Checked In'), findsOneWidget);
      expect(find.text('CHECK OUT'), findsOneWidget);
      expect(find.text('Checked in successfully!'), findsOneWidget);
    });

    testWidgets('Successful Check Out and state transition', (WidgetTester tester) async {
      locationService.setMockLocation(AppConstants.officeLatitude, AppConstants.officeLongitude);
      await loginAndNavigate(tester);

      await tester.tap(find.text('CHECK IN'));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      await tester.tap(find.text('CHECK OUT'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Checked out successfully!'), findsOneWidget);
      expect(find.text("Today's attendance is complete."), findsOneWidget);
      expect(find.text('CHECK OUT'), findsNothing);
    });

    testWidgets('Pull to refresh updates attendance and location', (WidgetTester tester) async {
      locationService.setMockLocation(AppConstants.officeLatitude, AppConstants.officeLongitude);
      await loginAndNavigate(tester);

      expect(find.text('Distance: 0.0 m'), findsOneWidget);

      locationService.setMockLocation(AppConstants.officeLatitude + 0.0001, AppConstants.officeLongitude + 0.0001);
      
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 500));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text('Distance: 0.0 m'), findsNothing);
      expect(find.textContaining('Distance:'), findsOneWidget);
    });

    testWidgets('Displays poor accuracy warning', (WidgetTester tester) async {
      locationService.setMockLocation(
        AppConstants.officeLatitude, 
        AppConstants.officeLongitude,
        accuracy: AppConstants.maxAllowedAccuracyInMeters - 1,
      );
      
      await loginAndNavigate(tester);

      expect(find.text('Poor GPS accuracy. Move to an open area.'), findsOneWidget);
    });
   group('HR Attendance Viewing', () {
    testWidgets('HR can view employee profile with employment details', (WidgetTester tester) async {
       await tester.pumpWidget(const ProviderScope(child: ICoreEssApp()));
      await tester.pumpAndBootstrap();
      await tester.enterText(find.byKey(const Key('field_Employee ID')), 'HR001');
      await tester.enterText(find.byKey(const Key('field_Password')), 'HR@12345');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Employees'));
      await tester.pumpAndSettle();
      
      expect(find.text('Employee Management'), findsOneWidget);
      expect(find.text('ANITHA K'), findsOneWidget);
    });
  });
  });
}
