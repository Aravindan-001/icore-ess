import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/core/widgets/service_card.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  testWidgets('Dashboard components test', (WidgetTester tester) async {
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

    expect(find.textContaining('Aravind Kumar'), findsOneWidget);
    expect(find.text('Leave Summary'), findsOneWidget);
    expect(find.byType(ServiceCard), findsAtLeastNWidgets(6));

    final leaveCard = find.text('Leave').last;
    await tester.ensureVisible(leaveCard);
    await tester.tap(leaveCard);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('Leave Management'), findsOneWidget);
  });
}
