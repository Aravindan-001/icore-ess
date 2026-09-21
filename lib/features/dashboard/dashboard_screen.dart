import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/employee.dart';
import '../../models/payslip.dart';
import '../notifications/notifications_provider.dart';
import 'dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Row(
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                1, 0, 0, 0, 0,
                0, 1, 0, 0, 0,
                0, 0, 1, 0, 0,
                -1, -1, -1, 3, 0,
              ]),
              child: Image.asset(
                'assets/images/ebaconnect_logo.png',
                height: 32,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ebaConnect',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                Text(
                  'Employee Portal',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final unreadCount = ref.watch(unreadNotificationCountProvider);
              return Badge(
                label: Text(unreadCount.toString()),
                isLabelVisible: unreadCount > 0,
                backgroundColor: AppTheme.error,
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined, size: 22),
                  tooltip: 'Notifications',
                  onPressed: () =>
                      Navigator.pushNamed(context, AppConstants.notificationsRoute),
                ),
              );
            },
          ),
          IconButton(
            icon: const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
            tooltip: 'Profile',
            onPressed: () =>
                Navigator.pushNamed(context, AppConstants.profileRoute),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Section
                const Text(
                  'Good Morning,',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  data.employee.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textMain,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Employee Primary Information Card
                _buildEmployeeCard(data.employee, data.latestPayslip),
                const SizedBox(height: 24),

                // Quick Actions Grid Title
                const SizedBox(height: 8),

                // Grid layout of key shortcuts (3 columns)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                  children: [
                    _buildQuickActionItem(
                      context,
                      'My Payslips',
                      Icons.account_balance_wallet_outlined,
                      () {
                        Navigator.pushNamed(context, AppConstants.payslipRoute);
                      },
                    ),
                    _buildQuickActionItem(
                      context,
                      'Leave',
                      Icons.calendar_month_outlined,
                      () {
                        Navigator.pushNamed(context, AppConstants.leaveRoute);
                      },
                    ),
                    _buildQuickActionItem(
                      context,
                      'Pay Summary',
                      Icons.analytics_outlined,
                      () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.paySummaryRoute,
                        );
                      },
                    ),
                    _buildQuickActionItem(
                      context,
                      'Documents',
                      Icons.description_outlined,
                      () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.documentsRoute,
                        );
                      },
                    ),
                    _buildQuickActionItem(
                      context,
                      'Profile',
                      Icons.person_outline,
                      () {
                        Navigator.pushNamed(context, AppConstants.profileRoute);
                      },
                    ),
                    _buildQuickActionItem(
                      context,
                      'Attendance',
                      Icons.av_timer_outlined,
                      () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.attendanceRoute,
                        );
                      },
                    ),
                    _buildQuickActionItem(
                      context,
                      'Overtime',
                      Icons.more_time_outlined,
                      () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.overtimeRoute,
                        );
                      },
                    ),
                    _buildQuickActionItem(
                      context,
                      'Airfare',
                      Icons.flight_outlined,
                      () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.airfareRoute,
                        );
                      },
                    ),
                    _buildQuickActionItem(
                      context,
                      'Education',
                      Icons.school_outlined,
                      () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.educationDeclarationRoute,
                        );
                      },
                    ),
                    _buildQuickActionItem(
                      context,
                      'Reimbursement',
                      Icons.account_balance_outlined,
                      () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.reimbursementRoute,
                        );
                      },
                    ),
                    _buildQuickActionItem(
                      context,
                      'Claims',
                      Icons.assignment_outlined,
                      () {
                        Navigator.pushNamed(context, AppConstants.claimsRoute);
                      },
                    ),
                    _buildQuickActionItem(
                      context,
                      'Orders',
                      Icons.shopping_cart_outlined,
                      () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.salesOrderRoute,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(Employee employee, Payslip? latestPayslip) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildInfoRow('Employee ID', employee.id),
            _buildInfoRow('Department', employee.department),
            _buildInfoRow('Designation', employee.designation),
            _buildInfoRow('Location', 'DUBAI'),
            _buildInfoRow('Currency', 'AED'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(height: 1),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Latest Net Pay',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${latestPayslip?.currency ?? "AED"} ${latestPayslip?.netSalary.toStringAsFixed(2) ?? "1,500.00"}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Pay Period',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            latestPayslip?.payPeriod ?? 'JAN-2025',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textMain,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppTheme.primaryBlue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Primary button action: View Latest Payslip
            Builder(
              builder: (context) => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (latestPayslip != null) {
                      Navigator.pushNamed(
                        context,
                        AppConstants.payslipDetailRoute,
                        arguments: {
                          'year': latestPayslip.year,
                          'month': latestPayslip.month,
                        },
                      );
                    } else {
                      Navigator.pushNamed(context, AppConstants.payslipRoute);
                    }
                  },
                  icon: const Icon(Icons.description, size: 20),
                  label: const Text(
                    'View Latest Payslip',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.primaryBlue, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.textMain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
