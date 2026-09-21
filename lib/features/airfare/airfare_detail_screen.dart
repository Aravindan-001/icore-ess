import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../models/airfare.dart';
import 'airfare_provider.dart';

class AirfareDetailScreen extends ConsumerWidget {
  final String requestId;

  const AirfareDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final declarationAsync = ref.watch(airfareDetailProvider(requestId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Airfare Declaration Detail'),
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
                onPressed: () => ref.refresh(airfareDetailProvider(requestId)),
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
              _buildInfoSection('Travel Year', declaration.travelYear),
              _buildStatusSection('Status', declaration.status),
              
              const SizedBox(height: 8),
              _buildSectionTitle('Travel Details'),
              _buildInfoSection('From', declaration.fromLocation),
              _buildInfoSection('To', declaration.toLocation),
              if (declaration.travelDate != null)
                _buildInfoSection('Travel Date', DateFormat('dd MMMM yyyy').format(declaration.travelDate!)),
              _buildInfoSection('Travel Type', declaration.travelType),
              
              if (declaration.amount != null) ...[
                const SizedBox(height: 8),
                _buildSectionTitle('Financial Details'),
                _buildInfoSection('Amount', '₹${declaration.amount!.toStringAsFixed(2)}'),
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

  Widget _buildStatusSection(String label, AirfareStatus status) {
    Color color;
    switch (status) {
      case AirfareStatus.pending:
        color = AppTheme.warning;
        break;
      case AirfareStatus.approved:
        color = AppTheme.success;
        break;
      case AirfareStatus.rejected:
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
