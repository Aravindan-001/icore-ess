import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/injection_providers.dart';
import 'features/auth/bootstrap_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/attendance/attendance_screen.dart';
import 'features/claims/claims_screen.dart';
import 'features/leave/apply_leave_screen.dart';
import 'features/leave/leave_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/requests/requests_screen.dart';
import 'features/salary_benefits/salary_benefits_screen.dart';
import 'features/pay_summary/pay_summary_screen.dart';
import 'features/payslip/payslip_screen.dart';
import 'features/payslip/payslip_detail_screen.dart';
import 'features/overtime/overtime_list_screen.dart';
import 'features/overtime/overtime_detail_screen.dart';
import 'features/airfare/airfare_list_screen.dart';
import 'features/airfare/airfare_detail_screen.dart';
import 'features/education/education_list_screen.dart';
import 'features/education/education_detail_screen.dart';
import 'features/pre_order/pre_order_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/profile/personal_info_landing_screen.dart';
import 'features/profile/basic_info_screen.dart';
import 'features/profile/family_info_screen.dart';
import 'features/profile/bank_info_screen.dart';
import 'features/profile/education_screen.dart';
import 'features/profile/education_docs_screen.dart';
import 'features/profile/skills_screen.dart';
import 'features/profile/identity_screen.dart';
import 'features/profile/work_history_screen.dart';
import 'features/profile/certificates_screen.dart';
import 'features/profile/profile_requests_screen.dart';
import 'features/reimbursement/reimbursement_list_screen.dart';
import 'features/reimbursement/reimbursement_form_screen.dart';
import 'models/reimbursement_models.dart';
import 'features/sales_order/sales_order_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/documents/documents_screen.dart';
import 'features/hr/hr_dashboard_screen.dart';
import 'features/hr/hr_employee_list_screen.dart';
import 'features/hr/hr_leave_requests_screen.dart';
import 'features/hr/hr_payslip_mgmt_screen.dart';
import 'navigation/main_navigation.dart';

class ICoreEssApp extends ConsumerWidget {
  const ICoreEssApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigatorKey = ref.watch(navigatorKeyProvider);
    
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppConstants.bootstrapRoute,
      routes: {
        AppConstants.bootstrapRoute: (context) => const BootstrapScreen(),
        AppConstants.loginRoute: (context) => const LoginScreen(),
        AppConstants.mainRoute: (context) => const MainNavigation(),
        AppConstants.profileRoute: (context) => const ProfileScreen(),
        AppConstants.attendanceRoute: (context) => const AttendanceScreen(),
        AppConstants.leaveRoute: (context) => const LeaveScreen(),
        AppConstants.leaveApplyRoute: (context) => const ApplyLeaveScreen(),
        AppConstants.salaryBenefitsRoute: (context) => const SalaryBenefitsScreen(),
        AppConstants.payslipRoute: (context) => const PayslipScreen(),
        AppConstants.overtimeRoute: (context) => const OvertimeListScreen(),
        AppConstants.airfareRoute: (context) => const AirfareListScreen(),
        AppConstants.educationDeclarationRoute: (context) => const EducationListScreen(),
        AppConstants.paySummaryRoute: (context) => const PaySummaryScreen(),
        AppConstants.reimbursementRoute: (context) => const ReimbursementListScreen(),
        AppConstants.claimsRoute: (context) => const ClaimsScreen(),
        AppConstants.preOrderRoute: (context) => const PreOrderScreen(),
        AppConstants.salesOrderRoute: (context) => const SalesOrderScreen(),
        AppConstants.notificationsRoute: (context) => const NotificationsScreen(),
        AppConstants.requestsRoute: (context) => const RequestsScreen(),
        AppConstants.settingsRoute: (context) => const SettingsScreen(),
        AppConstants.documentsRoute: (context) => const DocumentsScreen(),
        AppConstants.personalInfoLandingRoute: (context) => const PersonalInformationLandingScreen(),
        AppConstants.basicInfoRoute: (context) => const BasicInformationScreen(),
        AppConstants.familyInfoRoute: (context) => const FamilyInformationScreen(),
        AppConstants.bankInfoRoute: (context) => const BankInformationScreen(),
        AppConstants.educationRoute: (context) => const EducationScreen(),
        AppConstants.educationDocsRoute: (context) => const EducationDocsScreen(),
        AppConstants.skillsRoute: (context) => const SkillsScreen(),
        AppConstants.identityRoute: (context) => const IdentityScreen(),
        AppConstants.workHistoryRoute: (context) => const WorkHistoryScreen(),
        AppConstants.certificatesRoute: (context) => const CertificatesScreen(),
        AppConstants.profileRequestsRoute: (context) => const ProfileRequestsScreen(),
        // HR Specific Routes
        '/hr/dashboard': (context) => const HrDashboardScreen(),
        '/hr/employees': (context) => const HrEmployeeListScreen(),
        '/hr/leaves': (context) => const HrLeaveRequestsScreen(),
        '/hr/payslips': (context) => const HrPayslipMgmtScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppConstants.payslipDetailRoute) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => PayslipDetailScreen(
              year: args['year'],
              month: args['month'],
            ),
          );
        }
        if (settings.name == AppConstants.overtimeDetailRoute) {
          final requestId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => OvertimeDetailScreen(requestId: requestId),
          );
        }
        if (settings.name == AppConstants.airfareDetailRoute) {
          final requestId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => AirfareDetailScreen(requestId: requestId),
          );
        }
        if (settings.name == AppConstants.educationDeclarationDetailRoute) {
          final requestId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => EducationDetailScreen(requestId: requestId),
          );
        }
        if (settings.name == '/reimbursement/form') {
          final request = settings.arguments as ReimbursementRequest?;
          return MaterialPageRoute(
            builder: (context) => ReimbursementFormScreen(initialRequest: request),
          );
        }
        return null;
      },
    );
  }
}
