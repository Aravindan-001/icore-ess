import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Orders modules verification', () {
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
    }

    testWidgets('Orders modules verification', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      final ordersFinder = find.widgetWithText(InkWell, 'Orders');
      await tester.ensureVisible(ordersFinder);
      await tester.tap(ordersFinder);
      await tester.pumpAndSettle();
      expect(find.text('Sales Orders'), findsOneWidget);
      expect(find.text('Order #SO-005'), findsOneWidget);
    });
  });
}
