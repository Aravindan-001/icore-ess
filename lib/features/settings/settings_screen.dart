import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dependency_injection.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SettingsSection(title: 'Preferences'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive alerts about leave and payroll'),
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
            activeThumbColor: AppTheme.primaryBlue,
          ),
          SwitchListTile(
            title: const Text('Biometric Login'),
            subtitle: const Text('Use Fingerprint / Face ID to login'),
            value: _biometricEnabled,
            onChanged: (value) => setState(() => _biometricEnabled = value),
            activeThumbColor: AppTheme.primaryBlue,
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('English (US)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const _SettingsSection(title: 'Security'),
          ListTile(
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
              );
            },
          ),
          const _SettingsSection(title: 'App Info'),
          ListTile(
            title: const Text('About ebaConnect'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () {},
          ),
          if (kDebugMode) ...[
            const _SettingsSection(title: 'Developer Tools'),
            ListTile(
              title: const Text('Trigger Test Crash'),
              subtitle: const Text('Verification for Firebase Crashlytics'),
              trailing: const Icon(Icons.bug_report, color: Colors.orange),
              onTap: () {
                debugPrint('Firebase Crashlytics: Triggering manual test crash...');
                FirebaseCrashlytics.instance.crash();
              },
            ),
          ],
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: () => DependencyInjection.authService.logout(context),
              child: const Text('Logout', style: TextStyle(color: AppTheme.error)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  const _SettingsSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}
