import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });

  group('Login Flow Debugging Tests', () {
    testWidgets('TEST 1: Valid EMP001 / 123456 login succeeds', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'EMP001');
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), '123456');
      
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      await tester.tap(loginButton);
      await tester.pump();
      
      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // Verify Dashboard displayed
      expect(find.text('Aravind Kumar'), findsOneWidget);
      expect(find.text('Welcome Back'), findsNothing);
    });

    testWidgets('TEST 2: wrong Employee ID / 123456 fails', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'WRONG');
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), '123456');
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      expect(find.text('Invalid Employee ID or password.'), findsOneWidget);
      expect(find.text('Aravind Kumar'), findsNothing);
    });

    testWidgets('TEST 3: EMP001 / wrong password fails', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'EMP001');
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), 'wrong');
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      expect(find.text('Invalid Employee ID or password.'), findsOneWidget);
      expect(find.text('Aravind Kumar'), findsNothing);
    });

    testWidgets('TEST 4: empty Employee ID shows validation error', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), '123456');
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();
      
      expect(find.text('Please enter employee ID'), findsOneWidget);
    });

    testWidgets('TEST 5: empty password shows validation error', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'EMP001');
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();
      
      expect(find.text('Please enter password'), findsOneWidget);
    });

    testWidgets('TEST 6: both fields empty shows validation errors', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ICoreEssApp());
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();
      
      expect(find.text('Please enter employee ID'), findsOneWidget);
      expect(find.text('Please enter password'), findsOneWidget);
    });
  });
}
