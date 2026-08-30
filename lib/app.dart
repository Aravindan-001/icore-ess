import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/attendance/attendance_screen.dart';
import 'features/claims/claims_screen.dart';
import 'features/leave/apply_leave_screen.dart';
import 'features/leave/leave_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/pay_summary/pay_summary_screen.dart';
import 'features/payslip/payslip_screen.dart';
import 'features/pre_order/pre_order_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/reimbursement/reimbursement_screen.dart';
import 'features/sales_order/sales_order_screen.dart';
import 'features/settings/settings_screen.dart';
import 'navigation/main_navigation.dart';

class ICoreEssApp extends StatelessWidget {
  const ICoreEssApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppConstants.loginRoute,
      routes: {
        AppConstants.loginRoute: (context) => const LoginScreen(),
        AppConstants.mainRoute: (context) => const MainNavigation(),
        AppConstants.profileRoute: (context) => const ProfileScreen(),
        AppConstants.leaveRoute: (context) => const LeaveScreen(),
        AppConstants.leaveApplyRoute: (context) => const ApplyLeaveScreen(),
        AppConstants.payslipRoute: (context) => const PayslipScreen(),
        AppConstants.paySummaryRoute: (context) => const PaySummaryScreen(),
        AppConstants.reimbursementRoute: (context) => const ReimbursementScreen(),
        AppConstants.claimsRoute: (context) => const ClaimsScreen(),
        AppConstants.preOrderRoute: (context) => const PreOrderScreen(),
        AppConstants.salesOrderRoute: (context) => const SalesOrderScreen(),
        AppConstants.notificationsRoute: (context) => const NotificationsScreen(),
        AppConstants.settingsRoute: (context) => const SettingsScreen(),
        AppConstants.attendanceRoute: (context) => const AttendanceScreen(),
      },
    );
  }
}
