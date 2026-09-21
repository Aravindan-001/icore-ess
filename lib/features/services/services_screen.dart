import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/service_card.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Services')),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
        children: [
          ServiceCard(
            title: 'Leave',
            icon: Icons.calendar_today,
            onTap: () => Navigator.pushNamed(context, AppConstants.leaveRoute),
          ),
          ServiceCard(
            title: 'Salary & Benefits',
            icon: Icons.payments,
            onTap: () => Navigator.pushNamed(context, AppConstants.salaryBenefitsRoute),
          ),
          ServiceCard(
            title: 'Attendance',
            icon: Icons.fingerprint,
            onTap: () => Navigator.pushNamed(context, AppConstants.attendanceRoute),
          ),
          ServiceCard(
            title: 'Claims',
            icon: Icons.request_quote,
            onTap: () => Navigator.pushNamed(context, AppConstants.claimsRoute),
          ),
          ServiceCard(
            title: 'Pre Order',
            icon: Icons.shopping_bag,
            onTap: () => Navigator.pushNamed(context, AppConstants.preOrderRoute),
          ),
          ServiceCard(
            title: 'Sales Order',
            icon: Icons.list_alt,
            onTap: () => Navigator.pushNamed(context, AppConstants.salesOrderRoute),
          ),
          ServiceCard(
            title: 'Notifications',
            icon: Icons.notifications,
            onTap: () => Navigator.pushNamed(context, AppConstants.notificationsRoute),
          ),
          ServiceCard(
            title: 'Settings',
            icon: Icons.settings,
            onTap: () => Navigator.pushNamed(context, AppConstants.settingsRoute),
          ),
        ],
      ),
    );
  }
}
