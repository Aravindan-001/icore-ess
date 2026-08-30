import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();

  testWidgets('Leave management and application flow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const ICoreEssApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Enter your employee ID'), 'EMP001');
    await tester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), '123456');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.text('Leave').last);
    await tester.pumpAndSettle();

    expect(find.text('Leave Balance'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Apply Leave'), findsWidgets);

    final submitButton = find.text('Submit Application');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();
    expect(find.text('Please enter a reason'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Reason for leave'), 'Vacation');
    await tester.tap(submitButton);
    await tester.pump();
    
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Leave application submitted successfully'), findsOneWidget);
  });
}
