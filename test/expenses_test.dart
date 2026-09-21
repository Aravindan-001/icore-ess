import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Expenses Modules QA', () {
    setUp(() {
      clearMockSecureStorage();
    });

    Future<void> loginAndNavigate(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ProviderScope(child: ICoreEssApp()));
      await tester.pumpAndBootstrap();
      await tester.enterText(find.byKey(const Key('field_Employee ID')), '20140');
      await tester.enterText(find.byKey(const Key('field_Password')), 'Employee@123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('Reimbursement screen verification', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      final reimFinder = find.widgetWithText(InkWell, 'Reimbursement');
      await tester.ensureVisible(reimFinder);
      await tester.tap(reimFinder);
      await tester.pumpAndSettle();
      expect(find.text('Reimbursements'), findsWidgets);
      expect(find.text('Cancelled fuel request'), findsOneWidget);
    });

    testWidgets('Claims screen verification', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      final claimsFinder = find.text('Claims');
      await tester.ensureVisible(claimsFinder);
      await tester.tap(claimsFinder);
      await tester.pumpAndSettle();
      expect(find.text('Medical Claims'), findsOneWidget);
      expect(find.text('Health Checkup'), findsOneWidget);
    });
  });
}
