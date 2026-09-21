import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../models/education_declaration.dart';
import 'education_provider.dart';

class EducationDetailScreen extends ConsumerWidget {
  final String requestId;

  const EducationDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final declarationAsync = ref.watch(educationDetailProvider(requestId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Declaration Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: declarationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Unable to load declaration details.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(educationDetailProvider(requestId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (declaration) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Declaration Summary'),
              _buildInfoSection('Declaration ID', declaration.id),
              _buildInfoSection('Academic/Financial Year', declaration.academicYear),
              _buildStatusSection('Status', declaration.status),
              
              const SizedBox(height: 8),
              _buildSectionTitle('Education Details'),
              _buildInfoSection('Institution Name', declaration.institutionName),
              _buildInfoSection('Course / Program', declaration.courseProgram),
              _buildInfoSection('Education Level', declaration.educationLevel),
              if (declaration.academicPeriod != null)
                _buildInfoSection('Academic Period', declaration.academicPeriod!),
              
              if (declaration.amount != null) ...[
                const SizedBox(height: 8),
                _buildSectionTitle('Financial Details'),
                _buildInfoSection('Claim Amount', '₹${declaration.amount!.toStringAsFixed(2)}'),
              ],
              
              const SizedBox(height: 8),
              _buildSectionTitle('Submission & Approval'),
              _buildInfoSection('Submitted Date', DateFormat('dd MMMM yyyy').format(declaration.submittedDate)),
              if (declaration.approvedBy != null)
                _buildInfoSection('Approved By', declaration.approvedBy!),
              if (declaration.approvalDate != null)
                _buildInfoSection('Approval Date', DateFormat('dd MMMM yyyy').format(declaration.approvalDate!)),
              if (declaration.remarks != null && declaration.remarks!.isNotEmpty)
                _buildInfoSection('Remarks', declaration.remarks!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
              letterSpacing: 1.0,
            ),
          ),
          const Divider(thickness: 1, height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(String label, EducationStatus status) {
    Color color;
    switch (status) {
      case EducationStatus.pending:
        color = AppTheme.warning;
        break;
      case EducationStatus.approved:
        color = AppTheme.success;
        break;
      case EducationStatus.rejected:
        color = AppTheme.error;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Text(
              status.name.toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
