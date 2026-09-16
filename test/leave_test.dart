import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/core/utils/dependency_injection.dart';
import 'package:icore_ess/services/location_service.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Leave Module Tests', () {
    late MockLocationService locationService;

    setUp(() {
      DependencyInjection.reset();
      clearMockSecureStorage();
      locationService = MockLocationService();
      DependencyInjection.setDependencies(locationService: locationService);
    });

    testWidgets('Leave management and application flow', (WidgetTester tester) async {
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

      // Use the navigation bar to go to Modules (previously Services)
      await tester.tap(find.byIcon(Icons.grid_view_outlined));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Leave').last);
      await tester.pumpAndSettle();

      // Switch to Leave Balance tab to see the "New Leave Request" button
      await tester.tap(find.text('Leave Balance'));
      await tester.pumpAndSettle();

      expect(find.text('Leave Balance'), findsWidgets);

      await tester.tap(find.text('New Leave Request'));
      await tester.pumpAndSettle();
      expect(find.text('Add Leave Request'), findsWidgets);

      final submitButton = find.text('Submit');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pump();
      expect(find.text('Required'), findsWidgets);

      await tester.enterText(find.byType(TextFormField).first, 'Vacation'); // Entering reason
      await tester.tap(submitButton);
      await tester.pump();
      
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text('Leave application submitted successfully'), findsWidgets);
    });
  });
}
