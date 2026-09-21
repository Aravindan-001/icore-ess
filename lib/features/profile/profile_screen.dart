import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/injection_providers.dart';
import 'profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(employeeProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                Navigator.pushNamed(context, AppConstants.settingsRoute),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Profile main avatar card section
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFE2E8F0),
                        child: Icon(
                          Icons.person,
                          size: 44,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textMain,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.designation,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Employee ID: ${profile.id}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Profile info details list block
              _buildSectionTitle('Employment Details'),
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      _buildInfoTile(
                        'Department',
                        profile.department,
                        Icons.business,
                      ),
                      _buildInfoTile(
                        'Location',
                        'DUBAI',
                        Icons.location_on_outlined,
                      ),
                      _buildInfoTile(
                        'Date of Joining',
                        profile.joiningDate,
                        Icons.calendar_today_outlined,
                      ),
                      _buildInfoTile(
                        'Employment Status',
                        'Permanent',
                        Icons.assignment_ind_outlined,
                      ),
                      _buildInfoTile(
                        'Years of Service',
                        '0 Years 11 Months',
                        Icons.timeline,
                      ),
                      _buildInfoTile(
                        'Reporting Manager',
                        'Johnathan Doe (Visually Protected)',
                        Icons.security,
                        isProtected: true,
                      ),
                      _buildInfoTile(
                        'HR Manager',
                        'Sarah Smith (Visually Protected)',
                        Icons.security,
                        isProtected: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Navigation menu items
              _buildSectionTitle('Quick Actions'),
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.folder_shared_outlined,
                        color: AppTheme.primaryBlue,
                      ),
                      title: const Text(
                        'My Documents',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppConstants.documentsRoute,
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.lock_outline,
                        color: AppTheme.primaryBlue,
                      ),
                      title: const Text(
                        'Security Settings',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppConstants.settingsRoute,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Logout action button container
              OutlinedButton.icon(
                onPressed: () => ref.read(authServiceProvider).logout(context),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text(
                  'Logout Account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.error,
                  side: const BorderSide(color: AppTheme.error),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMuted,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    String label,
    String val,
    IconData icon, {
    bool isProtected = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.accentBlue, size: 20),
      dense: true,
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
      ),
      subtitle: Text(
        val,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isProtected ? Colors.grey.shade600 : AppTheme.textMain,
          fontStyle: isProtected ? FontStyle.italic : FontStyle.normal,
        ),
      ),
    );
  }
}
