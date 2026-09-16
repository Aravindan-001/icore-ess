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

  group('Complete Application Regression QA Pass', () {
    setUp(() {
      DependencyInjection.reset();
      clearMockSecureStorage();
      DependencyInjection.setDependencies(locationService: MockLocationService());
    });

    testWidgets('6. Settings and Logout Regression', (WidgetTester tester) async {
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

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      final logoutButton = find.text('Logout');
      await tester.ensureVisible(logoutButton);
      await tester.tap(logoutButton);
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      
      expect(find.byKey(const Key('field_Employee ID')), findsOneWidget);
    });
  });
}
