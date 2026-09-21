import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/injection_providers.dart';
import '../../models/dashboard_data.dart';
import '../notifications/notifications_provider.dart';

final dashboardProvider = AsyncNotifierProvider<DashboardNotifier, DashboardData>(() {
  return DashboardNotifier();
});

class DashboardNotifier extends AsyncNotifier<DashboardData> {
  @override
  Future<DashboardData> build() async {
    return _fetchDashboardData();
  }

  Future<DashboardData> _fetchDashboardData() async {
    final profileService = ref.watch(profileServiceProvider);
    final leaveService = ref.watch(leaveServiceProvider);
    final payrollService = ref.watch(payrollServiceProvider);
    final requestsService = ref.watch(requestsServiceProvider);

    // Fetch the notifications from the shared riverpod provider future stream
    final notificationsList = await ref.read(notificationsProvider.future);

    final (
      employee,
      employment,
      leaveBalances,
      paySummary,
      allRequests,
      payslips
    ) = await (
      profileService.getEmployeeProfile(),
      profileService.getEmploymentSummary(),
      leaveService.getLeaveBalances(),
      payrollService.getPaySummary(),
      requestsService.getAllRequests(),
      payrollService.getPayslips(),
    ).wait;

    final pendingReqs = allRequests
        .where((r) => r.status.toLowerCase() == 'pending')
        .take(3)
        .toList();
    
    final latestPayslip = payslips.isNotEmpty ? payslips.first : null;

    return DashboardData(
      employee: employee,
      employment: employment,
      leaveBalances: leaveBalances,
      recentNotifications: notificationsList.take(5).toList(),
      payslipSummary: paySummary,
      pendingRequests: pendingReqs,
      latestPayslip: latestPayslip,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchDashboardData());
  }
}
