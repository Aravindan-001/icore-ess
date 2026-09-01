import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dependency_injection.dart';
import '../../core/utils/session_manager.dart';
import '../../models/employee.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
        future: DependencyInjection.repository.getEmployeeProfile(),
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
                const SizedBox(height: 24),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: employee.profileImageUrl.isNotEmpty ? NetworkImage(employee.profileImageUrl) : null,
                  child: employee.profileImageUrl.isEmpty ? const Icon(Icons.person, size: 60) : null,
                ),
                const SizedBox(height: 16),
                Text(employee.name, style: Theme.of(context).textTheme.displaySmall),
                Text(employee.designation, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textGrey)),
                const SizedBox(height: 32),
                _buildProfileInfo(context, 'Employee ID', employee.id, Icons.badge),
                _buildProfileInfo(context, 'Department', employee.department, Icons.business),
                _buildProfileInfo(context, 'Email', employee.email, Icons.email),
                _buildProfileInfo(context, 'Phone', employee.phone, Icons.phone),
                _buildProfileInfo(context, 'Joining Date', employee.joiningDate, Icons.calendar_today),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      SessionManager.clearSession();
                      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                        AppConstants.loginRoute, 
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.error,
                      side: const BorderSide(color: AppTheme.error),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Logout'),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 20),
          const SizedBox(width: 16),
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
