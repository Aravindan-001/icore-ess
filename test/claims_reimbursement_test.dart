import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/app.dart';
import 'package:icore_ess/models/reimbursement_models.dart';
import 'test_utils.dart';

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupSecureStorageMock();

  group('Claims and Reimbursement Functional Tests', () {
    setUp(() {
      clearMockSecureStorage();
    });

    Future<void> loginAndNavigate(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 3000);
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

    testWidgets('Submit Reimbursement and verify it appears in list', (WidgetTester tester) async {
      await loginAndNavigate(tester);
      await tester.tap(find.widgetWithText(InkWell, 'Reimbursement'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      
      // Select category
      await tester.tap(find.byType(DropdownButtonFormField<DocumentType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Travel').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(1), 'Trip to Dubai'); // Form Notes
      await tester.pumpAndSettle();

      // Add line item
      await tester.tap(find.text('Add Item'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      final dialogFields = find.byType(TextField);
      await tester.enterText(dialogFields.at(2), 'Business Trip'); // Description
      await tester.enterText(dialogFields.at(4), '1500'); // Bill Amount
      await tester.enterText(dialogFields.at(5), '1500'); // Claim Amount
      await tester.pumpAndSettle();
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add Line Item').last);
      await tester.pumpAndSettle();

      await tester.drag(find.byType(SingleChildScrollView).last, const Offset(0, -500));
      await tester.pumpAndSettle();

      final submitBtn = find.byKey(const Key('submit_reimbursement_button'));
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      
      await tester.tap(find.text('Confirm Submit'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Reimbursement submitted successfully!'), findsOneWidget);
      await tester.pumpAndSettle();
      
      expect(find.text('Trip to Dubai'), findsAtLeast(1));
    });
  });
}
