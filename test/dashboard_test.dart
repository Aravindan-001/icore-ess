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

  testWidgets('Dashboard components test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const ProviderScope(child: ICoreEssApp()));
    await tester.pumpAndBootstrap();
    
    await tester.enterText(find.byKey(const Key('field_Employee ID')), '20140');
    await tester.enterText(find.byKey(const Key('field_Password')), 'Employee@123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.textContaining('ANITHA K'), findsOneWidget);
    expect(find.text('Latest Net Pay'), findsOneWidget);
    
    // Check for quick actions - they are now in a GridView
    expect(find.text('My Payslips'), findsWidgets);
    expect(find.text('Leave'), findsWidgets);
    expect(find.text('Pay Summary'), findsWidgets);
    expect(find.text('Documents'), findsWidgets);

    final leaveCard = find.text('Leave').last;
    await tester.ensureVisible(leaveCard);
    await tester.tap(leaveCard);
    await tester.pumpAndSettle();
    
    expect(find.text('Compensatory Leave'), findsOneWidget);
    expect(find.text('Leave Request'), findsOneWidget);
  });
}
