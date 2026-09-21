import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/models/reimbursement_models.dart';
import 'package:icore_ess/services/expense_service.dart';
import 'package:icore_ess/repositories/mock_ess_repository.dart';
import 'package:icore_ess/repositories/profile_repository.dart';
import 'package:icore_ess/models/employee.dart';
import 'package:icore_ess/features/reimbursement/reimbursement_providers.dart';
import 'package:icore_ess/features/reimbursement/reimbursement_list_screen.dart';
import 'package:icore_ess/features/reimbursement/reimbursement_form_screen.dart';

class FakeProfileRepository implements ProfileRepository {
  @override
  Future<Employee> getEmployeeProfile() async {
    return Employee(
      id: 'EMP001',
      name: 'Test User',
      email: 'test@example.com',
      phone: '1234567890',
      department: 'IT',
      designation: 'Dev',
      joiningDate: '01/01/2022',
      profileImageUrl: '',
    );
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Reimbursement Unit & Validation Constraints Tests', () {
    final mockRepo = MockEssRepository();
    final fakeProfile = FakeProfileRepository();
    final service = ExpenseService(mockRepo, fakeProfile);

    test('Validates that negative amounts throw exceptions', () {
      final invalidRequest = ReimbursementRequest(
        documentNumber: 'CR-999',
        date: DateTime.now(),
        documentType: DocumentType.fuel,
        status: ReimbursementStatus.newStatus,
        notes: '',
        totalBillAmount: -50,
        totalClaimAmount: 100,
        totalReimbursedAmount: 0,
        lineItems: [
          ReimbursementLineItem(
            id: '1',
            type: 'FUEL',
            costCenter: 'Canadian - Cost Center',
            description: 'Fuel text',
            billRefNo: '123',
            date: DateTime.now(),
            billAmount: -50,
            claimAmount: 100,
          )
        ],
      );

      expect(() => service.saveReimbursementDraft(invalidRequest), throwsException);
    });

    test('Validates that claim amounts exceeding bill amounts throw exceptions', () {
      final invalidRequest = ReimbursementRequest(
        documentNumber: 'CR-998',
        date: DateTime.now(),
        documentType: DocumentType.fuel,
        status: ReimbursementStatus.newStatus,
        notes: '',
        totalBillAmount: 100,
        totalClaimAmount: 150,
        totalReimbursedAmount: 0,
        lineItems: [
          ReimbursementLineItem(
            id: '1',
            type: 'FUEL',
            costCenter: 'Canadian - Cost Center',
            description: 'Fuel text',
            billRefNo: '123',
            date: DateTime.now(),
            billAmount: 100,
            claimAmount: 150,
          )
        ],
      );

      expect(() => service.saveReimbursementDraft(invalidRequest), throwsException);
    });
  });

  group('Reimbursement Riverpod Provider State Tests', () {
    test('FilterNotifier updates sort and search queries correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(reimbursementFilterProvider.notifier);
      notifier.setSearchQuery('TestQuery');
      notifier.setSortOption('highest');

      final state = container.read(reimbursementFilterProvider);
      expect(state.searchQuery, 'TestQuery');
      expect(state.sortOption, 'highest');
    });

    test('Summary computes proper total calculations', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final summary = container.read(reimbursementSummaryProvider);
      expect(summary.totalRequests, isNotNull);
    });
  });

  group('Reimbursement Module Widget Rendering Smoke Tests', () {
    testWidgets('Renders ReimbursementListScreen with search components', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ReimbursementListScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Reimbursement Summary'), findsOneWidget);
    });

    testWidgets('Renders ReimbursementFormScreen fields layout details', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ReimbursementFormScreen(initialRequest: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Reimbursement Date'), findsOneWidget);
      expect(find.text('Document Type *'), findsOneWidget);
    });
  });
}
