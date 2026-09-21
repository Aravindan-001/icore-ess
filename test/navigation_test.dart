import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  setUp(() {
    clearMockSecureStorage();
  });

  testWidgets('Bottom Navigation flow test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const ProviderScope(child: ICoreEssApp()));
    await tester.pumpAndBootstrap();

    await tester.enterText(find.byKey(const Key('field_Employee ID')), '20140');
    await tester.enterText(find.byKey(const Key('field_Password')), 'Employee@123');
    await tester.tap(find.text('Login'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('ebaConnect'), findsWidgets);

    // Navigate to Payslips via Bottom Nav
    await tester.tap(find.byIcon(Icons.receipt_long_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Payslips'), findsWidgets);

    // Navigate back to Home
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

    // Navigate to Notifications via App Bar
    await tester.tap(find.byIcon(Icons.notifications_outlined));
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('Notifications')), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Navigate to Profile via Bottom Nav
    await tester.tap(find.byIcon(Icons.person_outline).last);
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('My Profile')), findsOneWidget);
  });
}
