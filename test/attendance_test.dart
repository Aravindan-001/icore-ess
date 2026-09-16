import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/core/constants/app_constants.dart';
import 'package:icore_ess/core/utils/dependency_injection.dart';
import 'package:icore_ess/services/location_service.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Attendance Module Regression Tests', () {
    late MockLocationService locationService;

    setUp(() {
      DependencyInjection.reset();
      clearMockSecureStorage();
      locationService = MockLocationService();
      DependencyInjection.setDependencies(locationService: locationService);
    });

    testWidgets('Attendance initial state and navigation', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      // Reset to default office location
      locationService.setMockLocation(AppConstants.officeLatitude, AppConstants.officeLongitude);

      await tester.pumpWidget(const ICoreEssApp());
      await tester.pumpAndBootstrap();
      await tester.enterText(find.byKey(const Key('field_Employee ID')), 'EMP001');
      await tester.enterText(find.byKey(const Key('field_Password')), '123456');
      await tester.tap(find.text('Login'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.grid_view_outlined));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Attendance'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('Not Checked In'), findsOneWidget);
      expect(find.text('Office Location Verified'), findsOneWidget);
      expect(find.text('CHECK IN'), findsOneWidget);
    });

    testWidgets('Check In blocked when outside 50m', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      // Set location far away (e.g., ~1km away)
      locationService.setMockLocation(AppConstants.officeLatitude + 0.01, AppConstants.officeLongitude + 0.01);

      await tester.pumpWidget(const ICoreEssApp());
      await tester.pumpAndBootstrap();
      await tester.enterText(find.byKey(const Key('field_Employee ID')), 'EMP001');
      await tester.enterText(find.byKey(const Key('field_Password')), '123456');
      await tester.tap(find.text('Login'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.grid_view_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Attendance'));
      await tester.pumpAndSettle();

      expect(find.text('Outside Office Area'), findsOneWidget);
      
      final checkInButton = find.text('CHECK IN');
      expect(tester.widget<ElevatedButton>(find.ancestor(of: checkInButton, matching: find.byType(ElevatedButton))).enabled, isFalse);
    });

    testWidgets('Full Attendance Flow: Check In -> Check Out', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      // Within geofence
      locationService.setMockLocation(AppConstants.officeLatitude, AppConstants.officeLongitude);

      await tester.pumpWidget(const ICoreEssApp());
      await tester.pumpAndBootstrap();
      await tester.enterText(find.byKey(const Key('field_Employee ID')), 'EMP001');
      await tester.enterText(find.byKey(const Key('field_Password')), '123456');
      await tester.tap(find.text('Login'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.grid_view_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Attendance'));
      await tester.pumpAndSettle();

      // Check In
      await tester.tap(find.text('CHECK IN'));
      await tester.pump(); // Start loading
      
      // Verify loading state prevents duplicate taps (button should be disabled or shows indicator)
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text('Currently Checked In'), findsOneWidget);
      expect(find.text('CHECK OUT'), findsOneWidget);
      expect(find.text('Checked in successfully!'), findsOneWidget);
      
      // Verify Check In time is displayed (not just --:--)
      expect(find.text('--:--'), findsOneWidget); // Check Out is still --:--
      expect(find.textContaining(RegExp(r'\d{2}:\d{2}')), findsWidgets);

      // Check Out
      await tester.tap(find.text('CHECK OUT'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();

      expect(find.text('Attendance Completed'), findsWidgets);
      expect(find.text('Checked out successfully!'), findsWidgets);
      expect(find.text("Today's attendance has been completed."), findsOneWidget);
    });

    testWidgets('Location refresh updates distance', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      // Start within geofence
      locationService.setMockLocation(AppConstants.officeLatitude, AppConstants.officeLongitude);

      await tester.pumpWidget(const ICoreEssApp());
      await tester.pumpAndBootstrap();
      await tester.enterText(find.byKey(const Key('field_Employee ID')), 'EMP001');
      await tester.enterText(find.byKey(const Key('field_Password')), '123456');
      await tester.tap(find.text('Login'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.grid_view_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Attendance'));
      await tester.pumpAndSettle();

      expect(find.text('Office Location Verified'), findsOneWidget);
      expect(find.textContaining('0.0 m'), findsOneWidget);

      // Move outside
      locationService.setMockLocation(AppConstants.officeLatitude + 0.01, AppConstants.officeLongitude + 0.01);
      
      // Tap refresh
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(); // This should be enough to show the result after loading

      expect(find.text('Outside Office Area'), findsOneWidget);
      expect(find.textContaining('0.0 m'), findsNothing);
    });
  });
}
