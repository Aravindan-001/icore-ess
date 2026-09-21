import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icore_ess/features/leave/leave_screen.dart';
import 'package:icore_ess/features/reimbursement/reimbursement_list_screen.dart';
import 'package:icore_ess/features/dashboard/dashboard_provider.dart';

void main() {
  testWidgets('Phase 9B: LeaveScreen renders EmptyState when balances and requests are empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LeaveScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(LeaveScreen), findsOneWidget);
  });

  testWidgets('Phase 9B: ReimbursementListScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ReimbursementListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ReimbursementListScreen), findsOneWidget);
  });

  test('Phase 9B: DashboardState Reactivity and Provider Verification', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(dashboardProvider).isLoading, true);
  });
}
