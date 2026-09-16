import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/dependency_injection.dart';
import '../../models/employee.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, AppConstants.settingsRoute),
          ),
        ],
      ),
      body: FutureBuilder<Employee>(
        future: DependencyInjection.profileService.getEmployeeProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile'));
          }
          final employee = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppConstants.spacing2Xl),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  backgroundImage: employee.profileImageUrl.isNotEmpty ? NetworkImage(employee.profileImageUrl) : null,
                  child: employee.profileImageUrl.isEmpty ? Icon(Icons.person, size: 60, color: colorScheme.primary) : null,
                ),
                const SizedBox(height: AppConstants.spacingLg),
                Text(employee.name, style: Theme.of(context).textTheme.displaySmall),
                Text(
                  employee.designation, 
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colorScheme.outline)
                ),
                const SizedBox(height: AppConstants.spacing3Xl),
                _buildProfileInfo(context, 'Employee ID', employee.id, Icons.badge),
                _buildProfileInfo(context, 'Department', employee.department, Icons.business),
                _buildProfileInfo(context, 'Email', employee.email, Icons.email),
                _buildProfileInfo(context, 'Phone', employee.phone, Icons.phone),
                _buildProfileInfo(context, 'Joining Date', employee.joiningDate, Icons.calendar_today),
                const SizedBox(height: AppConstants.spacing3Xl),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXl),
                  child: OutlinedButton(
                    onPressed: () => DependencyInjection.authService.logout(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      side: BorderSide(color: colorScheme.error),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Logout'),
                  ),
                ),
                const SizedBox(height: AppConstants.spacing4Xl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, String label, String value, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXl, vertical: AppConstants.spacingSm),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 20),
          const SizedBox(width: AppConstants.spacingLg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

}
