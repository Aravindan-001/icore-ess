import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/employee.dart';
import 'profile_provider.dart';

class PersonalInformationLandingScreen extends ConsumerWidget {
  const PersonalInformationLandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeAsync = ref.watch(employeeProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: employeeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Error loading profile')),
        data: (employee) => SingleChildScrollView(
          child: Column(
            children: [
              _buildEmployeeSummary(context, employee),
              const SizedBox(height: 16),
              _buildNavSection(
                context,
                icon: Icons.person_outline,
                title: 'Basic Information',
                description: 'Personal, employment and contact details',
                route: AppConstants.basicInfoRoute,
              ),
              _buildNavSection(
                context,
                icon: Icons.family_restroom_outlined,
                title: 'Family Information',
                description: 'Family members and dependents',
                route: AppConstants.familyInfoRoute,
              ),
              _buildNavSection(
                context,
                icon: Icons.account_balance_outlined,
                title: 'Bank Information',
                description: 'Bank account and payment details',
                route: AppConstants.bankInfoRoute,
              ),
              _buildNavSection(
                context,
                icon: Icons.school_outlined,
                title: 'Education',
                description: 'Academic background and history',
                route: AppConstants.educationRoute,
              ),
              _buildNavSection(
                context,
                icon: Icons.description_outlined,
                title: 'Education Documents',
                description: 'Uploaded academic certificates',
                route: AppConstants.educationDocsRoute,
              ),
              _buildNavSection(
                context,
                icon: Icons.psychology_outlined,
                title: 'Skills',
                description: 'Technical and professional skills',
                route: AppConstants.skillsRoute,
              ),
              _buildNavSection(
                context,
                icon: Icons.badge_outlined,
                title: 'Identity',
                description: 'Government IDs and documents',
                route: AppConstants.identityRoute,
              ),
              _buildNavSection(
                context,
                icon: Icons.history_outlined,
                title: 'Work History',
                description: 'Previous employment records',
                route: AppConstants.workHistoryRoute,
              ),
              _buildNavSection(
                context,
                icon: Icons.verified_outlined,
                title: 'Certificates',
                description: 'Professional certifications',
                route: AppConstants.certificatesRoute,
              ),
              _buildNavSection(
                context,
                icon: Icons.pending_actions_outlined,
                title: 'Pending Requests',
                description: 'Profile update requests',
                route: AppConstants.profileRequestsRoute,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeSummary(BuildContext context, Employee employee) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
            backgroundImage: employee.profileImageUrl.isNotEmpty
                ? NetworkImage(employee.profileImageUrl)
                : null,
            child: employee.profileImageUrl.isEmpty
                ? const Icon(Icons.person, size: 40, color: AppTheme.primaryBlue)
                : null,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'ID: ${employee.id}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  employee.designation,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${employee.department} • Location',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    String? route,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        description,
        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.outline, size: 20),
      onTap: onTap ?? (route != null ? () => Navigator.pushNamed(context, route) : null),
    );
  }
}
