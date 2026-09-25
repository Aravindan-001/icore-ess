import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'profile_provider.dart';

class BasicInformationScreen extends ConsumerWidget {
  const BasicInformationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalInfoAsync = ref.watch(personalInfoProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Basic Information'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: personalInfoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
                const SizedBox(height: 16),
                const Text(
                  'Unable to load basic information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMain,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => ref.refresh(personalInfoProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (info) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('PERSONAL DETAILS'),
              _buildInfoGroup([
                _buildInfoItem('First Name', info.personalDetails.firstName),
                _buildInfoItem('Last Name', info.personalDetails.lastName),
                _buildInfoItem('Display Name', info.personalDetails.displayName),
                _buildInfoItem('Date of Birth', info.personalDetails.dateOfBirth),
                _buildInfoItem('Gender', info.personalDetails.gender),
                _buildInfoItem('Place of Birth', info.personalDetails.placeOfBirth),
                _buildInfoItem('Nationality', info.personalDetails.nationality),
                _buildInfoItem('Mother Tongue', info.personalDetails.motherTongue),
                _buildInfoItem('Blood Group', info.personalDetails.bloodGroup),
                _buildInfoItem('Marital Status', info.personalDetails.maritalStatus),
                _buildInfoItem('Residential Status', info.personalDetails.residentialStatus),
                _buildInfoItem('Disability', info.personalDetails.disability),
              ]),
              const SizedBox(height: 24),
              _buildSectionHeader('EMPLOYMENT DETAILS'),
              _buildInfoGroup([
                _buildInfoItem('Employee ID', info.employmentDetails.employeeId),
                _buildInfoItem('Legacy ID', info.employmentDetails.legacyId),
                _buildInfoItem('Joining Date', info.employmentDetails.joiningDate),
                _buildInfoItem('Grade', info.employmentDetails.grade),
                _buildInfoItem('Employment Type', info.employmentDetails.employmentType),
                _buildInfoItem('Point of Hire', info.employmentDetails.pointOfHire),
                _buildInfoItem('Department', info.employmentDetails.department),
                _buildInfoItem('Designation', info.employmentDetails.designation),
                _buildInfoItem('Location', info.employmentDetails.location),
                _buildInfoItem('Years of Service', info.employmentDetails.yearsOfService),
              ]),
              const SizedBox(height: 24),
              _buildSectionHeader('CONTACT INFORMATION'),
              _buildInfoGroup([
                _buildInfoItem('Mobile', info.contactInfo.mobile),
                _buildInfoItem('Phone', info.contactInfo.phone),
                _buildInfoItem('Official Email', info.contactInfo.officialEmail),
                _buildInfoItem('Personal Email', info.contactInfo.personalEmail),
              ]),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryBlue,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInfoGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outline, width: 0.5),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.outline, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textMain),
          ),
        ],
      ),
    );
  }
}
