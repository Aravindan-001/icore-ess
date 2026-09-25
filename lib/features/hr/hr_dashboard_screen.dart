import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../notifications/notifications_provider.dart';

class HrDashboardScreen extends StatelessWidget {
  const HrDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'ebaConnect HR',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5, height: 1.1),
                ),
                Text(
                  'Admin Portal',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.2),
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
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => Navigator.pushNamed(context, AppConstants.notificationsRoute),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, HR Admin',
              style: TextStyle(fontSize: 15, color: AppTheme.textMuted, fontWeight: FontWeight.w500),
            ),
            const Text(
              'Dashboard Overview',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textMain, letterSpacing: -0.5),
            ),
            const SizedBox(height: 20),

            // Statistics Row
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Employees', '125', Icons.people, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Active', '120', Icons.check_circle, Colors.green)),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              'Pending Leave Requests', 
              '2', 
              Icons.pending_actions, 
              Colors.orange, 
              isFullWidth: true,
              onTap: () => Navigator.pushNamed(context, AppConstants.hrLeavesRoute),
            ),
            
            const SizedBox(height: 24),
            const Text(
              'Management Modules',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain),
            ),
            const SizedBox(height: 12),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildModuleCard(
                  context,
                  'Employee Management',
                  Icons.badge_outlined,
                  () => Navigator.pushNamed(context, AppConstants.hrEmployeesRoute),
                ),
                _buildModuleCard(
                  context,
                  'Leave Management',
                  Icons.event_note_outlined,
                  () => Navigator.pushNamed(context, AppConstants.hrLeavesRoute),
                ),
                _buildModuleCard(
                  context,
                  'Payslip Management',
                  Icons.payments_outlined,
                  () => Navigator.pushNamed(context, AppConstants.hrPayslipsRoute),
                ),
                _buildModuleCard(
                  context,
                  'Documents',
                  Icons.folder_shared_outlined,
                  () => Navigator.pushNamed(context, AppConstants.documentsRoute),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, {bool isFullWidth = false, VoidCallback? onTap}) {
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppTheme.primaryBlue, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textMain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
