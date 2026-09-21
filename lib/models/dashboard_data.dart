import 'employee.dart';
import 'employment.dart';
import 'leave.dart';
import 'notification.dart';
import 'pay_summary.dart';
import 'unified_request.dart';
import 'payslip.dart';

class DashboardData {
  final Employee employee;
  final EmployeeEmployment employment;
  final List<LeaveBalance> leaveBalances;
  final List<AppNotification> recentNotifications;
  final PaySummary? payslipSummary;
  final List<UnifiedRequest> pendingRequests;
  final Payslip? latestPayslip;

  DashboardData({
    required this.employee,
    required this.employment,
    required this.leaveBalances,
    required this.recentNotifications,
    this.payslipSummary,
    required this.pendingRequests,
    this.latestPayslip,
  });
}
