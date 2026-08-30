import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/core/utils/dependency_injection.dart';
import 'package:icore_ess/services/location_service.dart';
import 'test_utils.dart';

class ErrorLocationService extends MockLocationService {
  LocationResult? _nextResult;

  void setNextResult(LocationResult result) {
    _nextResult = result;
  }

  @override
  Future<LocationResult> getLocationDetails() async {
    return _nextResult ?? await super.getLocationDetails();
  }
}

void main() {
  HttpOverrides.global = MockHttpOverrides();

  group('Attendance Permission UI Tests', () {
    late ErrorLocationService errorLocationService;

    setUp(() {
      errorLocationService = ErrorLocationService();
      DependencyInjection.setDependencies(locationService: errorLocationService);
    });

    Future<void> login(WidgetTester tester) async {
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
    }

    testWidgets('Shows GPS Disabled UI', (WidgetTester tester) async {
      errorLocationService.setNextResult(LocationResult.error('Disabled', isLocationServiceDisabled: true));
      
      await login(tester);
      await tester.tap(find.text('Attendance'));
      await tester.pumpAndSettle();

      expect(find.text('GPS Disabled'), findsOneWidget);
      expect(find.textContaining('Location services are turned off'), findsOneWidget);
    });

    testWidgets('Shows Permission Required UI', (WidgetTester tester) async {
      errorLocationService.setNextResult(LocationResult.error('Denied', isPermissionDenied: true));
      
      await login(tester);
      await tester.tap(find.text('Attendance'));
      await tester.pumpAndSettle();

      expect(find.text('Permission Required'), findsOneWidget);
      expect(find.text('Allow Access'), findsOneWidget);
    });

    testWidgets('Shows Permission Denied Forever UI', (WidgetTester tester) async {
      errorLocationService.setNextResult(LocationResult.error('Permanently Denied', isPermissionDeniedForever: true));
      
      await login(tester);
      await tester.tap(find.text('Attendance'));
      await tester.pumpAndSettle();

      expect(find.text('Permission Denied'), findsOneWidget);
      expect(find.text('Open Settings'), findsOneWidget);
    });
  });
}
